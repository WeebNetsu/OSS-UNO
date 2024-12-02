require "src.game.card"
require "src.game.deck"
require "src.utils.sfx"

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
    drawCard: function (ComType): CardType
    draw: function (ComType)
    play: function (ComType, player: any --[[ PlayerType ]])
end

global ComFunc: function(deck: DeckType, playedDeck: any --[[ playedDeckType ]], sfx: SFXType | nil): ComType

return ComFunc