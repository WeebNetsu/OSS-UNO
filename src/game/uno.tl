require "src.game.uno"
require "src.game.played_deck"

local love = require "love"
local utils = require "src.utils.utils"

local function Uno(cursor: CursorType): UnoType
    -- width and height are swapped, since it's horizontal and not vertical
    local width, height = utils.cardHeight, utils.cardWidth
    local image = love.graphics.newImage("assets/uno.png")
    local scale = 0.7

    local uno: UnoType = {}
    
    uno.x = love.graphics.getWidth() + 300
    uno.y = love.graphics.getHeight() / 2

    uno.draw = function (self: UnoType, playedDeck: PlayedDeckType)
        love.graphics.push()
        love.graphics.scale(scale) -- the sprite was a bit large, so I scaled it to a reasonable size

        if playedDeck.lastColor == "blue" then
            love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
        elseif playedDeck.lastColor == "red" then
            love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
        elseif playedDeck.lastColor == "green" then
            love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
        elseif playedDeck.lastColor == "yellow" then
            love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
        else
            if playedDeck.cards[#playedDeck.cards].color == "blue" then
                love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
            elseif playedDeck.cards[#playedDeck.cards].color == "red" then
                love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
            elseif playedDeck.cards[#playedDeck.cards].color == "green" then
                love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
            else
                love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
            end
        end

        love.graphics.rectangle("fill", self.x, self.y, width, height, 5)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(image, self.x, self.y)

        love.graphics.pop()
    end

    uno.checkHover = function (self: UnoType): boolean
        -- we * by scale, since the drawing was scaled
        return cursor.pos.x >= self.x * scale and (cursor.pos.x <= (self.x + width) * scale) and (cursor.pos.y >= self.y * scale) and (cursor.pos.y <= (self.y + height) * scale)
    end

    return uno
end

return Uno
