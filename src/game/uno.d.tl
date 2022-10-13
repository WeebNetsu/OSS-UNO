require "src.game.card"
require "src.game.played_deck"

global record UnoType
    x: number
    y: number

    draw: function (UnoType, playedDeck: PlayedDeckType)
    checkHover: function (UnoType): boolean
end

global UnoFunc: function(): UnoType

return UnoFunc