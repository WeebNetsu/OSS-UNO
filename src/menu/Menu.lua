local love = require "love"
local utils = require "utils"

function Menu()
    local menu = {}
    local textButtonScale, iconButtonScale = 0.7, 0.5

    local scale = {
        textButton = {
            windowWidth = love.graphics.getWidth() / textButtonScale,
            windowHeight = love.graphics.getHeight() / textButtonScale,

            width = utils.textButtonWidth * textButtonScale,
            height = utils.textButtonHeight * textButtonScale,
        },
        iconButton = {
            windowWidth = love.graphics.getWidth() / iconButtonScale,
            windowHeight = love.graphics.getHeight() / iconButtonScale,

            width = utils.iconButtonWidth * iconButtonScale,
            height = utils.iconButtonHeight * iconButtonScale,
        }
    }
    
    local backgroundImage = love.graphics.newImage("assets/backgrounds/bg2.png")

    local textButtons = {
        play = {
            src = utils:chooseButtonImage("play"),
            hoverSrc = utils:chooseButtonImage("play", false, true),
            hovering = false,
            x = scale.textButton.windowWidth / 2 - utils.textButtonWidth / 2,
            y = scale.textButton.windowHeight / 2 - scale.textButton.height,

            onClick = function (self)
                utils:changeGameState("game")
            end
        }
    }

    local iconButtons = {
        settings = {
            src = utils:chooseButtonImage("settings", true),
            hoverSrc = utils:chooseButtonImage("settings", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = scale.iconButton.windowWidth - utils.iconButtonWidth - 100,
            y = scale.iconButton.windowHeight - utils.iconButtonHeight - 100,

            onClick = function (self)
                print("Settings are to be implemented")
            end
        },
        quit = {
            src = utils:chooseButtonImage("quit", true),
            hoverSrc = utils:chooseButtonImage("quit", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = 100,
            y = scale.iconButton.windowHeight - utils.iconButtonHeight - 100,

            onClick = function (self)
                love.event.quit()
            end
        },
    }

    menu.update = function (self, clickedMouse)
        for _, button in pairs(textButtons) do
            button.hovering = utils:getMouseBetween(button.x * textButtonScale, button.y * textButtonScale, scale.textButton.width, scale.textButton.height)

            if clickedMouse then
                if button.hovering then
                    button:onClick()
                end
            end
        end

        for _, button in pairs(iconButtons) do
            button.hovering = utils:getMouseBetween(button.x * iconButtonScale, button.y * iconButtonScale, scale.iconButton.width, scale.iconButton.height)

            if clickedMouse then
                if button.hovering then
                    button:onClick()
                end
            end
        end
    end

    menu.draw = function (self)
        love.graphics.draw(backgroundImage, 0, 0)

        -- draw text buttons
        love.graphics.push()
        love.graphics.scale(textButtonScale) -- the sprite was a bit large, so I scaled it to a resonable size

        for _, button in pairs(textButtons) do
            if button.hovering then
                love.graphics.draw(button.hoverSrc, button.x, button.y)
            else
                love.graphics.draw(button.src, button.x, button.y)
            end
        end

        love.graphics.pop()

        -- draw icon buttons
        love.graphics.push()
        love.graphics.scale(iconButtonScale)

        for _, button in pairs(iconButtons) do
            if button.hovering then
                love.graphics.draw(button.hoverSrc, button.x, button.y)
            else
                love.graphics.draw(button.src, button.x, button.y)
            end
        end
        love.graphics.pop()
    end

    return menu
end

return Menu
