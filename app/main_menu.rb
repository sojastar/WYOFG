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
                          #font:             "white_rabbit.ttf",
                          font:             'classic-7x5.ttf',
                          #font:             "yoster.ttf",
                          #font:             "Minecraft.ttf",
                          #font:             "C64_Pro_Mono-STYLE.ttf",
                          text_color:       [ 255, 255, 255, 255 ],
                          bg_color:         [ 0, 0, 0, 255 ],
                          text_size:        0,#1,
                          line_max_size:    30,
                          #icon_text_margin: 10,
                          margin:           10,
                          pointer_char:     '>' }

    def initialize(args)
      @menu = WYOFG::UI::Menu.new MAIN_MENU_ITEMS,
                                  MAIN_MENU_OPTIONS
      @menu.move_to ( args.grid.w - @menu.pixel_size[0] ) / 2,
                    ( args.grid.h - @menu.pixel_size[1] ) / 2

    end

    def tick(args)
      selection = @menu.tick args

      render args

      case selection
      when :none
        self

      when :dungeon_editor
        args.state.dungeon_editor

      when :character_editor
        args.state.character_editor

      when :game
        args.state.game

      end
    end

    def render(args)
      args.outputs.background_color = [0, 0, 0]
      @menu.render(args)
    end
  end
end
