-- for debugging purposes
--[[ if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end ]]

local love = require "love"
local utils = require "src.utils.utils"
local Game = require "src.game.game"
local Menu = require "src.menu.menu"
local SFX = require "src.utils.sfx"

math.randomseed(os.time())

local game: GameType
local menu: MenuType
local clickedMouse: boolean = false
local cursorBorderRadius: integer = 5
local mouseX, mouseY: number, number
local gameSettings: SavedSettingsType = {}

function love.load()
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)

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

    -- create the soundeffects
    global sfx = SFX()

    -- initialise game states
    game = Game()
    menu = Menu(game, sfx)

    -- load game states
    game:load()
    menu:load()
end

function love.mousepressed(_x: number, _y: number, button: integer, _istouch: boolean, _presses: integer)
    if button == 1 then
        clickedMouse = true
    end
end

function love.update(dt: number)
    -- mouseX and y is used in draw
    mouseX, mouseY = love.mouse.getPosition()

    if utils.state.menu then
        menu:update(clickedMouse)
    elseif utils.state.game then
        game:update(dt, clickedMouse)
    end

    if clickedMouse then
        clickedMouse = false
    end
end

function love.draw()
    if utils.state.menu then
        menu:draw()
    elseif utils.state.game then
        game:draw()
    end

    if utils.debugging then
        love.graphics.print(love.timer.getFPS() as string, 10, 10)
    end

    -- 15x15 square around cursor
    love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
    love.graphics.rectangle("line", mouseX - 7, mouseY - 7, 15, 15, cursorBorderRadius)
    love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
    love.graphics.rectangle("line", mouseX, mouseY - 7, 15, 15, cursorBorderRadius)
    love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
    love.graphics.rectangle("line", mouseX - 7, mouseY, 15, 15, cursorBorderRadius)
    love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
    love.graphics.rectangle("line", mouseX, mouseY, 15, 15, cursorBorderRadius)
    -- love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)
    love.graphics.setColor(1, 1, 1)
end
