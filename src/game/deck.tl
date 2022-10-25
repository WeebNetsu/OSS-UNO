require "src.utils.sfx"
require "src.game.deck"

local love = require "love"
local Card = require "src.game.card"
local utils = require "src/utils/utils"

local function Deck(sfx: SFXType): DeckType
    local xPos, yPos = 50, utils.cardHeight + 70
    local image = Card(xPos, yPos, nil, nil, "card_back_alt")
    local settings = utils.readJSON("settings")

    local deck: DeckType = {}

    deck.deck = {}
    deck.x = xPos
    deck.y = yPos

    deck.compareDeckToBlockedCards = function (_self: DeckType, card: CardType, blockedCards: {string: CardType}): boolean
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

    deck.shuffle = function (self: DeckType)
        local shuffled = {}

        for _, v in ipairs(self.deck) do
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
    deck.generateDeck = function (self: DeckType, blockedCards: {string: CardType})
        local cards: {CardType} = {}

        -- todo just check here this used to be pairs not ipairs
        for _, color in ipairs({"blue", "red", "green", "yellow"} as {CardType.AvailableCardColors}) do
            for i = 0, 9 do
                local generatedCard = Card(self.x, self.y, color, i, nil)

                if self:compareDeckToBlockedCards(generatedCard, blockedCards) then
                    table.insert(cards, generatedCard)
                end
            end

            -- todo just check here this used to be pairs not ipairs
            for _, card in ipairs({"picker", "reverse", "skip"}) do
                local generatedCard = Card(self.x, self.y, color, nil, card)

                if self:compareDeckToBlockedCards(generatedCard, blockedCards) then
                    table.insert(cards, generatedCard)
                end
            end

            -- todo just check here this used to be pairs not ipairs
            for _, specialCard in ipairs(utils.powerCards) do
                local generatedCard = Card(self.x, self.y, nil, nil, specialCard)

                if self:compareDeckToBlockedCards(generatedCard, blockedCards) then
                    table.insert(cards, generatedCard)
                end
            end
        end

        self.deck = cards
        self:shuffle()
    end

    deck.checkHover = function (self: DeckType): boolean
        local mouse_x, mouse_y = love.mouse.getPosition()

        -- return true if cursor is inside deck on screen
        return mouse_x >= self.x and (mouse_x <= self.x + utils.cardWidth) and (mouse_y >= self.y) and (mouse_y <= (self.y + utils.cardHeight))
    end

    deck.draw = function (self: DeckType)
        image:draw()

        if self:checkHover() then
            image:draw(-0.3)
        end
    end

    deck.drawCard = function (self: DeckType, cardX: number, cardY: number, bot: boolean): CardType
        local card = self.deck[1]

        if cardX == nil or cardY == nil then
            -- throw lua error
            error("Card x and/or y position not specified for drawCard() in Deck.lua")
        end

        if card ~= nil then
            -- if the bot is the one drawing a card
            if bot then
                local level = 2

                if settings.difficulty ~= nil then
                    level = settings.difficulty
                end

                -- if player is on easy mode
                if level == 1 then
                    -- bot is not allowed to use +4 cards on easy mode
                    while card.specialName == utils.powerCards[2] do
                        table.remove(self.deck, 1)
                        card = self.deck[1]
                    end
                end
            end

            table.remove(self.deck, 1)

            card.x = cardX
            card.y = cardY
        end

        -- todo when player picks up more than 1 card, below should play more than 1 time
        sfx:playFX("card_draw")

        return card
    end

    return deck
end

return Deck
