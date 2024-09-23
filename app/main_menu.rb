module WYOFG
  class MainMenu
    MAIN_MENU_ITEMS   = [ { icon:     :none,
                            text:     "Dungeon Editor",
                            value:    :dungeon_editor },
                          { icon:     :none,
                            text:     "Character Editor",
                            value:    :character_editor }, 
                          { icon:     :none,
                            text:     "Game",
                            value:    :game } ]
    MAIN_MENU_OPTIONS = { #icon_width:       24,
                          #icon_height:      24,
                          font:             "yoster.ttf",
                          text_color:       [ 255, 255, 255, 255 ],
                          bg_color:         [ 0, 0, 0, 255 ],
                          text_size:        1,
                          line_max_size:    30,
                          #icon_text_margin: 10,
                          margin:           10,
                          pointer_char:     '>' }

    def initialize()
      @menu = WYOFG::UI::Menu.new MAIN_MENU_ITEMS,
                                  MAIN_MENU_OPTIONS
      @menu.move_to ( $gtk.args.grid.w - @menu.pixel_size[0] ) / 2,
                    ( $gtk.args.grid.h - @menu.pixel_size[1] ) / 2
    end

    def tick(args)
      selection = @menu.tick args
      #puts selection if selection != :none

      render args

      case selection
      when :none
        self

      when :dungeon_editor
        WYOFG::DungeonEditor.new

      when :character_editor
        WYOFG::CharacterEditor.new

      when :game
        WYOFG::Game.new

      end
    end

    def render(args)
      args.outputs.background_color = [0, 0, 0]
      @menu.render(args)
    end
  end
end
