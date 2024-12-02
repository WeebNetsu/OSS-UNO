require "src.game.player"
require "src.game.deck"
require "src.game.played_deck"
require "src.utils.message"
require "src.utils.sfx"
require "src.utils.cursor"

local love = require("love")
local utils = require("src.utils.utils")
local Com = require("src.game.com")

local function Player(deck: DeckType, playedDeck: PlayedDeckType, sfx: SFXType, cursor: CursorType): PlayerType
    -- inheriting from Com
    local player: PlayerType = Com(deck, playedDeck, nil) as PlayerType
    local played_uno_sfx = false
    local second_card_row_height = 0.0
    local third_card_row_height = 0.0
    -- this is after how many cards a 2nd row should appear
    local start_second_card_row = 13
    local start_third_card_row = start_second_card_row * 2

    player.playerTurn = false
    player.defaultYPos = love.graphics.getHeight() - 200

    player.setCardIsHovering = function (self: PlayerType)
        for ind, val in ipairs(self:checkHovering()) do
            self.cards[ind].hovering = val
        end
    end

    player.setPlayerTurn = function (self: PlayerType, playerTurn: boolean)
        if self.skipTurn and playerTurn then
            self.skipTurn = false
        else
            self.playerTurn = playerTurn
        end
    end

    player.updateCardPositions = function (self: PlayerType)
        for i = 1, #self.cards do
            local card = self.cards[i]
            
            if i > start_third_card_row then
                if third_card_row_height == 0 then
                    third_card_row_height = second_card_row_height + (utils.cardHeight / 1.5)
                end

                card:setPosition(self.cards[i - start_third_card_row].x, third_card_row_height)
            elseif i > start_second_card_row then
                if second_card_row_height == 0 then
                    second_card_row_height = card.y + (utils.cardHeight / 1.5)
                end

                card:setPosition(self.cards[i-start_second_card_row].x, second_card_row_height)
            else
                card:setPosition(self.defaultXPos * i, self.defaultYPos)
            end
        end
    end

    player.removeCard = function (self: PlayerType, index: integer, com: ComType)
        table.remove(self.cards, index)
        self:updateCardPositions()
        playedDeck.lastColor = nil


        if #self.cards == 1 and not self.saidUno then
            -- if the player did not say uno before reaching their last card
            self:addCard(utils.drawCardOrGenerateDeck(self, com, deck, false))
            self:addCard(utils.drawCardOrGenerateDeck(self, com, deck, false))
            if playedDeck.chainCount > 0 then
                playedDeck.chainCount = 0
            end
        end
    end

    player.draw = function (self: PlayerType)
        -- to keep scaling contained to this function and not the rest of the game
        love.graphics.push()

        local threeRowScaling = #self.cards > start_third_card_row
        local twoRowScaling = #self.cards > start_second_card_row
        
        if threeRowScaling then
            love.graphics.scale(utils.threeRowScaling, utils.threeRowScaling)
        elseif twoRowScaling then
            love.graphics.scale(utils.twoRowScaling, utils.twoRowScaling)
        end
        
        for _, card in ipairs(self.cards) do
            if twoRowScaling then
                card:draw(0, false, "twoRows")
            elseif threeRowScaling then
                card:draw(0, false, "threeRows")
            else
                card:draw(nil, nil, nil)
            end
        end

        -- to keep scaling contained to this function and not the rest of the game
        love.graphics.pop()

        -- message:showMessage("Drawing Card", "You are currently drawing a card! Well done, you did the impossible!", "error")

        if self.saidUno then
            if not played_uno_sfx then
                sfx:setFXPlayed(false)
                sfx:playFX("said_uno_male", "single")
                played_uno_sfx = true
            end
            love.graphics.print("PLAYER HAS UNO'D!", 10, love.graphics.getHeight() - 20)
        else
            played_uno_sfx = false
        end

        self:updateCardPositions()
    end

    player.showPlayableCards = function (self: PlayerType)
        local lastPlayedCard = playedDeck.cards[#playedDeck.cards]

        for _, card in ipairs(self.cards) do
            card.playable = false
            
            if self.playerTurn then
                -- if we're chaining +2/+4s
                if playedDeck.chainCount > 0 then
                    card.playable = card.specialName == lastPlayedCard.specialName
                else
                    if card.number ~= nil and card.number == lastPlayedCard.number then
                        card.playable = true
                    elseif card.color ~= nil then
                        if card.color == lastPlayedCard.color then
                            card.playable = true
                        end
    
                        if (not card.playable) and lastPlayedCard.specialName ~= nil then
                            card.playable = card.specialName == lastPlayedCard.specialName
                        end
    
                        if (not card.playable) and (playedDeck.lastColor == card.color) then
                            card.playable = true
                        end
                    else
                        for _, cardName in ipairs(utils.powerCards) do
                            if cardName == card.specialName then
                                card.playable = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    -- to be used to see if a card is being hovered over, return true or false
    player.checkHover = function (self: PlayerType): boolean
        -- to keep scaling contained to this function and not the rest of the game
        love.graphics.push()
        local current_scale = 1.0;

        if #self.cards > start_third_card_row then
            love.graphics.scale(utils.threeRowScaling, utils.threeRowScaling)
            current_scale = utils.threeRowScaling;
        elseif #self.cards > start_second_card_row then
            love.graphics.scale(utils.twoRowScaling, utils.twoRowScaling)
            current_scale = utils.twoRowScaling;
        end
        
        for _, card in ipairs(self.cards) do
            local scaledCardX = card.x * current_scale
            local scaledCardY = card.y * current_scale
            local scaledCardWidth = utils.cardWidth * current_scale
            local scaledCardHeight = utils.cardHeight * current_scale
    
            if cursor.pos.x >= scaledCardX and (cursor.pos.x <= scaledCardX + scaledCardWidth) and (cursor.pos.y >= scaledCardY - 20) and (cursor.pos.y <= (scaledCardY + scaledCardHeight)) then
                return true
            end
        end
        love.graphics.pop()

        return false
    end

    -- used to see which card is being hovered over, table of booleans is returned
    player.checkHovering = function (self: PlayerType): {boolean}
        -- to keep scaling contained to this function and not the rest of the game
        love.graphics.push()
        local current_scale = 1.0;

        if #self.cards > start_third_card_row then
            love.graphics.scale(utils.threeRowScaling, utils.threeRowScaling)
            current_scale = utils.threeRowScaling;
        elseif #self.cards > start_second_card_row then
            love.graphics.scale(utils.twoRowScaling, utils.twoRowScaling)
            current_scale = utils.twoRowScaling;
        end

        local hovering = {}

        for ind, card in ipairs(self.cards) do
            local scaledCardX = card.x * current_scale
            local scaledCardY = card.y * current_scale
            local scaledCardWidth = utils.cardWidth * current_scale
            local scaledCardHeight = utils.cardHeight * current_scale

            if self.cards[ind + 1] then
                table.insert(hovering, cursor.pos.x >= scaledCardX and (cursor.pos.x <= scaledCardX + (scaledCardWidth / 1.5)) and (cursor.pos.y >= scaledCardY - 20) and (cursor.pos.y <= (scaledCardY + scaledCardHeight)))
            else
                table.insert(hovering, cursor.pos.x >= scaledCardX and (cursor.pos.x <= scaledCardX + scaledCardWidth) and (cursor.pos.y >= scaledCardY - 20) and (cursor.pos.y <= (scaledCardY + scaledCardHeight)))
            end
        end

        -- to keep scaling contained to this function and not the rest of the game
        love.graphics.pop()

        return hovering
    end

    return player
end

return Player
