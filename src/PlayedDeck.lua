local love = require "love"
local utils= require "utils"

function PlayedDeck()
    -- cp = color picker
    local cpWidth = 300
    local cpXPos, cpYPos = love.graphics.getWidth() / 2 - cpWidth, 50
    local cpBorderSpace, cpBorderRadius = 15, 5
    local rightBlockXStart = cpWidth + cpXPos + cpBorderSpace
    local bottomBlockYStart = cpWidth + cpYPos + cpBorderSpace

    return {
        cards = {},
        x = love.graphics.getWidth() / 2.5,
        y = utils.cardHeight + 80,
        lastColor = nil,
        colorPicking = false,

        setColorPicking = function (self, colorPicking)
            if colorPicking then
                love.graphics.setColor(0,0,0,0.5)
            else
                love.graphics.setColor(1,1,1,1)
            end

            self.colorPicking = colorPicking
        end,

        checkColorPickerHover = function (self)
            local mouseX, mouseY = love.mouse.getPosition()

            if (mouseX >= cpXPos) and (mouseX <= cpXPos + cpWidth) and (mouseY >= cpYPos) and (mouseY <= (cpYPos + cpWidth)) then
                return true
            end

            if (mouseX >= rightBlockXStart) and (mouseX <= rightBlockXStart + cpWidth) and (mouseY >= cpYPos) and (mouseY <= (cpYPos + cpWidth)) then
                return true
            end

            if (mouseX >= cpXPos) and (mouseX <= cpXPos + cpWidth) and (mouseY >= bottomBlockYStart) and (mouseY <= (bottomBlockYStart + cpWidth)) then
                return true
            end

            if (mouseX >= rightBlockXStart) and (mouseX <= rightBlockXStart + cpWidth) and (mouseY >= bottomBlockYStart) and (mouseY <= (bottomBlockYStart + cpWidth)) then
                return true
            end

            return false
        end,

        pickColor = function (self)
            local mouseX, mouseY = love.mouse.getPosition()

            -- blue
            if (mouseX >= cpXPos) and (mouseX <= cpXPos + cpWidth) and (mouseY >= cpYPos) and (mouseY <= (cpYPos + cpWidth)) then
                self.lastColor = "blue"
                return true
            end

            -- red
            if (mouseX >= rightBlockXStart) and (mouseX <= rightBlockXStart + cpWidth) and (mouseY >= cpYPos) and (mouseY <= (cpYPos + cpWidth)) then
                self.lastColor = "red"
                return true
            end

            -- green
            if (mouseX >= cpXPos) and (mouseX <= cpXPos + cpWidth) and (mouseY >= bottomBlockYStart) and (mouseY <= (bottomBlockYStart + cpWidth)) then
                self.lastColor = "green"
                return true
            end

            -- yellow
            if (mouseX >= rightBlockXStart) and (mouseX <= rightBlockXStart + cpWidth) and (mouseY >= bottomBlockYStart) and (mouseY <= (bottomBlockYStart + cpWidth)) then
                self.lastColor = "yellow"
                return true
            end

            return false
        end,

        addCard = function (self, card)
            card.rotation = math.random(-3, 10) / 10
            card.x = self.x
            card.y = self.y
            self.lastColor = card.color

            table.insert(self.cards, card)
        end,

        draw = function (self)
            for _, card in pairs(self.cards) do
                card:draw()
            end

            if self.colorPicking then
                love.graphics.setColor(0, 0, 0, 0.5)
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

                -- blue
                love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
                love.graphics.rectangle("fill", cpXPos, cpYPos, cpWidth, cpWidth, cpBorderRadius)

                -- red
                love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
                love.graphics.rectangle("fill", rightBlockXStart, cpYPos, cpWidth, cpWidth, cpBorderRadius)

                -- green
                love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
                love.graphics.rectangle("fill", cpXPos, bottomBlockYStart, cpWidth, cpWidth, cpBorderRadius)

                -- yellow
                love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
                love.graphics.rectangle("fill", rightBlockXStart, bottomBlockYStart, cpWidth, cpWidth, cpBorderRadius)
            end
        end,
    }
end

return PlayedDeck