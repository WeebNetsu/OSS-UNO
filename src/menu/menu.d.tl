require "src.menu.game"
require "src.utils.sfx"

global record MenuType
    load: function (MenuType)
    update: function (MenuType, clickedMouse: boolean)
    draw: function (self: MenuType)
end

global MenuFunc: function(game: GameType, sfx: SFXType): MenuType

return MenuFunc