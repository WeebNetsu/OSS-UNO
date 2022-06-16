local love = require "love"
local Deck = require "src.Deck"
local Player = require "src.Player"
local PlayedDeck = require "src.PlayedDeck"
local Com = require "src.Com"
local utils = require "utils"

math.randomseed(os.time())

local deck, player, playedDeck, com
local clickedMouse = false

function love.load()
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)

    local startCardCount = 8

    deck = Deck()
    deck:generateDeck()

    playedDeck = PlayedDeck()
    local allowedCard = false
    repeat
        -- make sure the first card on the field is not a power card
        local drawnCard = deck:drawCard(1, love.graphics.getWidth() / 2.5, utils.cardHeight + 50)
        if drawnCard.number ~= nil then
            allowedCard = true
            playedDeck:addCard(drawnCard)
        end
    until allowedCard

    player = Player(deck)
    player:setCards(startCardCount)

    com = Com(deck)
    com:setCards(startCardCount)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        clickedMouse = true
    end
end
function love.update(dt)
    if clickedMouse then
        if deck:checkHover() then
            local card = deck:drawCard(#player.cards+1)

            if card == nil then
                local blockedCards = {}

                -- todo: once we include Computer, we need to check if they have blocked cards
                for _, card in pairs(player.cards) do
                    table.insert(blockedCards, card)
                end

                deck:generateDeck(blockedCards)

                card = deck:drawCard(#player.cards+1)

                -- todo: we need to instead show an error message instead of just quiting!
                -- if card is nil stop program
                if card == nil then
                    print("ERROR: Could not generate a new deck and draw a card")
                    love.event.quit()
                end
            end

            player:addCard(card)
        elseif player:checkHover() then
            for ind, val in pairs(player:checkHovering()) do
                if val then
                    playedDeck:addCard(player:getCard(ind))
                    player:removeCard(ind)
                end
            end
        end
    end

    if #player.cards == 0 then
        print("You Won!")
        love.event.quit()
    elseif #com.cards == 0 then
        print("You Lost!")
        love.event.quit()
    end

    player:showPlayableCards(playedDeck.cards[#playedDeck.cards])
    
    if clickedMouse then
        clickedMouse = false
    end
end

function love.draw()
    -- love.graphics.scale(0.3) -- the sprite was a bit large, so I scaled it to a resonable size

    deck:draw()
    playedDeck:draw()
    com:draw()
    player:draw()

    love.graphics.print(love.timer.getFPS(), 10, 10)

    love.graphics.setColor(1, 1, 1)
end