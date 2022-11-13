require "src.menu.game"
require "src.utils.sfx"
require "src.utils.cursor"

global record MenuType
    load: function (MenuType)
    update: function (MenuType)
    draw: function (self: MenuType)
end

global MenuFunc: function(game: GameType, sfx: SFXType, cursor: CursorType): MenuType

return MenuFunc