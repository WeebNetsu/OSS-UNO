require "src.utils.message"
require "src.menu.settings"
require "src.utils.sfx"

local utils = require "src.utils.utils"

local love = require("love")

local function Message(sfx: SFXType): MessageType
    local message: MessageType = {}

    local boxXPos, boxYPos = love.graphics.getWidth() / 2, love.graphics.getHeight() / 3
    local width, height = love.graphics.getWidth() / 4, love.graphics.getHeight() / 3
    local iconButtonScale = 0.2
    local isHoveringOverButton = false

    local scale = {
        iconButton = {
            windowWidth = love.graphics.getWidth() / iconButtonScale,
            windowHeight = love.graphics.getHeight() / iconButtonScale,

            width = utils.iconButtonWidth * iconButtonScale,
            height = utils.iconButtonHeight * iconButtonScale,
        }
    }
    
    local iconButtons: {string: SettingButtonType} = {
        close = {
            src = utils.chooseButtonImage("clear_x", true),
            hoverSrc = utils.chooseButtonImage("clear_x", true, true),
            hovering = false,
            -- don't know why we don't need a scaled button width/height, but it works lol
            x = (boxXPos + width - 50) / iconButtonScale,
            y = (boxYPos + 10) / iconButtonScale,

            onClick = function (_self: SettingButtonType)
                message.showing = false
            end
        },
    }

    message.showing = false
    -- should be very short, 3 words max
    message.title = "Invalid Action"
    -- the whole error/notification message
    message.text = "Something went wrong, lorem ipsum , lorem ipsum , lorem ipsum , lorem ipsum , lorem ipsum , lorem ipsum , lorem ipsum , lorem ipsum "
    message.type = "info"

    message.showMessage = function(self: MessageType, title: string, text: string, msgType: MessageType.AvailableMessageTypes | nil)
        self.showing = true
        self.title = title
        self.text = text
        self.type = msgType or "info"
    end

    message.update = function (_self: MessageType, clickedMouse: boolean)
        local isHovering = false
        
        for _, button in pairs(iconButtons) do
            button.hovering = utils.getMouseBetween(button.x * iconButtonScale, button.y * iconButtonScale, scale.iconButton.width, scale.iconButton.height)

            -- if isHovering is not already set to true (will always be false on the first loop, but
            -- might be true on any of the following loops) and the current button is being hovered over
            if not isHovering and button.hovering then
                isHovering = true
                isHoveringOverButton = true
            end

            -- if the isHoveringOverButton is true, play the sfx 
            if isHoveringOverButton then
                sfx:playFX("button_hover", "single")
                
                if clickedMouse then
                    -- we need to set everything to false again here, otherwise all the buttons will
                    -- be executed
                    isHoveringOverButton = false
                    button.hovering = false
                    button:onClick()
                end
            else
                sfx:setFXPlayed(false)
            end
        end

        -- If after the loop no buttons triggered isHovering to be true 
        if not isHovering then
            isHoveringOverButton = false
        end
    end

    message.draw = function (self: MessageType)
        if not self.showing then
            return
        end
        
        if self.type == "error" then
            love.graphics.setColor(235 / 255, 99 / 255, 97 / 255)
        elseif self.type == "success" then
            love.graphics.setColor(48 / 255, 218 / 255, 151 / 255)
        else
            love.graphics.setColor(3 / 255, 189 / 255, 221 / 255)
        end

        love.graphics.rectangle("fill", width, height, boxXPos, boxYPos)

        
        love.graphics.setColor(1, 1, 1)
        
        love.graphics.setFont(love.graphics.newFont(utils.fonts.h3))
        love.graphics.printf(self.title, boxXPos / 1.8, boxYPos + 10, width * 1.4, "left")

        love.graphics.setFont(love.graphics.newFont(utils.fonts.p))
        love.graphics.printf(self.text, boxXPos / 1.8, boxYPos + utils.fonts.h3 + 20, width * 1.8, "left")

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

    return message
end

return Message
