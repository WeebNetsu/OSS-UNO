local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local math = _tl_compat and _tl_compat.math or math; local os = _tl_compat and _tl_compat.os or os



local tl = require("tl")
tl.loader()

local love = require("love")
local utils = require("src.utils.utils")
local Game = require("src.game.game")
local Menu = require("src.menu.menu")
local SFX = require("src.utils.sfx")

math.randomseed(os.time())

local game
local menu
local clickedMouse = false
local cursorBorderRadius = 5
local mouseX, mouseY
local gameSettings = {}

function love.load()
   love.mouse.setVisible(false)
   love.graphics.setBackgroundColor(utils.colors.background.r, utils.colors.background.g, utils.colors.background.b)

   gameSettings = utils.readJSON("settings")


   if gameSettings.windowSize then
      local winSize = gameSettings.windowSize

      if winSize.height ~= nil and winSize.width ~= nil then
         love.window.setMode(winSize.width, winSize.height)
      end
   end


   utils:changeGameState("menu")


   sfx = SFX()


   game = Game()
   menu = Menu(game, sfx)


   game:load()
   menu:load()
end

function love.mousepressed(_x, _y, button, _istouch, _presses)
   if button == 1 then
      clickedMouse = true
   end
end

function love.update(dt)

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
      love.graphics.print(love.timer.getFPS(), 10, 10)
   end


   love.graphics.setColor(utils.colors.blue.r, utils.colors.blue.g, utils.colors.blue.b)
   love.graphics.rectangle("line", mouseX - 7, mouseY - 7, 15, 15, cursorBorderRadius)
   love.graphics.setColor(utils.colors.red.r, utils.colors.red.g, utils.colors.red.b)
   love.graphics.rectangle("line", mouseX, mouseY - 7, 15, 15, cursorBorderRadius)
   love.graphics.setColor(utils.colors.green.r, utils.colors.green.g, utils.colors.green.b)
   love.graphics.rectangle("line", mouseX - 7, mouseY, 15, 15, cursorBorderRadius)
   love.graphics.setColor(utils.colors.yellow.r, utils.colors.yellow.g, utils.colors.yellow.b)
   love.graphics.rectangle("line", mouseX, mouseY, 15, 15, cursorBorderRadius)

   love.graphics.setColor(1, 1, 1)
end
