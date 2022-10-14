require "src.game.card"
require "src.game.com"
require "src.menu.settings"
require "src.utils.utils"

local love = require "love"
local lunajson = require 'lunajson' -- luarocks install lunajson

local utils: UtilsType = {
    cardHeight = 180,
    cardWidth = 130,
    textButtonWidth = 600,
    textButtonHeight = 200,
    iconButtonWidth = 200,
    iconButtonHeight = 200,
    debugging = false,

    fonts = {
        h1 = 60,
        h2 = 50,
        h3 = 40,
        h4 = 30,
        h5 = 20,
        h6 = 10,
        -- default font size for Love2D
        p = 14,
    },

    powerCards = {"wild color changer", "wild pick four"},

    state = {
        menu = true,
        game = false,
    },

    colors = {
        red = {
            r = 245 / 255,
            g = 100 / 255,
            b = 98 / 255
        },
        blue = {
            r = 0,
            g = 195 / 255,
            b = 229 / 255
        },
        green = {
            r = 47 / 255,
            g = 226 / 255,
            b = 155 / 255
        },
        yellow = {
            r = 247 / 255,
            g = 227 / 255,
            b = 89 / 255
        },
        background = {
            r = 51 / 255,
            g = 51 / 255,
            b = 51 / 255
        }
    },

    changeGameState = function (self: UtilsType, state: UtilsType.AllowedGameStates | nil)
        local newState: UtilsType.AllowedGameStates = state or "menu"
        self.state.menu = newState == "menu"
        self.state.game = newState == "game"
        self.state.settings = newState == "settings"
    end,

    getMouseBetween = function (x: number, y: number, width: number, height: number): boolean
        local mouseX, mouseY = love.mouse.getPosition()

        return mouseX >= x and (mouseX <= x + width) and (mouseY >= y) and (mouseY <= (y + height))
    end,

    chooseButtonImage = function(name: string, iconButton: boolean, red: boolean): love.graphics.Image
        local textButtonPath = "assets/buttons/text/"
        local iconButtonPath = "assets/buttons/icon/"

        if red then
            name = "red_" .. name
        end

        if iconButton then
           return love.graphics.newImage(iconButtonPath .. name .. ".png")
        end

        return love.graphics.newImage(textButtonPath .. name .. ".png")
    end,

    drawCardOrGenerateDeck = function (player: PlayerType, com: ComType, deck: DeckType, isCom: boolean): CardType
        local card: CardType

        if isCom then
            card = com:drawCard()
        else
            card = player:drawCard()
        end
        
        if card == nil then
            local blockedCards = {}

            -- todo just check here this used to be pairs not ipairs
            for _, xCard in ipairs(player.cards) do
                table.insert(blockedCards, xCard)
            end
            -- todo just check here this used to be pairs not ipairs
            for _, xCard in ipairs(com.cards) do
                table.insert(blockedCards, xCard)
            end

            deck:generateDeck(blockedCards as {string: CardType})

            if isCom then
                card = com:drawCard()
            else
               card = player:drawCard()
            end

            -- todo: we need to instead show an error message instead of just quiting!
            -- if card is nil stop program
            if card == nil then
                error("An exceptionally clever error has made us unable to draw a new card or generate a new deck!")
                love.event.quit()
            end
        end

        return card
    end,

    readJSON = function(fileName: string, path: string | nil): SavedSettingsType
        -- todo: if path is provided, make sure it ends with "/", add it if it doesn't
        path = path or "data/"
        local file = io.open(path .. fileName .. ".json", "r")

        if not file then
            -- todo instead of erroring, show an error
            error("Could not open save file")
        end

        local data: string = file:read("*all")
        file:close()

        return lunajson.decode(data) as SavedSettingsType
    end,

    writeJSON = function(fileName: string, data: SavedSettingsType, path: string)
        path = path or "data/"

        -- print(lunajson.encode(data))
        local file = io.open(path .. fileName .. ".json", "w")

        if not file then
            -- todo instead of erroring, show an error
            error("Could not open save file")
        end

        file:write(lunajson.encode(data))
        file:close()
    end,

    checkButtonsHovering = function (buttons: {string: SettingButtonType}): boolean
        -- we need do this check, since there can be multiple
        -- buttons, and without this if statement it will always
        -- return the answer for the LAST button, we just need
        -- to see if one of the buttons are being hovered over
        for _, button in pairs(buttons) do
            if button.hovering then
                return true
            end
        end

        return false
    end,
}

return utils

-- return {
    --[[
        This function will run button checks that needs to be ran on each
        game update loop

        @param clickedMouse: boolean -- if mouse has been clicked
        @param textButtons: {Button} -- table of text buttons
        @param iconBtns: boolean -- if loop is for icon buttons
     ]]
    --[[ runButtonChecks = function (self, clickedMouse, textButtons, iconButtons, checkIconBtns, btnScale, scale)
        -- if the cursor is hovering over the text or image buttons
        local hoveringText = self:checkButtonsHovering(textButtons)
        local hoveringIcon = self:checkButtonsHovering(iconButtons)

        local buttons = textButtons
        local currentScale = btnScale
        local selectedScale = scale.textButton

        if checkIconBtns then
            buttons = iconButtons
            -- currentScale = iconButtonScale
            selectedScale = scale.iconButton
        end

        for _, button in pairs(buttons) do
            button.hovering = self:getMouseBetween(button.x * currentScale, button.y * currentScale, selectedScale.width, selectedScale.height)

            if button.hovering then
                sfx:playFX("button_hover", "single")

                if clickedMouse then
                    button:onClick()
                end
            else
                -- if not hovering over icon buttons
                if not (hoveringText or hoveringIcon) then
                    sfx:setFXPlayed(false)
                end
            end
        end
    end ]]
-- }
