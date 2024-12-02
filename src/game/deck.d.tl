require "src.game.card"
require "src.utils.sfx"
require "src.utils.cursor"

global record DeckType
    x: number
    y: number
    deck: {CardType}

    compareDeckToBlockedCards: function (DeckType, card: CardType, blockedCards: {string: CardType}): boolean
    shuffle: function (DeckType)
    generateDeck: function (DeckType, blockedCards: {string: CardType} | nil)
    checkHover: function (DeckType): boolean
    draw: function (DeckType)
    drawCard: function (DeckType, cardX: number, cardY: number, bot: boolean): CardType
end

global DeckFunc: function(sfx: SFXType, cursor: CursorType): DeckType

return DeckFunc