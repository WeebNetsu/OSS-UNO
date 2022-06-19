local love = require "love"
local utils = require "utils"

function Uno()
    -- width and height are swapped, since it's horizontal and not vertical
    local width, height = utils.cardHeight, utils.cardWidth
    local image = love.graphics.newImage("assets/uno.png")
    local scale = 0.7

    local uno = {}
    
    uno.x = love.graphics.getWidth() + 300
    uno.y = love.graphics.getHeight() / 2 + 100

    uno.draw = function (self, playedDeck)
        love.graphics.push()
        love.graphics.scale(scale) -- the sprite was a bit large, so I scaled it to a resonable size

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

    uno.checkHover = function (self)
        local mouse_x, mouse_y = love.mouse.getPosition()

        -- we * by scale, since the drawing was scaled
        return mouse_x >= self.x * scale and (mouse_x <= (self.x + width) * scale) and (mouse_y >= self.y * scale) and (mouse_y <= (self.y + height) * scale)
    end

    return uno
end

return Uno
