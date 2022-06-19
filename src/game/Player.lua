local love = require("love")
local utils = require("utils")
local Com = require("src.game.Com")

function Player(deck, playedDeck)
    -- inheriting from Com
    local player = Com(deck, playedDeck)

    player.playerTurn = false
    player.defaultYPos = love.graphics.getHeight() - 200

    player.setPlayerTurn = function (self, playerTurn)
        if self.skipTurn and playerTurn then
            self.skipTurn = false
        else
            self.playerTurn = playerTurn
        end
    end

    player.updateCardPositions = function (self)
        for i = 1, #self.cards do
            local card = self.cards[i]
            card:setPosition(self.defaultXPos * i, self.defaultYPos)
        end
    end

    player.removeCard = function (self, index, com)
        table.remove(self.cards, index)
        self:updateCardPositions()
        playedDeck.lastColor = nil


        if #self.cards == 1 and not self.saidUno then
            -- if the player did not say uno before reaching their last card
            self:addCard(utils:drawCardOrGenerateDeck(self, com, deck, false))
            self:addCard(utils:drawCardOrGenerateDeck(self, com, deck, false))
            if playedDeck.chainCount > 0 then
                playedDeck.chainCount = 0
            end
        end
    end

    player.draw = function (self)
        for index, card in pairs(self.cards) do
            card:draw()
        end

        if self.saidUno then
            love.graphics.print("PLAYER HAS UNO'D!", 10, love.graphics.getHeight() - 20)
        end
    end

    player.showPlayableCards = function (self)
        local lastPlayedCard = playedDeck.cards[#playedDeck.cards]

        for _, card in pairs(self.cards) do
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
                        for _, cardName in pairs(utils.powerCards) do
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
    player.checkHover = function (self)
        local mouseX, mouseY = love.mouse.getPosition()

        for _, card in pairs(self.cards) do
            if  mouseX >= card.x and (mouseX <= card.x + utils.cardWidth) and (mouseY >= card.y - 20) and (mouseY <= (card.y + utils.cardHeight)) then
                return true
            end
        end

        return false
    end

    -- used to see which card is being hoved over, table of booleans is returned
    player.checkHovering = function (self)
        local mouseX, mouseY = love.mouse.getPosition()
        local hovering = {}

        for ind, card in pairs(self.cards) do
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
