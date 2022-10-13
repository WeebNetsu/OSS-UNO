require "src.utils.sfx"

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
    
    update: function (SettingsType, clickedMouse: boolean)
    draw: function (SettingsType)
end


global record SavedSettingsType 
    record WindowSizeType
        width: number
        height: number
    end 

    windowSize: WindowSizeType | nil
    difficulty: integer | nil
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

global SettingsFunc: function(sfx: SFXType) : SettingsType

return SettingsFunc