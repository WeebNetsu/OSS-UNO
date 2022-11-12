require "src.game.message"
local love = require("love")

local function Message(): MessageType
    local message: MessageType = {}

    message.showing = true
    message.title = "Invalid Action"
    message.text = "Something went wrong"
    message.type = "info"

    message.showMessage = function(self: MessageType, title: string, text: string, msgType: MessageType.AvailableMessageTypes | nil)
        self.showing = true
        self.title = title
        self.text = text
        self.type = msgType or "info"
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

        love.graphics.rectangle("fill", love.graphics.getWidth() / 4, love.graphics.getHeight() / 3, love.graphics.getWidth() / 2, love.graphics.getHeight() / 3)
    end

    return message
end

return Message
