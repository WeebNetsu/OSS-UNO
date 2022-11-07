require "src.game.deck"
require "src.game.card"
require "src.game.com"
require "src.utils.sfx"
-- require "src.game.player"

global record PlayedDeckType
    cards: {CardType}
    chainCount: integer
    x: number
    y: number
    lastColor: CardType.AvailableCardColors | nil
    colorPicking: boolean

    setColorPicking: function (PlayedDeckType, colorPicking: boolean)
    checkColorPickerHover: function (PlayedDeckType): boolean
    pickColor: function (PlayedDeckType, isCom: boolean, com: ComType): boolean
    addCard: function (PlayedDeckType, card: CardType, skipColorSet: boolean, player: any--[[ PlayerType ]], com: ComType)
    draw: function (PlayedDeckType)
end

global PlayedDeckFunc: function(sfx: SFXType): PlayedDeckType

return PlayedDeckFunc