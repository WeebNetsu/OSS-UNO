require "src.game.card"
local love = require("love")

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
    card.hovering = false

    card.draw = function (self: CardType, rotation: number, isCom: boolean, scale: CardType.CardScales)
        local r = rotation or self.rotation
        local yPos = self.y 

        if scale == "twoRows" then
            yPos = yPos + 100
        elseif scale == "threeRows" then
            yPos = yPos + 500
        end

        if self.playable then
            if self.hovering then
                yPos = yPos - 40
            else
                yPos = yPos - 20
            end
        end

        if isCom then
            love.graphics.draw(comImage, self.x, yPos, r)
        else
            love.graphics.draw(image, self.x, yPos, r)
        end
    end

    card.setPosition = function (self: CardType, posX: number, posY: number)
        self.x = posX
        self.y = posY
    end

    return card
end

return Card
