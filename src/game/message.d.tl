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
    draw: function (MessageType)
end

global MessageFunc: function() : MessageType

return MessageFunc