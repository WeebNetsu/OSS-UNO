require "src.utils.sfx"
require "src.utils.cursor"

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
    onClose: function(MessageType)
    showMessage: function(MessageType, title: string, text: string, msgType: AvailableMessageTypes | nil, onClose: function(MessageType) | nil)
    update: function (MessageType)
    draw: function (MessageType)
end

global MessageFunc: function(sfx: SFXType, cursor: CursorType) : MessageType

return MessageFunc