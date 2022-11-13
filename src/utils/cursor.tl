require "src.utils.cursor"
require "src.utils.utils"

local love = require("love")

local function Cursor(utils: UtilsType): CursorType
    local cursorBorderRadius: integer = 5

    local cursor: CursorType = {}

    -- user can potentially decide which joystick to use
    cursor.joystick = love.joystick.getJoysticks()[1]
    cursor.clicked = false

    cursor.pos = {x = 400, y = 300}
    -- user can potentially set the speed of their joysticks

    cursor.speed = 900

    cursor.mousePressed = function(self: CursorType, _x: number, _y: number, button: integer, _istouch: boolean, _presses: integer)
        if button == 1 then
            self.clicked = true
        end
    end

    cursor.gamepadPressed = function(self: CursorType, _joystick: love.joystick.Joystick, button: love.joystick.GamepadButton)
        if button == 'a' then
            self.clicked = true
        end
    end

    cursor.update = function (self: CursorType, dt: number)
        self.pos.x = self.pos.x + dt * self.speed * self.joystick:getGamepadAxis("leftx")
        self.pos.y = self.pos.y + dt * self.speed * self.joystick:getGamepadAxis("lefty")
	
        -- rightCircle.x = rightCircle.x + dt*speed*joystick:getGamepadAxis("rightx")
        -- rightCircle.y = rightCircle.y + dt*speed*joystick:getGamepadAxis("righty")
    end

    cursor.draw = function (self: CursorType)
        -- 15x15 square around cursor
        love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
        love.graphics.rectangle("line", self.pos.x - 7, self.pos.y - 7, 15, 15, cursorBorderRadius)
        love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
        love.graphics.rectangle("line", self.pos.x, self.pos.y - 7, 15, 15, cursorBorderRadius)
        love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
        love.graphics.rectangle("line", self.pos.x - 7, self.pos.y, 15, 15, cursorBorderRadius)
        love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, 15, 15, cursorBorderRadius)
        -- love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)
    end

    return cursor
end

return Cursor
