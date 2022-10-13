require "src.game.card"
require "src.game.deck"
require "src.game.played_deck"

global record ComType
    difficulty: integer
    defaultXPos: number
    defaultYPos: number
    cards: {CardType}
    skipTurn: boolean
    saidUno: boolean

    -- will set the initial 8 cards
    -- num - number of cards to draw
    setCards: function (ComType, num: number)
    updateCardPositions: function (ComType)
    addCard: function (ComType, card: CardType)
    removeCard: function (ComType, index: number)
    getCard: function (ComType, index: integer): CardType
    drawCard: function (ComType): any
    draw: function (ComType)
    play: function (ComType, player: any)
end

global ComFunc: function(deck: DeckType, playedDeck: PlayedDeckType): ComType

return ComFunc