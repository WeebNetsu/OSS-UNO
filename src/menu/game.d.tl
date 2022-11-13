require "src.utils.sfx"
require "src.utils.message"
require "src.utils.cursor"

global record GameType
    load: function (GameType)
    update: function (GameType, dt: number)
    draw: function (GameType)
end

global GameFunc: function(sfx: SFXType, cursor: CursorType): GameType

return GameFunc