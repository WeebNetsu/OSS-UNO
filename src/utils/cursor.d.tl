global type UtilsType

local love = require "love"

global record CursorType
    record Position 
        x: number
        y: number
    end 

    joystick: love.joystick.Joystick
    pos: Position
    speed: number
    clicked: boolean
    
    load: function (CursorType)
    update: function (CursorType, dt: number)
    draw: function (CursorType)
    mousePressed: function(CursorType, x: number, y: number, button: number, istouch: boolean, presses: number)
    gamepadPressed: function(CursorType, joystick: love.joystick.Joystick, button: love.joystick.GamepadButton)
end

global CursorFunc: function() : CursorType

return CursorFunc