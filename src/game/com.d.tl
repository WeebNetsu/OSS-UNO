require "src.game.card"

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

global ComFunc: function(deck: any, playedDeck: any): ComType

return ComFunc