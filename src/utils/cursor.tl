require "src.utils.cursor"

local love = require("love")
local utils = require("src.utils.utils")

local function Cursor(): CursorType
    local cursorBorderRadius: integer = 5

    local settings: SavedSettingsType
    local control: SavedSettingsType.ControllerType

    local cursor: CursorType = {}

    -- user can potentially decide which joystick to use
    cursor.joystick = love.joystick.getJoysticks()[1]
    cursor.clicked = false

    cursor.pos = {x = 400, y = 300}
    -- user can potentially set the speed of their joysticks

    cursor.speed = 900

    cursor.mousePressed = function(self: CursorType, _x: number, _y: number, button: number, _istouch: boolean, _presses: number)
        if button == 1 then
            self.clicked = true
        end
    end

    cursor.gamepadPressed = function(self: CursorType, _joystick: love.joystick.Joystick, button: love.joystick.GamepadButton)
        if button == 'a' then
            self.clicked = true
        end
    end

    cursor.load = function (_self: CursorType)
        settings = utils.readJSON("settings")
        control = "keyboard"

        if love.joystick.getJoysticks()[1] ~= nil and settings.controller == "controller" then
            control = "controller"
        end
    end

    cursor.update = function (self: CursorType, dt: number)
        if control == "keyboard" then
            self.pos.x, self.pos.y = love.mouse.getPosition()
        else
            -- if using controller
            local posX = self.pos.x + dt * self.speed * self.joystick:getGamepadAxis("leftx")
            local posY = self.pos.y + dt * self.speed * self.joystick:getGamepadAxis("lefty")

            -- so you can use both right and left analog sticks
            if self.joystick:getGamepadAxis("rightx") ~= 0 then
                posX = self.pos.x + dt * self.speed * self.joystick:getGamepadAxis("rightx")
            end
            if self.joystick:getGamepadAxis("righty") ~= 0 then
                posY = self.pos.y + dt * self.speed * self.joystick:getGamepadAxis("righty")
            end

            if posX < (love.graphics.getWidth()) and posX > (0) then
                self.pos.x = posX
            end

            if posY < (love.graphics.getHeight()) and posY > (0) then
                self.pos.y = posY
            end
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
