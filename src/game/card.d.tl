global record CardType
    enum AvailableCardColors
        "blue"
        "red"
        "green"
        "yellow"
    end

    enum CardScales
        "oneRow"
        "twoRows"
        "threeRows"
    end

    color: CardType.AvailableCardColors | nil
    number: integer
    specialName: string
    imagePath: string
    rotation: number
    hovering: boolean
    playable: boolean
    x: number
    y: number
    draw: function (CardType, rotation: number | nil, isCom: boolean | nil, scale: CardType.CardScales | nil)
    setPosition: function (CardType, x: number, y: number)
end

global CardFunc: function(x: number, y: number, color: CardType.AvailableCardColors | nil, number: integer, specialName: string) : CardType

return CardFunc