require "src.game.card"
require "src.menu.settings"

local love = require "love"

global record UtilsType
    record FontsType
        h1: integer
        h2: integer
        h3: integer
        h4: integer
        h5: integer
        h6: integer
        -- default font size for Love2D
        p: integer
    end

    record RGBType 
        r: number
        g: number
        b: number    
    end

    record ColorsType
        red: RGBType
        blue: RGBType
        green: RGBType
        yellow: RGBType
        background: RGBType
    end

    enum AllowedGameStates
        "menu"
        "game"
        "settings"
    end

    record GameState 
        menu: boolean
        game: boolean
        settings: boolean
    end
    
	cardHeight: integer
    cardWidth: integer
    textButtonWidth: integer
    textButtonHeight: integer
    iconButtonWidth: integer
    iconButtonHeight: integer
    -- debugging will display boxes and fps etc.
    debugging: boolean
    fonts: FontsType
    powerCards: {string}
    colors: ColorsType
    state: GameState

    getMouseBetween: function(x: number, y: number, width: number, height: number): boolean
    chooseButtonImage: function(name: string, iconButton: boolean, red: boolean): love.graphics.Image
    drawCardOrGenerateDeck: function(player: any, com: any, deck: any, isCom: boolean): CardType
    changeGameState: function(UtilsType, AllowedGameStates)
    --[[ 
        DESCRIPTION
        Read a json file and return the contents as a lua table. This function will automatically search inside the data/ folder and add a '.json' to the file name.

        PARAMETERS
        -> fileName: string - name of file to read (required)
            example: "save"
        -> path: string - path to save file (from project root)
            example: "src/data/"
    ]]
    readJSON: function(fileName: string, path: string | nil): SavedSettingsType
    --[[ 
        DESCRIPTION
        Convert a table to JSON and save it in a file. This will overwrite the file if it already exists. This function will automatically search inside the data/ folder and add a '.json' to the file name.

        PARAMETERS
        -> fileName: string - name of file to write to (required)
            example: "save"
            NB: Will search for 'data/save.json'
        -> data: table - table to be converted to JSON and saved. (required)
            example: { name = "max" }
        -> path: string - path to save file (from project root)
            example: "src/data/"
    ]]
    writeJSON: function(fileName: string, data: SavedSettingsType, path: string)
    --[[
        Will check if the user is hovering over one of the buttons

        @param buttons: table[button] -- table with all of the buttons to check, the buttons should have a hovering property

        @returns boolean -- true if one of the buttons are being hovered over
    ]]
    checkButtonsHovering: function({string: SettingButtonType}): boolean
end

return UtilsType