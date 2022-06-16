local love = require "love"
local Deck = require "src.Deck"
local Player = require "src.Player"
local PlayedDeck = require "src.PlayedDeck"
local Com = require "src.Com"
local utils = require "utils"

math.randomseed(os.time())

local deck, player, playedDeck, com
local clickedMouse = false
local cursorBorderRadius = 5
local mouseX, mouseY

-- this is if we're busy picking a color, we can continue where we left off
local selectedCardIndex = nil

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

    player = Player(deck, playedDeck)
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
    mouseX, mouseY = love.mouse.getPosition()
    
    if clickedMouse then
        -- if currently picking a color
        if playedDeck.colorPicking and selectedCardIndex ~= nil then
            if playedDeck:checkColorPickerHover() then
                if playedDeck:pickColor() then
                    local lastCardColor = playedDeck.lastColor
                    playedDeck:addCard(player:getCard(selectedCardIndex))
                    -- since removeCard will remove the last selected color as well
                    player:removeCard(selectedCardIndex)
                    selectedCardIndex = nil
                    playedDeck:setColorPicking(false)
                    playedDeck.lastColor = lastCardColor
                end
            end
        else
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
                        local selectedCard = player:getCard(ind)
    
                        if selectedCard.playable then
                            for _, powerCard in pairs(utils.powerCards)do
                                if selectedCard.specialName == powerCard then
                                    playedDeck:setColorPicking(true)
                                    selectedCardIndex = ind
                                end
                            end
                        
                            if not playedDeck.colorPicking then
                                playedDeck:addCard(selectedCard)
                                player:removeCard(ind)
                            end
                        end
                    end
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
    deck:draw()
    com:draw()
    player:draw()
    playedDeck:draw()

    love.graphics.print(love.timer.getFPS(), 10, 10)


    -- 15x15 square around cursor
    love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
    love.graphics.rectangle("line", mouseX - 7, mouseY - 7, 15, 15, cursorBorderRadius)
    love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
    love.graphics.rectangle("line", mouseX, mouseY - 7, 15, 15, cursorBorderRadius)
    love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
    love.graphics.rectangle("line", mouseX - 7, mouseY, 15, 15, cursorBorderRadius)
    love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
    love.graphics.rectangle("line", mouseX, mouseY, 15, 15, cursorBorderRadius)
    -- love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)
    love.graphics.setColor(1, 1, 1)
end