local love = require "love"
local Card = require "src.game.Card"
local utils = require "utils"

function Deck()
    local xPos, yPos = 50, utils.cardHeight + 70
    local image = Card(xPos, yPos, nil, nil, "card_back_alt")

    local deck = {}

    deck.deck = {}
    deck.x = xPos
    deck.y = yPos

    deck.compareDeckToBlockedCards = function (self, card, blockedCards)
        if blockedCards == nil then
            return true
        end

        local createCard = true

        for _, c in pairs(blockedCards) do
            -- todo not sure if this works yet lol
            if c == card then
               createCard = false
               break
            end
        end

        return createCard
    end

    deck.shuffle = function (self)
        local shuffled = {}

        for i, v in ipairs(self.deck) do
            local pos = math.random(1, #shuffled+1)
            table.insert(shuffled, pos, v)
        end

        self.deck = shuffled
    end

    --[[
        generate a new deck, blockedCards is a list of cards that are blocked from being drawn.
        they are usually in the user or computers hand

        generateDeck(blockedCards: table[Card])
    ]]
    deck.generateDeck = function (self, blockedCards)
        local cards = {}

        for _, color in pairs({"blue", "red", "green", "yellow"}) do
            for i = 0, 9 do
                local generatedCard = Card(self.x, self.y, color, i, nil)

                if self:compareDeckToBlockedCards(generatedCard, blockedCards) then
                    table.insert(cards, generatedCard)
                end
            end

            for _, card in pairs({"picker", "reverse", "skip"}) do
                local generatedCard = Card(self.x, self.y, color, nil, card)

                if self:compareDeckToBlockedCards(generatedCard, blockedCards) then
                    table.insert(cards, generatedCard)
                end
            end

            for _, specialCard in pairs(utils.powerCards) do
                local generatedCard = Card(self.x, self.y, nil, nil, specialCard)

                if self:compareDeckToBlockedCards(generatedCard, blockedCards) then
                    table.insert(cards, generatedCard)
                end
            end
        end

        self.deck = cards
        self:shuffle()
    end

    deck.checkHover = function (self)
        local mouse_x, mouse_y = love.mouse.getPosition()

        -- return true if cursor is inside deck on screen
        return mouse_x >= self.x and (mouse_x <= self.x + utils.cardWidth) and (mouse_y >= self.y) and (mouse_y <= (self.y + utils.cardHeight))
    end

    deck.draw = function (self)
        image:draw()

        if self:checkHover() then
            image:draw(-0.3)
        end
    end

    deck.drawCard = function (self, index, cardX, cardY)
        index = index or 1

        local card = self.deck[1]

        if cardX == nil or cardY == nil then
            -- throw lua error
            error("Card x and/or y position not specified for drawCard() in Deck.lua")
        end

        if card ~= nil then
            table.remove(self.deck, 1)

            card.x = cardX
            card.y = cardY
        end

        return card
    end

    return deck
end

return Deck
