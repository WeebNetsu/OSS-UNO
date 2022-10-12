local love = require("love")

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

local function Card(x: number, y: number, color: CardType.AvailableCardColors | nil, number: integer, specialName: string): CardType
    local setImage = "assets/cards/"

    if color == nil and number == nil and specialName ~= nil then
        -- setup special cards
        -- replace spaces with _
        setImage = setImage .. string.gsub(specialName, "%s+", "_")
    elseif number == nil and color ~= nil and specialName ~= nil then
        -- setup power cards
        setImage = setImage .. (color as CardType.AvailableCardColors) .. "_" .. string.gsub(specialName, "%s+", "_")
    else
        -- setup normal cards
        setImage = setImage .. (color as CardType.AvailableCardColors) .. "_" .. number
    end

    local image = love.graphics.newImage(setImage ..".png")
    local comImage = love.graphics.newImage("assets/cards/card_back_alt.png")

    local card: CardType = {}

    card.color = color
    card.number = number
    card.specialName = specialName
    card.imagePath = setImage ..".png"
    card.rotation = 0
    card.playable = false
    card.x = x
    card.y = y

    card.draw = function (self: CardType, rotation: number, isCom: boolean)
        local r = rotation or self.rotation
        local yPos = self.y

        if self.playable then
            yPos = self.y - 20
        end

        if isCom then
            love.graphics.draw(comImage, self.x, yPos, r)
        else
            love.graphics.draw(image, self.x, yPos, r)
        end
    end

    card.setPosition = function (self: CardType, x: number, y: number)
        self.x = x
        self.y = y
    end

    -- card.__eq = function (self, other)
    --     return self.color == other.color and self.number == other.number and self.specialName == other.specialName
    -- end

    return card
end

return Card
