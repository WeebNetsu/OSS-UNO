local love = require("love")
local utils= require("utils")

function Player(deck, playedDeck)
    local defaultXPos = utils.cardWidth / 1.5
    local defaultYPos = love.graphics.getHeight() - 200
    
    return {
        cards = {},

        -- will set the initial 8 cards
        setCards = function (self, num)
            for i = 1, num do
                local card = deck:drawCard(nil, defaultXPos * i, defaultYPos)

                if card == nil then
                    deck:generateDeck(self.cards)
                    i = i - 1
                else
                    table.insert(self.cards, card)
                end
            end
        end,

        updateCardPositions = function (self)
            for i = 1, #self.cards do
                local card = self.cards[i]
                card:setPosition(defaultXPos * i, defaultYPos)
            end
        end,

        addCard = function (self, card)
            table.insert(self.cards, card)
        end,

        removeCard = function (self, index)
            table.remove(self.cards, index)
            self:updateCardPositions()
            playedDeck.lastColor = nil
        end,

        getCard = function (self, index)
            return self.cards[index]
        end,

        draw = function (self)
            for index, card in pairs(self.cards) do
                card:draw()
            end
        end,

        showPlayableCards = function (self, lastPlayedCard)
            for _, card in pairs(self.cards) do
                card.playable = false

                if card.number ~= nil and card.number == lastPlayedCard.number then
                    card.playable = true
                elseif card.color ~= nil then
                    if card.color == lastPlayedCard.color then
                        card.playable = true
                    end

                    if (not card.playable) and lastPlayedCard.specialName ~= nil then
                        if card.specialName == lastPlayedCard.specialName then
                            card.playable = true
                        end
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
        end,

        -- to be used to see if a card is being hovered over, return true or false
        checkHover = function (self)
            local mouseX, mouseY = love.mouse.getPosition()

            for _, card in pairs(self.cards) do
                if  mouseX >= card.x and (mouseX <= card.x + utils.cardWidth) and (mouseY >= card.y - 20) and (mouseY <= (card.y + utils.cardHeight)) then
                    return true
                end
            end

            return false
        end,

        -- used to see which card is being hoved over, table of booleans is returned
        checkHovering = function (self)
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
        end,
    }
end

return Player