module WYOFG
  class DungeonEditor
    EDITOR_DUNGEON_SCALE  = 3
    DUNGEON_POSITION_Y  = 100

    TITLE       = 'Dungeon Editor'
    TITLE_SIZE  = 1
    #TITLE_FONT  = 'C64_Pro_Mono-STYLE.ttf',
    TITLE_FONT  = 'white_rabit.ttf'

    HELP_OFFSET     = [ 50, 600 ]
    HELP_ENTRY_SIZE = [ 300, 40 ]
    HELP_TEXT_SIZE  = 1
    #HELP_FONT       = 'C64_Pro_Mono-STYLE.ttf'
    HELP_FONT       = 'white_rabit.ttf'

    SAVE_ENTRIES      = 10
    LOAD_MENU_ITEMS   = SAVE_ENTRIES.times.map do |i|
                          { icon:     :none,
                            text:     "Dungeon #{i}",
                            value:    i }
                        end
    LOAD_MENU_OPTIONS = { #font:             'C64_Pro_Mono-STYLE.ttf',
                          font:             "white_rabit.ttf",
                          text_color:       [ 0, 0, 0, 255 ],
                          bg_color:         [ 255, 255, 255, 255 ],
                          text_size:        1,
                          line_max_size:    30,
                          margin:           10,
                          pointer_char:     '>' }

    attr_reader :dungeons

    def initialize(args)
      # Dungeon Data :
      width   = WYOFG::Game::DUNGEON_SIZE[0]
      height  = WYOFG::Game::DUNGEON_SIZE[1]
      @dungeons = []
      @dungeons = SAVE_ENTRIES.times.map do |dungeon_index|
                    WYOFG::Game::DUNGEON_DEPTH.times.map do |level_index|
                      level = []
                      height.times do |y|
                        level << []
                        width.times { |x| level.last << { type: 0, visited: false } }
                      end
                      level
                    end
                  end
      @current_dungeon  = 0
      @current_level    = 0

      # Editor logic :
      @mode = :editor

      @load_menu  = WYOFG::UI::Menu.new LOAD_MENU_ITEMS,
                                        LOAD_MENU_OPTIONS
      @load_menu.move_to  ( $gtk.args.grid.w - @load_menu.pixel_size[0] ) / 2,
                          ( $gtk.args.grid.h - @load_menu.pixel_size[1] ) / 2

      # Editor Rendering :
      pixel_width   = WYOFG::Game::TILE_SIZE * width
      pixel_height  = WYOFG::Game::TILE_SIZE * height
      @dungeon_offset = [ ( $gtk.args.grid.w - EDITOR_DUNGEON_SCALE * pixel_width ).div(2),
                          DUNGEON_POSITION_Y ]

      @tile_size  = EDITOR_DUNGEON_SCALE * WYOFG::Game::TILE_SIZE

      @cursor       = [ WYOFG::Game::DUNGEON_SIZE[0].div(2),
                        WYOFG::Game::DUNGEON_SIZE[1].div(2) ]
      @cursor_timer = 0

      title_size  = $gtk.args.gtk.calcstringbox(TITLE, TITLE_SIZE, TITLE_FONT)
      @title_x    = ( $gtk.args.grid.w - title_size[0] ).div(2)
      @title_y    = $gtk.args.grid.h - title_size[1]

      @help_size  = $gtk.args.gtk.calcstringbox("fg", HELP_TEXT_SIZE, HELP_FONT)
    end

    def tick(args)
      case @mode
      when :editor
        if  args.inputs.keyboard.key_down.left ||
            args.inputs.controller_one.key_down.left
          @cursor[0] -= 1
          @cursor[0]  = WYOFG::Game::DUNGEON_SIZE[0] - 1 if @cursor[0] < 0 

          @cursor_timer = 0
        end

        if  args.inputs.keyboard.key_down.right ||
            args.inputs.controller_one.key_down.right
          @cursor[0] += 1
          @cursor[0]  = 0 if @cursor[0] >= WYOFG::Game::DUNGEON_SIZE[0] 

          @cursor_timer = 0
        end

        if  args.inputs.keyboard.key_down.up ||
            args.inputs.controller_one.key_down.up
          @cursor[1] += 1
          @cursor[1]  = 0 if @cursor[1] >= WYOFG::Game::DUNGEON_SIZE[1] 

          @cursor_timer = 0
        end

        if  args.inputs.keyboard.key_down.down ||
            args.inputs.controller_one.key_down.down
          @cursor[1] -= 1
          @cursor[1]  = WYOFG::Game::DUNGEON_SIZE[1] - 1 if @cursor[1] < 0 

          @cursor_timer = 0
        end

        if args.inputs.keyboard.key_down.zero
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 0
        end

        if args.inputs.keyboard.key_down.one
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 1
        end

        if args.inputs.keyboard.key_down.two
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 2
        end

        if args.inputs.keyboard.key_down.three
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 3
        end

        if args.inputs.keyboard.key_down.four
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 4
        end

        if args.inputs.keyboard.key_down.five
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 5
        end

        if args.inputs.keyboard.key_down.six
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 6
        end

        if args.inputs.keyboard.key_down.seven
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 7
        end

        if args.inputs.keyboard.key_down.eight
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 8
        end

        if args.inputs.keyboard.key_down.nine
          @dungeons[@current_dungeon][@current_level][@cursor[1]][@cursor[0]][:type] = 9
        end

        if args.inputs.keyboard.key_down.b#less_than
          @current_level -= 1
          @current_level  = 0 if @current_level < 0
        end

        if args.inputs.keyboard.key_down.n#greater_than
          @current_level += 1
          @current_level  = 2 if @current_level > 2
        end

        if args.inputs.keyboard.key_down.l
          @mode = :load_menu
        end

        if args.inputs.keyboard.key_down.s
          puts 'saving'
        end

        if args.inputs.keyboard.key_down.d
          WYOFG::Debug.put_dungeon  @dungeons[@current_dungeon][@current_level],
                                    WYOFG::Game::DUNGEON_SIZE[0],
                                    WYOFG::Game::DUNGEON_SIZE[1]
        end

      when :load_menu
        selection = @load_menu.tick args
        if selection != :none
          @current_dungeon  = selection
          @mode             = :editor
        end

        if args.inputs.keyboard.key_down.escape
          @mode = :editor
        end

      end

      render(args)

      self
    end

    def render(args)
      # Title :
      args.outputs.primitives << { x:     @title_x,
                                   y:     @title_y,
                                   text:  TITLE,
                                   font:  TITLE_FONT,
                                   size:  TITLE_SIZE,
                                   r:     0,
                                   g:     0,
                                   b:     0,
                                   a:     255 }


      # Help :
      WYOFG::Game::TILES.each.with_index do |tile,index|
        tile  = WYOFG::Game::TILES[index] 

        args.outputs.primitives <<  { x:        HELP_OFFSET[0] + HELP_ENTRY_SIZE[0] * ( index % 4 ),
                                      y:        HELP_OFFSET[1] - HELP_ENTRY_SIZE[1] * index.div(4),
                                      w:        @tile_size,
                                      h:        @tile_size,
                                      path:     WYOFG::Game::TILES_SHEET,
                                      source_x: WYOFG::Game::TILE_SIZE * tile[:x],
                                      source_y: WYOFG::Game::TILE_SIZE * tile[:y],
                                      source_w: WYOFG::Game::TILE_SIZE,
                                      source_h: WYOFG::Game::TILE_SIZE }

        args.outputs.primitives <<  { x:    @tile_size + 10 + HELP_OFFSET[0] + HELP_ENTRY_SIZE[0] * ( index % 4 ),
                                      y:    HELP_OFFSET[1] - HELP_ENTRY_SIZE[1] * index.div(4) + @help_size[1],  
                                      text: "#{index} -> #{tile[:type]}",
                                      font: HELP_FONT,
                                      size: HELP_TEXT_SIZE }
      end

      # Dungeon :
      @dungeons[@current_dungeon][@current_level].each.with_index do |row,y|
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

      case @mode
      when :editor
        # Cursor:
        @cursor_timer = ( @cursor_timer + 1 ) % 60
        alpha = @cursor_timer < 30 ? 255 : 0
        args.outputs.primitives <<  { x:  @dungeon_offset[0] + @tile_size * @cursor[0],
                                      y:  @dungeon_offset[1] + @tile_size * @cursor[1],
                                      w:  EDITOR_DUNGEON_SCALE * WYOFG::Game::TILE_SIZE,
                                      h:  EDITOR_DUNGEON_SCALE * WYOFG::Game::TILE_SIZE,
                                      r:  255,
                                      g:  0,
                                      b:  0,
                                      a:  alpha,
                                      primitive_marker: :solid }

      when :load_menu
        @load_menu.render(args)
        
      end
    end
  end
end
