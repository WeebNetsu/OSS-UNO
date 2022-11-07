require "src.game.player"
require "src.game.deck"
require "src.game.played_deck"
require "src.utils.sfx"

local love = require("love")
local utils = require("src.utils.utils")
local Com = require("src.game.com")

local function Player(deck: DeckType, playedDeck: PlayedDeckType, sfx: SFXType): PlayerType
    -- inheriting from Com
    local player: PlayerType = Com(deck, playedDeck) as PlayerType
    local played_uno_sfx = false

    player.playerTurn = false
    player.defaultYPos = love.graphics.getHeight() - 200

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
            card:setPosition(self.defaultXPos * i, self.defaultYPos)
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
        -- todo just check here this used to be pairs not ipairs
        for _, card in ipairs(self.cards) do
            card:draw()
        end

        if self.saidUno then
            -- todo change to uno sfx
            if not played_uno_sfx then
                sfx:setFXPlayed(false)
                sfx:playFX("said_uno_male", "single")
                played_uno_sfx = true
            end
            love.graphics.print("PLAYER HAS UNO'D!", 10, love.graphics.getHeight() - 20)
        else
            played_uno_sfx = false
        end
    end

    player.showPlayableCards = function (self: PlayerType)
        local lastPlayedCard = playedDeck.cards[#playedDeck.cards]

        -- todo just check here this used to be pairs not ipairs
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
                        -- todo just check here this used to be pairs not ipairs
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
        local mouseX, mouseY = love.mouse.getPosition()

        -- todo just check here this used to be pairs not ipairs
        for _, card in ipairs(self.cards) do
            if  mouseX >= card.x and (mouseX <= card.x + utils.cardWidth) and (mouseY >= card.y - 20) and (mouseY <= (card.y + utils.cardHeight)) then
                return true
            end
        end

        return false
    end

    -- used to see which card is being hoved over, table of booleans is returned
    player.checkHovering = function (self: PlayerType): {boolean}
        local mouseX, mouseY = love.mouse.getPosition()
        local hovering = {}

        -- todo just check here this used to be pairs not ipairs
        for ind, card in ipairs(self.cards) do
            if self.cards[ind+1] then
                table.insert(hovering, mouseX >= card.x and (mouseX <= card.x + (utils.cardWidth / 1.5)) and (mouseY >= card.y - 20) and (mouseY <= (card.y + utils.cardHeight)))
            else
                table.insert(hovering, mouseX >= card.x and (mouseX <= card.x + utils.cardWidth) and (mouseY >= card.y - 20) and (mouseY <= (card.y + utils.cardHeight)))
            end
        end

        return hovering
    end

    return player
end

return Player
