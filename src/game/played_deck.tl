require "src.game.played_deck"
require "src.game.card"
require "src.game.com"

local love = require "love"
local utils = require "src.utils.utils"

local function PlayedDeck(): PlayedDeckType
    -- cp = color picker
    local cpWidth = 300
    local cpXPos, cpYPos = love.graphics.getWidth() / 2 - cpWidth, 50
    local cpBorderSpace, cpBorderRadius = 15, 5
    local rightBlockXStart = cpWidth + cpXPos + cpBorderSpace
    local bottomBlockYStart = cpWidth + cpYPos + cpBorderSpace

    local playedDeck: PlayedDeckType = {}

    playedDeck.cards = {}
    -- chaining is when a +2/+4 is thrown onto another +2/+4
    playedDeck.chainCount = 0
    playedDeck.x = love.graphics.getWidth() / 2.5
    playedDeck.y = utils.cardHeight + 80
    playedDeck.lastColor = nil
    playedDeck.colorPicking = false

    playedDeck.setColorPicking = function (self: PlayedDeckType, colorPicking: boolean)
        if colorPicking then
            love.graphics.setColor(0,0,0,0.5)
        else
            love.graphics.setColor(1,1,1,1)
        end

        self.colorPicking = colorPicking
    end

    playedDeck.checkColorPickerHover = function (_self: PlayedDeckType): boolean
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
    end

    playedDeck.pickColor = function (self: PlayedDeckType, isCom: boolean, com: ComType): boolean
        local mouseX, mouseY = love.mouse.getPosition()

        if isCom then
            if com == nil then
                error("Com was not provided for pickColor")
            end

            -- store all colors com has in hand
            local containingColors: {CardType.AvailableCardColors} = {}
            -- todo just check here this used to be pairs not ipairs
            for _, card in ipairs(com.cards) do
                if card.color ~= nil then
                    table.insert(containingColors, card.color)
                end
            end

            if #containingColors < 1 then
                -- if com does not have any color cards in hand, pick a random color
                local colors: {CardType.AvailableCardColors} = {
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

            -- todo just check here this used to be pairs not ipairs
            for _, color in ipairs(containingColors) do
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
    end

    --[[ 
        This will add a card to the played deck.

        @param card: Card - the card to add to the played deck
        @param skipColorSet: boolean - if true, will not set the color of the card (used by com)
    ]]
    playedDeck.addCard = function (self: PlayedDeckType, card: CardType, skipColorSet: boolean, player: PlayerType, com: ComType)
        card.rotation = math.random(-3, 10) / 10
        card.x = self.x
        card.y = self.y

        if not skipColorSet then
            self.lastColor = card.color
        end

        -- if +4 or +2 card
        -- picker = +2 card
        if card.specialName == "wild pick four" or card.specialName == "picker" then
            self.chainCount = self.chainCount + 1
            -- since it's a 2 player game, skip and reverse does the same thing
        elseif card.specialName == "reverse" or card.specialName == "skip" then
            if not player.playerTurn then
                player.skipTurn = true
            else
                com.skipTurn = true
            end
        end

        table.insert(self.cards, card)
    end

    playedDeck.draw = function (self: PlayedDeckType)
        -- todo just check here this used to be pairs not ipairs
        for _, card in ipairs(self.cards) do
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
    end

    return playedDeck
end

return PlayedDeck
