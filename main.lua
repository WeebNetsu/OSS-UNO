-- for debugging purposes
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local love = require "love"
local utils = require "utils"
local Game = require "src.game.Game"
local Menu = require "src.menu.Menu"

math.randomseed(os.time())

local game, menu
local clickedMouse = false
local cursorBorderRadius = 5
local mouseX, mouseY

function love.load()
    love.mouse.setVisible(false)
    love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)

    -- set initial game state to menu
    utils:changeGameState("menu")

    game = Game()
    menu = Menu()

    game:load()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        clickedMouse = true
    end
end

function love.update(dt)
    -- mouseX and y is used in draw
    mouseX, mouseY = love.mouse.getPosition()

    if utils.state.menu then
        menu:update(mouseX, mouseY)
    elseif utils.state.game then
        game:update(dt, clickedMouse)
    end

    if clickedMouse then
        clickedMouse = false
    end
end

function love.draw()
    love.graphics.print(love.timer.getFPS(), 10, 10)

    if utils.state.menu then
        menu:draw()
    elseif utils.state.game then
        game:draw()
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
