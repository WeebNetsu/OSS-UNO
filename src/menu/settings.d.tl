require "src.utils.sfx"
require "src.utils.cursor"

local love = require "love"

global record SettingsType
    record CounterType 
        title: string
        value: integer
        availableValues: {string}
        displayIndex: integer
        hovering: boolean
        onClick: function(CounterType)
    end

    updated: boolean
    
    update: function (SettingsType)
    draw: function (SettingsType)
end


global record SavedSettingsType 
    record WindowSizeType
        width: number
        height: number
    end 

    enum ControllerType
        "keyboard"
        "controller"
    end 

    windowSize: WindowSizeType | nil
    difficulty: integer | nil
    controller: ControllerType | nil
end

global record SettingButtonType
    src: love.graphics.Image
    hoverSrc: love.graphics.Image
    hovering: boolean
    -- don't know why we don't need a scaled button width/height, but it works lol
    x: number
    y: number

    onClick: function(SettingButtonType)
end

global SettingsFunc: function(sfx: SFXType, cursor: CursorType | nil) : SettingsType

return SettingsFunc