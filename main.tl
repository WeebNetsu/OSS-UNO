-- for debugging purposes
--[[ if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end ]]
-- local tl = require("tl")
-- tl.loader()

local love = require "love"
local utils = require "src.utils.utils"
local Game = require "src.menu.game"
local Menu = require "src.menu.menu"
local SFX = require "src.utils.sfx"
local Settings = require "src.menu.settings"
local Message = require "src.utils.message"
local Cursor = require "src.utils.cursor"

math.randomseed(os.time())

local cursor: CursorType
local game: GameType
local menu: MenuType
local message: MessageType
local settings: SettingsType
local gameSettings: SavedSettingsType = {}

function love.load()
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)

    cursor = Cursor(utils)

    gameSettings = utils.readJSON("settings")

    -- the settings set here are the ones that will overwrite the defaults in conf.lua on startup
    if gameSettings.windowSize then
        local winSize = gameSettings.windowSize as SavedSettingsType.WindowSizeType

        if winSize.height ~= nil and winSize.width ~= nil then
            love.window.setMode(winSize.width, winSize.height)
        end
    end

    -- set initial game state to menu
    utils:changeGameState("menu")

    -- create the sound effects
    global sfx = SFX()

    -- initialize game states
    message = Message(sfx, cursor)
    game = Game(sfx, cursor)
    menu = Menu(game, sfx, cursor)
    settings = Settings(sfx, cursor)

    -- load game states
    game:load()
    menu:load()
    -- settings:load()
end

function love.gamepadpressed(joystick: love.joystick.Joystick, button: love.joystick.GamepadButton)
    cursor:gamepadPressed(joystick, button)
end

function love.mousepressed(x: number, y: number, button: integer, istouch: boolean, presses: integer)
    cursor:mousePressed(x, y, button, istouch, presses)
end

function love.update(dt: number)
    cursor:update(dt)
    
    if not message.showing then
        if utils.state.menu then
            menu:update()
        elseif utils.state.game then
            game:update(dt)
        elseif utils.state.settings then
            settings:update()
        end
    else
        message:update()
    end

    -- this is not in cursor:update() since it needs to happen
    -- at the end of an update cycle
    if cursor.clicked then
        cursor.clicked = false
    end
end

function love.draw()
    -- before everything to change the color
    if message.showing then
        love.graphics.setColor(1, 1, 1, 0.3)
    end
    
    if utils.state.menu then
        menu:draw()
    elseif utils.state.game then
        game:draw()
    elseif utils.state.settings then
        settings:draw()
    end

    love.graphics.setColor(1, 1, 1)

    -- this should be drawn after everything else to be on top
    if message.showing then
        message:draw()
    end

    if utils.debugging then
        love.graphics.print(love.timer.getFPS() as string, 10, 10)
    end

    cursor:draw()

    love.graphics.setColor(1, 1, 1)
end
