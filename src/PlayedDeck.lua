local love = require "love"
local utils= require "utils"

function PlayedDeck(deck)
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

        pickColor = function (self, isCom, com)
            local mouseX, mouseY = love.mouse.getPosition()

            if isCom then
                if com == nil then
                    error("Com was not provided for pickColor")
                end

                -- store all colors com has in hand
                local containingColors = {}
                for _, card in pairs(com.cards) do
                    if card.color ~= nil then
                        table.insert(containingColors, card.color)
                    end
                end

                if #containingColors < 1 then
                    -- if com does not have any color cards in hand, pick a random color
                    local colors = {
                        "blue",
                        "red",
                        "green",
                        "yellow"
                    }
                    local color = colors[math.random(1, #colors)]
                    self.lastColor = color
                    return true
                end

                -- make the bot choose the color that is most common in the hand
                local blue, red, green, yellow = 0, 0, 0, 0

                for _, color in pairs(containingColors) do
                    if color == "blue" then
                        blue = blue + 1
                    elseif color == "red" then
                        red = red + 1
                    elseif color == "green" then
                        green = green + 1
                    else
                        yellow = yellow + 1
                    end
                end

                local max = math.max(blue, red, green, yellow)

                if max == blue then
                    self.lastColor = "blue"
                elseif max == red then
                    self.lastColor = "red"
                elseif max == green then
                    self.lastColor = "green"
                else
                    self.lastColor = "yellow"
                end

                return true
            end

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

        --[[ 
            This will add a card to the played deck.

            @param card: Card - the card to add to the played deck
            @param skipColorSet: boolean - if true, will not set the color of the card (used by com)
        ]]
        addCard = function (self, card, skipColorSet, player, com)
            card.rotation = math.random(-3, 10) / 10
            card.x = self.x
            card.y = self.y

            if not skipColorSet then
                self.lastColor = card.color
            end

            -- if +4 card
            if card.specialName == "wild pick four" then
                for _ = 1, 4 do
                    if not player.playerTurn then
                        player:addCard(utils:drawCardOrGenerateDeck(player, com, deck, false))
                    else
                        com:addCard(utils:drawCardOrGenerateDeck(player, com, deck, true))
                    end
                end
            end

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