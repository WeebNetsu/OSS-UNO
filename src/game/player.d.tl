require "src.game.deck"
require "src.game.card"
require "src.game.com"
require "src.utils.sfx"
require "src.game.played_deck"
require "src.utils.cursor"

-- player has all the same types as Com
-- Com inherits from the player type
global record PlayerType
    playerTurn: boolean

    setPlayerTurn: function (PlayerType, playerTurn: boolean)
    showPlayableCards: function (PlayerType)
    -- to be used to see if a card is being hovered over, return true or false
    checkHover: function (PlayerType): boolean
    -- used to see which card is being hoved over, table of booleans is returned
    checkHovering: function (self: PlayerType): {boolean}

    -- com also has one of these functions, don't also put them into this file
    updateCardPositions: function (PlayerType)
    removeCard: function (PlayerType, index: integer, com: ComType)
    draw: function (PlayerType)
    setCardIsHovering: function (PlayerType)

    -- com + player stuff
    difficulty: integer
    defaultXPos: number
    defaultYPos: number
    cards: {CardType}
    skipTurn: boolean
    saidUno: boolean

    -- will set the initial 8 cards
    -- num - number of cards to draw
    setCards: function (PlayerType, num: number)
    addCard: function (PlayerType, card: CardType)
    getCard: function (PlayerType, index: integer): CardType
    drawCard: function (PlayerType): CardType
    -- play: function (PlayerType, player: PlayerType)
end

global PlayerDeckFunc: function(deck: DeckType, playedDeck: PlayedDeckType, sfx: SFXType, cursor: CursorType): PlayerType

return PlayerDeckFunc