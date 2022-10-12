local love = require "love"
local lunajson = require 'lunajson' -- luarocks install lunajson

return {
    cardHeight = 180,
    cardWidth = 130,
    textButtonWidth = 600,
    textButtonHeight = 200,
    iconButtonWidth = 200,
    iconButtonHeight = 200,
    -- debugging will display boxes and fps etc.
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

    getMouseBetween = function (self, x, y, width, height)
        local mouse_x, mouse_y = love.mouse.getPosition()

        return mouse_x >= x and (mouse_x <= x + width) and (mouse_y >= y) and (mouse_y <= (y + height))
    end,

    chooseButtonImage = function(self, name, iconButton, red)
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

    drawCardOrGenerateDeck = function (self, player, com, deck, isCom)
        local card

        if isCom then
            card = com:drawCard()
        else
            card = player:drawCard()
        end
        
        if card == nil then
            local blockedCards = {}

            for _, xCard in pairs(player.cards) do
                table.insert(blockedCards, xCard)
            end
            for _, xCard in pairs(com.cards) do
                table.insert(blockedCards, xCard)
            end

            deck:generateDeck(blockedCards)

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

    state = {
        menu = true,
        game = false,
    },

    changeGameState = function (self, state)
        self.state.menu = state == "menu"
        self.state.game = state == "game"
    end,

    --[[ 
        DESCRIPTION
        Read a json file and return the contents as a lua table. This function will automatically search inside the data/ folder and add a '.json' to the file name.

        PARAMETERS
        -> file_name: string - name of file to read (required)
            example: "save"
        -> path: string - path to save file (from project root)
            example: "src/data/"
    ]]
    readJSON = function(self, file_name, path)
        -- todo: if path is provided, make sure it ends with "/", add it if it doesn't
        path = path or "data/"
        local file = io.open(path .. file_name .. ".json", "r")

        if not file then
            -- todo instead of erroring, show an error
            error("Could not open save file")
        end

        local data = file:read("*all")
        file:close()

        return lunajson.decode(data)
    end,

    --[[ 
        DESCRIPTION
        Convert a table to JSON and save it in a file. This will overwrite the file if it already exists. This function will automatically search inside the data/ folder and add a '.json' to the file name.

        PARAMETERS
        -> file_name: string - name of file to write to (required)
            example: "save"
            NB: Will search for 'data/save.json'
        -> data: table - table to be converted to JSON and saved. (required)
            example: { name = "max" }
        -> path: string - path to save file (from project root)
            example: "src/data/"
    ]]
    writeJSON = function(self, file_name, data, path)  -- added a method to write json
        path = path or "data/"

        print(lunajson.encode(data))
        local file = io.open(path .. file_name .. ".json", "w")

        if not file then
            -- todo instead of erroring, show an error
            error("Could not open save file")
        end

        file:write(lunajson.encode(data))
        file:close()
    end,


    --[[
        Will check if the user is hovering over one of the buttons

        @param buttons: table[button] -- table with all of the buttons to check, the buttons should have a hovering property

        @returns boolean -- true if one of the buttons are being hovered over
    ]]
    checkButtonsHovering = function (self, buttons)
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
}
