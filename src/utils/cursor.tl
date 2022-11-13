require "src.utils.cursor"

local love = require("love")
local utils = require("src.utils.utils")

local function Cursor(): CursorType
    local cursorBorderRadius: integer = 5

    local settings = utils.readJSON("settings")
    local control = "keyboard"

    if love.joystick.getJoysticks()[1] ~= nil and settings.controller == "controller" then
        control = "controller"
    end

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

    cursor.refresh = function (_self: CursorType)
        settings = utils.readJSON("settings")
    end

    cursor.update = function (self: CursorType, dt: number)
        if control == "keyboard" then
            self.pos.x, self.pos.y = love.mouse.getPosition()
        else
            -- if using controller
            self.pos.x = self.pos.x + dt * self.speed * self.joystick:getGamepadAxis("leftx")
            self.pos.y = self.pos.y + dt * self.speed * self.joystick:getGamepadAxis("lefty")
            self.pos.x = self.pos.x + dt * self.speed * self.joystick:getGamepadAxis("rightx")
            self.pos.y = self.pos.y + dt * self.speed * self.joystick:getGamepadAxis("righty")
        end
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
