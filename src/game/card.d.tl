global record CardType
    enum AvailableCardColors
        "blue"
        "red"
        "green"
        "yellow"
    end

    color: CardType.AvailableCardColors | nil
    number: integer
    specialName: string
    imagePath: string
    rotation: number
    playable: boolean
    x: number
    y: number
    draw: function (CardType, rotation: number, isCom: boolean)
    setPosition: function (CardType, x: number, y: number)
end

global CardFunc: function(x: number, y: number, color: CardType.AvailableCardColors | nil, number: integer, specialName: string) : CardType

return CardFunc