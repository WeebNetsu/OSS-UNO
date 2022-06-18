local utils = require("utils")

function Com(deck, playedDeck)
    local com = {}

    com.defaultXPos = utils.cardWidth / 1.5
    com.defaultYPos = 20

    com.cards = {}
    com.skipTurn = false

    -- will set the initial 8 cards
    com.setCards = function (self, num)
        for i = 1, num do
            local card = deck:drawCard(nil, self.defaultXPos * i, self.defaultYPos)

            if card == nil then
                deck:generateDeck(self.cards)
                i = i - 1
            else
                table.insert(self.cards, card)
            end
        end
    end

    com.updateCardPositions = function (self)
        for i = 1, #self.cards do
            local card = self.cards[i]
            card:setPosition(self.defaultXPos * i, self.defaultYPos)
        end
    end

    com.addCard = function (self, card)
        table.insert(self.cards, card)
    end

    com.removeCard = function (self, index)
        table.remove(self.cards, index)
        self:updateCardPositions()
    end

    com.getCard = function (self, index)
        return self.cards[index]
    end

    com.drawCard = function (self)
        return deck:drawCard(#self.cards+1, self.defaultXPos * #self.cards + self.defaultXPos, self.defaultYPos)
    end

    com.draw = function (self)
        for index, card in pairs(self.cards) do
            -- true -> card back is shown
            -- false -> actual card is shown
            card:draw(nil, true)
        end
    end

    com.play = function (self, player)
        if self.skipTurn then
            player:setPlayerTurn(true)
            self.skipTurn = false
            return
        end

        local lastPlayedCard = playedDeck.cards[#playedDeck.cards]
        local playableCards = {}

        for ind, card in pairs(self.cards) do
            card.playable = false
            
            if not player.playerTurn then
                if card.number ~= nil and card.number == lastPlayedCard.number then
                    table.insert(playableCards, {index = ind, card = card})
                elseif card.color ~= nil then
                    if card.color == lastPlayedCard.color then
                        table.insert(playableCards, {index = ind, card = card})
                    end

                    if (not card.playable) and lastPlayedCard.specialName ~= nil then
                        if card.specialName == lastPlayedCard.specialName then
                            table.insert(playableCards, {index = ind, card = card})
                        end
                    end

                    if (not card.playable) and (playedDeck.lastColor == card.color) then
                        table.insert(playableCards, {index = ind, card = card})
                    end
                else
                    for _, cardName in pairs(utils.powerCards) do
                        if cardName == card.specialName then
                            table.insert(playableCards, {index = ind, card = card})
                            break
                        end
                    end
                end
            end
        end

        if #playableCards > 0 then
            -- choose random item in playableCards table
            local randomIndex = math.random(1, #playableCards)
            local card = playableCards[randomIndex]

            for _, powerCard in pairs(utils.powerCards)do
                if card.card.specialName == powerCard then
                    playedDeck:pickColor(true, self)
                end
            end

            playedDeck:addCard(card.card, true, player, self)
            self:removeCard(card.index)
        else
            self:addCard(utils:drawCardOrGenerateDeck(player, self, deck, true))
        end

        player:setPlayerTurn(true)
    end

    return com
end

return Com