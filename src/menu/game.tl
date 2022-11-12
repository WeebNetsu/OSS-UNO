require "src.utils.sfx"
require "src.menu.game"

local love = require "love"
local Deck = require "src.game.deck"
local Player = require "src.game.player"
local PlayedDeck = require "src.game.played_deck"
local Com = require "src.game.com"
local utils = require "src.utils.utils"
local Uno = require "src.game.uno"

local function Game(sfx: SFXType): GameType
    local deck: DeckType
    local player: PlayerType
    local playedDeck: PlayedDeckType
    local com: ComType
    local uno: UnoType
    local game: GameType = {}
    -- this is if we're busy picking a color, we can continue where we left off
    local selectedCardIndex: integer = nil

    game.load = function (_self: GameType)
        local startCardCount = 8

        uno = Uno()
        deck = Deck(sfx)
        deck:generateDeck()

        playedDeck = PlayedDeck(sfx)

        player = Player(deck, playedDeck, sfx)
        player:setCards(startCardCount)
        -- if player goes first
        player:setPlayerTurn(math.random(1, 10) > 5)

        com = Com(deck, playedDeck, sfx)
        com:setCards(startCardCount)

        local allowedCard = false
        repeat
            -- make sure the first card on the field is not a power card
            local drawnCard = deck:drawCard(love.graphics.getWidth() / 2.5, utils.cardHeight + 50)
            if drawnCard ~= nil and drawnCard.number ~= nil then
                allowedCard = true
                playedDeck:addCard(drawnCard, false, player, com)
            end
        until allowedCard
    end

    game.update = function (_self: GameType, _dt: number, clickedMouse: boolean)
        clickedMouse = clickedMouse or false

        if player.playerTurn then
            if clickedMouse then
                -- if currently picking a color
                if playedDeck.colorPicking and selectedCardIndex ~= nil then
                    if playedDeck:checkColorPickerHover() then
                        if playedDeck:pickColor() then
                            local lastCardColor = playedDeck.lastColor
                            playedDeck:addCard(player:getCard(selectedCardIndex), false, player, com)
                            -- since removeCard will remove the last selected color as well
                            player:removeCard(selectedCardIndex, com)
                            selectedCardIndex = nil
                            playedDeck:setColorPicking(false)
                            playedDeck.lastColor = lastCardColor
                            player:setPlayerTurn(false)
                        end
                    end
                else
                    if deck:checkHover() then
                        local drawCount = 1

                        if playedDeck.chainCount > 0 then
                            local specialCard = playedDeck.cards[#playedDeck.cards].specialName

                            if specialCard == "wild pick four" then
                                drawCount = drawCount * 4 * playedDeck.chainCount
                            elseif specialCard == "picker" then
                                drawCount = drawCount * 2 * playedDeck.chainCount
                            end

                            playedDeck.chainCount = 0
                        end

                        for _ = 1, drawCount do
                            player:addCard(utils.drawCardOrGenerateDeck(player, com, deck, false))
                        end

                        player:setPlayerTurn(false)
                    elseif player:checkHover() then
                        for ind, val in ipairs(player:checkHovering()) do
                            if val then
                                local selectedCard = player:getCard(ind)

                                if selectedCard.playable then
                                    for _, powerCard in ipairs(utils.powerCards)do
                                        if selectedCard.specialName == powerCard then
                                            playedDeck:setColorPicking(true)
                                            selectedCardIndex = ind
                                        end
                                    end

                                    if not playedDeck.colorPicking then
                                        playedDeck:addCard(selectedCard, false, player, com)
                                        player:removeCard(ind, com)
                                        player:setPlayerTurn(false)
                                    end
                                end
                            end
                        end
                    end

                    if uno:checkHover() then
                        if #player.cards == 2 then
                            player.saidUno = true
                        end
                    end
                end
            end

            if #player.cards == 0 then
                print("You Won!")
                utils:changeGameState("menu")
            elseif #com.cards == 0 then
                print("You Lost!")
                utils:changeGameState("menu")
            end

            player:showPlayableCards()
        else
            -- if computer's turn
            com:play(player)
        end
    end

    game.draw = function (_self: GameType)
        deck:draw()
        com:draw()
        player:draw()
        playedDeck:draw()
        uno:draw(playedDeck)
    end

    return game
end

return Game