local utils= require("utils")

function Com(deck)
    local defaultXPos = utils.cardWidth / 1.5
    local defaultYPos = utils.cardHeight
    
    return {
        cards = {},

        -- will set the initial 8 cards
        setCards = function (self, num)
            for i = 1, num do
                local card = deck:drawCard(nil, defaultXPos * i, 20)

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

        draw = function (self)
            for index, card in pairs(self.cards) do
                card:draw(nil, true)
            end
        end,
    }
end

return Com