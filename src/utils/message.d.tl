require "src.utils.sfx"

global record MessageType
    enum AvailableMessageTypes
        "error"
        "success"
        "info"
    end
    
    showing: boolean
    type: AvailableMessageTypes
    title: string
    text: string
    showMessage: function(MessageType, title: string, text: string, msgType: AvailableMessageTypes | nil)
    update: function (MessageType, clickedMouse: boolean)
    draw: function (MessageType)
end

global MessageFunc: function(sfx: SFXType) : MessageType

return MessageFunc