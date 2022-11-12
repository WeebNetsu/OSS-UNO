require "src.game.com"
require "src.game.card"
require "src.game.player"
require "src.game.played_deck"
require "src.utils.sfx"

local love = require "love"
local utils = require("src.utils.utils")

local function Com(deck: DeckType, playedDeck: PlayedDeckType, sfx: SFXType): ComType
    local com: ComType = {}
    -- level 1 = easy, 2 = normal, 3 = hard
    local settings = utils.readJSON("settings")
    local level: integer = 2
    local played_uno_sfx = false

    if settings.difficulty ~= nil then
        level = settings.difficulty
    end

    com.defaultXPos = utils.cardWidth / 1.5
    com.defaultYPos = 20

    com.cards = {}
    com.skipTurn = false
    com.saidUno = false

    -- will set the initial 8 cards
    com.setCards = function (self: ComType, num: number)
        for i = 1, num do
            local card = deck:drawCard(self.defaultXPos * i, self.defaultYPos, true)

            if card == nil then
                deck:generateDeck(self.cards as {string: CardType})
                i = i - 1
            else
                table.insert(self.cards, card)
            end
        end
    end

    com.updateCardPositions = function (self: ComType)
        for i = 1, #self.cards do
            local card: CardType = self.cards[i]
            card:setPosition(self.defaultXPos * i, self.defaultYPos)
        end
    end

    com.addCard = function (self: ComType, card: CardType)
        table.insert(self.cards, card)
    end

    com.removeCard = function (self: ComType, index: number)
        table.remove(self.cards, index)
        self:updateCardPositions()
    end

    com.getCard = function (self: ComType, index: integer): CardType
        return self.cards[index]
    end

    com.drawCard = function (self: ComType): CardType
        if self.saidUno then
            self.saidUno = false
        end

        return deck:drawCard(self.defaultXPos * #self.cards + self.defaultXPos, self.defaultYPos, true)
    end

    com.draw = function (self: ComType)
        for _index, card in ipairs(self.cards) do
            -- true -> card back is shown
            -- false -> actual card is shown
            card:draw(nil, true)
        end

        if self.saidUno then
            if not played_uno_sfx then
                sfx:setFXPlayed(false)
                sfx:playFX("said_uno_female", "single")
                played_uno_sfx = true
            end
            love.graphics.print("COM HAS UNO'D!", 50, 10)
        else
            played_uno_sfx = false
        end
    end

    com.play = function (self: ComType, player: PlayerType)
        if self.skipTurn then
            player:setPlayerTurn(true)
            self.skipTurn = false
            return
        end

        local lastPlayedCard = playedDeck.cards[#playedDeck.cards]
        local playableCards = {}

        for ind, card in ipairs(self.cards) do
            card.playable = false

            if not player.playerTurn then
                if card.number ~= nil and card.number == lastPlayedCard.number then
                    table.insert(playableCards, {index = ind, card = card})
                elseif card.color ~= nil then
                    if card.color == lastPlayedCard.color then
                        table.insert(playableCards, {index = ind, card = card})
                    end

                    if (not card.playable) and lastPlayedCard.specialName ~= nil then
                        if card.specialName == lastPlayedCard.specialName then
                            table.insert(playableCards, {index = ind, card = card})
                        end
                    end

                    if (not card.playable) and (playedDeck.lastColor == card.color) then
                        table.insert(playableCards, {index = ind, card = card})
                    end
                else
                    for _, cardName in ipairs(utils.powerCards) do
                        -- the bot is not allowed to play another +2 if they already played a +2
                        -- if the bot is on easy mode
                        -- if bot is not on easy and the last played card was not a +2/+4
                        if not (level == 1 and (lastPlayedCard.specialName == cardName)) then
                            if cardName == card.specialName then
                                table.insert(playableCards, {index = ind, card = card})
                                break
                            end
                        end
                    end
                end
            end
        end

        if #playableCards > 0 then
            -- if bot can throw a +2 or +4 as a chain, and is not on 'easy' mode
            if playedDeck.chainCount > 0 and level ~= 1 then
                local successfulChain = false
                -- if +4 or +2 card
                -- picker = +2 card
                if lastPlayedCard.specialName == "wild pick four" or lastPlayedCard.specialName == "picker" then
                    for _, card in ipairs(playableCards) do
                        if card.card.specialName == lastPlayedCard.specialName then
                            playedDeck:addCard(card.card, true, player, self)
                            self:removeCard(card.index)
                            successfulChain = true
                        end
                    end
                end

                if not successfulChain then
                    local drawCount = 4
                    if lastPlayedCard.specialName == "picker" then
                        drawCount = 2
                    end

                    drawCount = drawCount * playedDeck.chainCount

                    for _ = 1, drawCount do
                        self:addCard(utils.drawCardOrGenerateDeck(player, com, deck, true))
                    end

                    playedDeck.chainCount = 0
                end
            else
                -- choose random item in playableCards table
                local randomIndex = math.random(1, #playableCards)
                local card = playableCards[randomIndex]
    
                for _, powerCard in ipairs(utils.powerCards)do
                    if card.card.specialName == powerCard then
                        playedDeck:pickColor(true, self)
                    end
                end
    
                playedDeck:addCard(card.card, true, player, self)
                self:removeCard(card.index)
            end
        else
            local drawCount = 1

            if playedDeck.chainCount > 0 then
                if lastPlayedCard.specialName == "wild pick four" then
                    drawCount = drawCount * 4 * playedDeck.chainCount
                elseif lastPlayedCard.specialName == "picker" then
                    drawCount = drawCount * 2 * playedDeck.chainCount
                end

                playedDeck.chainCount = 0
            end

            for _ = 1, drawCount do
                self:addCard(utils.drawCardOrGenerateDeck(player, self, deck, true))
            end
        end

        if #self.cards == 2 and not player.playerTurn then
            if settings.difficulty == 1 then
                -- if on easy mode
                -- random 50% chance that saidUno is true
                self.saidUno = math.random(1, 10) < 6
            elseif settings.difficulty == 2 then
                -- if on normal mode
                -- random 70% chance that saidUno is true
                self.saidUno = math.random(1, 10) < 8
            else
                -- if on hard mode
                self.saidUno = true
            end
        end

        if #self.cards == 1 and not self.saidUno then
            self:addCard(utils.drawCardOrGenerateDeck(player, self, deck, true))
            self:addCard(utils.drawCardOrGenerateDeck(player, self, deck, true))

            if playedDeck.chainCount > 0 then
                playedDeck.chainCount = 0
            end
        end

        player:setPlayerTurn(true)
    end

    return com
end

return Com
