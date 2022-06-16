local love = require "love"
local utils= require "utils"

function PlayedDeck()
    return {
        cards = {},
        x = love.graphics.getWidth() / 2.5,
        y = utils.cardHeight + 70,

        addCard = function (self, card)
            card.rotation = math.random(-3, 10) / 10
            card.x = self.x
            card.y = self.y

            table.insert(self.cards, card)
        end,

        draw = function (self)
            for _, card in pairs(self.cards) do
                card:draw()
            end
        end,
    }
end

return PlayedDeck