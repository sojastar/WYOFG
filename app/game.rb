module WYOFG
  class Game
    TILES_SHEET   = 'sprites/sprites.png'
    TILE_SIZE     = 8
    TILES         = [ { type: 'empty',      x:  1, y: 0 },
                      { type: 'wall',       x:  2, y: 0 },
                      { type: 'vase',       x:  3, y: 0 },
                      { type: 'chest',      x:  4, y: 0 },
                      { type: 'idol',       x:  5, y: 0 },
                      { type: 'entrance',   x:  6, y: 0 },
                      { type: 'exit',       x:  7, y: 0 },
                      { type: 'trap',       x:  8, y: 0 },
                      { type: 'safe place', x:  9, y: 0 },
                      { type: 'guard',      x: 10, y: 0 } ]

    DUNGEON_SIZE        = [ 15, 15 ]
    DUNGEON_DEPTH       = 3
    DUNGEON_SCALE       = 3
    DUNGEON_POSITION_Y  = 100

    CLASSES       = [ :wanderer, :cleric, :mage, :warrior, :barbarian ]
    STATS         = [ :strength, :vitality, :agility, :intelligence, :luck, :aura, :morality ]

    def initialize(args)
      # Logic :
      @mode = :load_dungeon

      @current_dungeon    = nil
      @level              = 0
      @current_character  = nil

      # Rendering :
      width           = WYOFG::Game::DUNGEON_SIZE[0]
      height          = WYOFG::Game::DUNGEON_SIZE[1]
      pixel_width     = WYOFG::Game::TILE_SIZE * width
      pixel_height    = WYOFG::Game::TILE_SIZE * height
      @dungeon_offset = [ ( $gtk.args.grid.w - DUNGEON_SCALE * pixel_width ).div(2),
                          DUNGEON_POSITION_Y ]

      @tile_size  = DUNGEON_SCALE * TILE_SIZE
    end

    def tick(args)
      case @mode
      when :load_dungeon
        selection = args.state.dungeon_editor.dungeon_menu.tick args
        if selection != :none
          @current_dungeon  = selection
          @mode             = :load_character
        end

      when :load_character
        selection = args.state.character_editor.character_menu.tick args
        if selection != :none
          @current_character  = selection
          @mode               = :dive
        end

      when :dive

      end

      render(args)

      self
    end

    def render(args)
      args.outputs.background_color = [ 0, 0, 0 ]

      case @mode
      when :load_dungeon
        args.state.dungeon_editor.dungeon_menu.render(args)

      when :load_character
        args.state.character_editor.character_menu.render(args)

      when :dive
        args.state.dungeons[@current_dungeon][@current_level].each.with_index do |row,y|
          row.each.with_index do |tile,x|
            tile_template = WYOFG::Game::TILES[tile[:type]]
            args.outputs.primitives <<  { x:        @dungeon_offset[0] + @tile_size * x,
                                          y:        @dungeon_offset[1] + @tile_size * y,
                                          w:        @tile_size,
                                          h:        @tile_size,
                                          path:     WYOFG::Game::TILES_SHEET,
                                          source_x: WYOFG::Game::TILE_SIZE * tile_template[:x],
                                          source_y: WYOFG::Game::TILE_SIZE * tile_template[:y],
                                          source_w: WYOFG::Game::TILE_SIZE,
                                          source_h: WYOFG::Game::TILE_SIZE }
          end
        end

      end
    end
  end
end
