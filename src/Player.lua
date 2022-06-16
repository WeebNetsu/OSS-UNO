local love = require("love")
local utils= require("utils")

function Player(deck)
    local defaultXPos = utils.cardWidth / 1.5
    local defaultYPos = love.graphics.getHeight() - 210
    
    return {
        cards = {},
        colorPicking = false,

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
        end,

        getCard = function (self, index)
            return self.cards[index]
        end,

        setColorPicking = function (self, colorPicking)
            if colorPicking then
                love.graphics.setColor(0,0,0,0.5)
            else
                love.graphics.setColor(1,1,1,1)
            end

            self.colorPicking = colorPicking
        end,

        draw = function (self)
            local width = 300
            local xPos, yPos = love.graphics.getWidth() / 2 - width, 50
            local borderSpace, borderRadius = 15, 5
            local mouseX, mouseY = love.mouse.getPosition()

            for index, card in pairs(self.cards) do
                card:draw()
            end

            if self.colorPicking then
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

                -- blue
                love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
                love.graphics.rectangle("fill", xPos, yPos, width, width, borderRadius)

                -- red
                love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
                love.graphics.rectangle("fill", width + xPos + borderSpace, yPos, width, width, borderRadius)

                -- green
                love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
                love.graphics.rectangle("fill", xPos, width + yPos + borderSpace, width, width, borderRadius)

                -- yellow
                love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
                love.graphics.rectangle("fill", width + xPos + borderSpace, width + yPos + borderSpace, width, width, borderRadius)
            end

            -- 15x15 square around cursor
            love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
            love.graphics.rectangle("line", mouseX - 7, mouseY - 7, 15, 15, borderRadius)
            love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
            love.graphics.rectangle("line", mouseX, mouseY - 7, 15, 15, borderRadius)
            love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
            love.graphics.rectangle("line", mouseX - 7, mouseY, 15, 15, borderRadius)
            love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
            love.graphics.rectangle("line", mouseX, mouseY, 15, 15, borderRadius)
        end,

        showPlayableCards = function (self, lastPlayedCard)
            for _, card in pairs(self.cards) do
                card.playable = false

                if card.number ~= nil and card.number == lastPlayedCard.number then
                    card.playable = true
                elseif card.color ~= nil and card.color == lastPlayedCard.color then
                    card.playable = true
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
                if  mouseX >= card.x and (mouseX <= card.x + utils.cardWidth) and (mouseY >= card.y) and (mouseY <= (card.y + utils.cardHeight)) then
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
                    table.insert(hovering, mouseX >= card.x and (mouseX <= card.x + (utils.cardWidth / 1.5)) and (mouseY >= card.y) and (mouseY <= (card.y + utils.cardHeight)))
                else
                    table.insert(hovering, mouseX >= card.x and (mouseX <= card.x + utils.cardWidth) and (mouseY >= card.y) and (mouseY <= (card.y + utils.cardHeight)))
                end
            end

            return hovering
        end,
    }
end

return Player