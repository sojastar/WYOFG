module WYOFG
  class CharacterEditor
    SAVE_ENTRIES  = 10

    TITLE       = 'Character Editor'
    TITLE_SIZE  = 1
    TITLE_FONT  = 'white_rabbit.ttf'

    DATA_SIZE     = 1
    DATA_FONT     = 'white_rabbit.ttf'
    DATA_OFFSET_Y = 600

    SHOPS = { armoury:  { name:   "Armoury",
                          goods:  [ { type:     :two_hand_sword,
                                      price:    20,
                                      can_use:  [ :barbarian ] },
                                    { type:     :broadsword,
                                      price:    16,
                                      can_use:  [ :warrior, :barbarian] },
                                    { type:     :shortsword,
                                      price:    12,
                                      can_use:  [ :wanderer, :warrior, :barbarian ] },
                                    { type:     :axe,
                                      price:    15,
                                      can_use:  [ :wanderer, :warrior, :barbarian ] },
                                    { type:     :mace,
                                      price:    8,
                                      can_use:  [ :wanderer, :warrior, :barbarian ] },
                                    { type:     :flail,
                                      price:    10,
                                      can_use:  [ :warrior, :barbarian ] },
                                    { type:     :dagger,
                                      price:    8,
                                      can_use:  [ :wanderer, :cleric, :mage, :warrior, :barbarian ] },
                                    { type:     :gauntlet,
                                      price:    6,
                                      can_use:  [ :wanderer, :warrior, :barbarian ] } ] },
              accoutrements:  { name:   "Accoutrements",
                                goods:  [ { type:     :heavy_armour,
                                            price:    18,
                                            can_use:  [ :warrior, :barbarian ] },
                                          { type:     :chain_armour,
                                            price:    15,
                                            can_use:  [ :warrior, :barbarian ] },
                                          { type:     :leather_armour,
                                            price:    9,
                                            can_use:  [ :wander, :warrior, :barbarian ] },
                                          { type:     :heavy_robe,
                                            price:    9,
                                            can_use:  [ :wanderer, :cleric, :mage, :warrior, :barbarian ] },
                                          { type:     :gold_helmet,
                                            price:    14,
                                            can_use:  [ :warrior, :barbarian ] },
                                          { type:     :headpiece,
                                            price:    8,
                                            can_use:  [ :wanderer, :cleric, :warrior, :barbarian ] },
                                          { type:     :shield,
                                            price:    6,
                                            can_use:  [ :wanderer, :cleric, :warrior, :barbarian ] },
                                          { type:     :torch,
                                            price:    6,
                                            can_use:  [ :wanderer, :cleric, :mage, :warrior, :barbarian ] } ] },
              emporium: { name:   "Emporium",
                          goods:  [ { type:     :necronomicon,
                                      price:    20,
                                      can_use:  [ :wanderer, :cleric, :mage ] },
                                    { type:     :scrolls,
                                      price:    15,
                                      can_use:  [ :mage ] },
                                    { type:     :ring,
                                      price:    14,
                                      can_use:  [ :wanderer, :cleric, :mage ] },
                                    { type:     :mystic_amulet,
                                      price:    12,
                                      can_use:  [ :wanderer, :mage ] },
                                    { type:     :sash,
                                      price:    10,
                                      can_use:  [ :wanderer, :cleric, :mage ] },
                                    { type:     :cloak,
                                      price:    8,
                                      can_use:  [ :wanderer, :cleric, :mage ] },
                                    { type:     :healing_salve,
                                      price:    6,
                                      can_use:  [ :wanderer, :cleric, :mage, :warrior, :barbarian ] },
                                    { type:     :potions,
                                      price:    6,
                                      can_use:  [ :wanderer, :cleric, :mage, :warrior, :barbarian ] } ] } }
    SHOP_WELCOME_MESSAGE        = 'Choose well Sire!'
    SHOP_CANT_BUY_MESSAGE       = 'Not for '
    SHOP_TOO_EXPENSIVE_MESSAGE  = 'It is too expensive, Sire'
    SHOP_ALREADY_HAVE_MESSAGE   = 'You have it, Sire'
    SHOPS_PADDING = 20

    NAME_INPUT_MESSAGE  = 'Name Thy Character'
    NAME_MAX_LENGTH     = 16

    LOAD_MENU_ITEMS   = SAVE_ENTRIES.times.map do |i|
                          { icon:     :none,
                            text:     "Character #{i}",
                            value:    i }
                        end
    LOAD_MENU_OPTIONS = { font:             "yoster.ttf",
                          text_color:       [ 0, 0, 0, 255 ],
                          bg_color:         [ 255, 255, 255, 255 ],
                          text_size:        1,
                          line_max_size:    30,
                          margin:           10,
                          pointer_char:     '>' }

    def initialize(args)
      # Character Data :
      if args.state.characters.nil?
        args.state.characters = SAVE_ENTRIES.times.map do |index|
                                  base_stats  = WYOFG::Game::STATS
                                                .zip( Array.new(WYOFG::Game::STATS.length) { rand(6) + 2 } )
                                                .to_h
                                  stats = WYOFG::Game::STATS
                                          .zip( Array.new(WYOFG::Game::STATS.length) { 0 } )
                                          .to_h

                                  { name:         "Player #{index}",
                                    class:        class_from_stats(base_stats,stats),
                                    base_stats:   base_stats,
                                    stats:        stats,
                                    experience:   1,
                                    stat_points:  5,
                                    gold:         150,
                                    stuff:        [] }
                                end
      end
      @current_char_index = 0

      # Editor Logic :
      @mode  = :stats

      @current_row  = 0

      @menu  = nil

      @shop_keeper = SHOP_WELCOME_MESSAGE

      # Editor Rendering :
      title_size  = $gtk.args.gtk.calcstringbox(TITLE, TITLE_SIZE, TITLE_FONT)
      @title_x    = ( $gtk.args.grid.w - title_size[0] ).div(2)
      @title_y    = $gtk.args.grid.h - title_size[1]

      lines               = WYOFG::Game::CLASSES.map { |klass| klass.to_s } +     # all the potential text lines
                            [ 'points: 99' ] +
                            WYOFG::Game::STATS.map { |stat| stat.to_s + ': 99' }
      longuest_line       = lines.sort { |l1,l2| l2.length <=> l1.length }.first
      longuest_line_size  = $gtk.args.gtk.calcstringbox(longuest_line, DATA_FONT)
      @data_offset_x      = ( $gtk.args.grid.w - longuest_line_size[0] ).to_i.div(2)
      @data_line_height   = longuest_line_size[1]
      @data_margin        = longuest_line_size[1].to_i.div(2)
    end

    def class_from_stats(base_stats,stats)
      strength      = base_stats[:strength]     + stats[:strength]
      vitality      = base_stats[:vitality]     + stats[:vitality]
      agility       = base_stats[:agility]      + stats[:agility]
      intelligence  = base_stats[:intelligence] + stats[:intelligence]
      morality      = base_stats[:morality]     + stats[:morality]

      klass = :wanderer
      klass = :cleric     if  intelligence > 6 && morality > 7
      klass = :mage       if  intelligence > 8 && morality > 7
      klass = :warrior    if  strength > 7 &&
                              morality > 5 &&
                              strength + vitality > 10
      klass = :barbarian  if  strength > 8 &&
                              vitality + agility > 12 &&
                              morality < 6

      klass
    end

    def tick(args)
      current_char  = args.state.characters[@current_char_index]

      case @mode
      when :stats
        if args.inputs.keyboard.key_down.down
          @current_row += 1
          @current_row  = 0 if @current_row >= WYOFG::Game::STATS.length
        end

        if args.inputs.keyboard.key_down.up
          @current_row -= 1
          @current_row  = WYOFG::Game::STATS.length - 1 if @current_row < 0
        end

        current_stat  = WYOFG::Game::STATS[@current_row]

        if args.inputs.keyboard.key_down.right
          if current_char[:stat_points] > 0
            current_char[:stats][current_stat] += 1
            current_char[:stat_points] -= 1
          end
        end

        if args.inputs.keyboard.key_down.left
          if current_char[:stats][current_stat] > 0
            current_char[:stats][current_stat] -= 1
            current_char[:stat_points] += 1
          end
        end

        if args.inputs.keyboard.key_down.r
          current_char[:base_stats]   = WYOFG::Game::STATS
                                        .zip( Array.new(WYOFG::Game::STATS.length) { rand(6) + 2 } )
                                        .to_h
          current_char[:stats]        = WYOFG::Game::STATS
                                        .zip( Array.new(WYOFG::Game::STATS.length) { 0 } )
                                        .to_h
          current_char[:stat_points]  = 5
          current_char[:gold]         = 150
          current_char[:stuff]        = []
        end

        current_char[:class] = class_from_stats(current_char[:base_stats],
                                                current_char[:stats])

      when :armoury, :accoutrements, :emporium
        selected_item = SHOPS[@mode][:goods][@current_row]

        if args.inputs.keyboard.key_down.down
          @current_row += 1
          @current_row  = 0 if @current_row >= SHOPS[@mode][:goods].length

          @shop_keeper = SHOP_WELCOME_MESSAGE
        end

        if args.inputs.keyboard.key_down.up
          @current_row -= 1
          @current_row  = SHOPS[@mode][:goods].length - 1 if @current_row < 0

          @shop_keeper = SHOP_WELCOME_MESSAGE
        end

        if args.inputs.keyboard.key_down.right
          if !selected_item[:can_use].include?(current_char[:class])
            @shop_keeper = SHOP_CANT_BUY_MESSAGE + "#{current_char[:class].to_s.capitalize}"

          elsif current_char[:stuff].include?(selected_item[:type]) &&
                selected_item[:type] != :potions                    &&
                selected_item[:type] != :healing_salve
            @shop_keeper = SHOP_ALREADY_HAVE_MESSAGE

          elsif selected_item[:price] > current_char[:gold]
            @shop_keeper = SHOP_TO_EXPENSIVE_MESSAGE

          else
            current_char[:stuff] << selected_item[:type]
            current_char[:gold] -= selected_item[:price]

          end
        end

      when :name
        if  args.inputs.keyboard.key_down.backspace ||
            args.inputs.keyboard.key_down.delete
          current_char[:name] = current_char[:name][0...-2]
        end

        if args.inputs.keyboard.key_down.char
          if current_char[:name].length < NAME_MAX_LENGTH
            current_char[:name] << args.inputs.keyboard.key_down.char
          end
        end

      when :load
      end

      if args.inputs.keyboard.key_down.space
        @mode = case @mode
                when :stats         then :armoury
                when :armoury       then :accoutrements
                when :accoutrements then :emporium
                when :emporium      then :name
                when :name          then :stats
                end
      end

      if args.inputs.keyboard.key_down.s
        # save
      end

      render(args)

      self
    end

    def render(args)
      args.outputs.background_color = [ 0, 0, 0 ]

      # Title :
      args.outputs.primitives <<  { x:     @title_x,
                                    y:     @title_y,
                                    text:  TITLE,
                                    font:  TITLE_FONT,
                                    size:  TITLE_SIZE,
                                    r:     255,
                                    g:     255,
                                    b:     255,
                                    a:     255 }

      # Character Data :
      character = args.state.characters[@current_char_index]

      # Pages :
      case @mode
      when :stats
        args.outputs.primitives <<  { x:    @data_offset_x,
                                      y:    DATA_OFFSET_Y,
                                      text: character[:class].capitalize,
                                      font: DATA_FONT,
                                      size: DATA_SIZE,
                                      r:    255,
                                      g:    255,
                                      b:    255,
                                      a:    255 }

        args.outputs.primitives <<  { x:    @data_offset_x,
                                      y:    DATA_OFFSET_Y - @data_margin - @data_line_height,
                                      text: "Points: #{character[:stat_points]}",
                                      font: DATA_FONT,
                                      size: DATA_SIZE,
                                      r:    255,
                                      g:    255,
                                      b:    255,
                                      a:    255 }

        WYOFG::Game::STATS.each.with_index do |stat,line|
          final_stat  = character[:base_stats][stat] + character[:stats][stat]
          indent      = line == @current_row ? '>' : ' '
          args.outputs.primitives <<  { x:    @data_offset_x,
                                        y:    DATA_OFFSET_Y - (line + 2 ) * ( @data_margin + @data_line_height ),
                                        text: "#{indent} #{stat}: #{final_stat}",
                                        font: DATA_FONT,
                                        size: DATA_SIZE,
                                        r:    255,
                                        g:    255,
                                        b:    255,
                                        a:    255 }
        end

      when :armoury, :accoutrements, :emporium
        args.outputs.primitives <<  { x:    @data_offset_x,
                                      y:    DATA_OFFSET_Y,
                                      text: SHOPS[@mode][:name].capitalize,
                                      font: DATA_FONT,
                                      size: DATA_SIZE,
                                      r:    255,
                                      g:    255,
                                      b:    255,
                                      a:    255 }

        args.outputs.primitives <<  { x:    @data_offset_x,
                                      y:    DATA_OFFSET_Y - @data_margin - @data_line_height,
                                      text: @shop_keeper,
                                      font: DATA_FONT,
                                      size: DATA_SIZE,
                                      r:    255,
                                      g:    255,
                                      b:    255,
                                      a:    255 }

        args.outputs.primitives <<  { x:    @data_offset_x,
                                      y:    DATA_OFFSET_Y - 2 * ( @data_margin + @data_line_height ),
                                      text: "Gold Coins: #{character[:gold]}",
                                      font: DATA_FONT,
                                      size: DATA_SIZE,
                                      r:    255,
                                      g:    255,
                                      b:    255,
                                      a:    255 }

        SHOPS[@mode][:goods].each.with_index do |item,line|
          item_name   = item_symbol_to_string(item[:type])
          indent      = line == @current_row ? '>' : ' '
          args.outputs.primitives <<  { x:    @data_offset_x,
                                        y:    DATA_OFFSET_Y - (line + 3 ) * ( @data_margin + @data_line_height ),
                                        text: "#{indent} #{item_name.ljust(20)}#{item[:price]}",
                                        font: DATA_FONT,
                                        size: DATA_SIZE,
                                        r:    255,
                                        g:    255,
                                        b:    255,
                                        a:    255 }
        end

      when :name
        args.outputs.primitives <<  { x:    @data_offset_x,
                                      y:    DATA_OFFSET_Y,
                                      text: NAME_INPUT_MESSAGE,
                                      font: DATA_FONT,
                                      size: DATA_SIZE,
                                      r:    255,
                                      g:    255,
                                      b:    255,
                                      a:    255 }

        args.outputs.primitives <<  { x:    @data_offset_x,
                                      y:    DATA_OFFSET_Y - @data_margin - @data_line_height,
                                      text: character[:name],
                                      font: DATA_FONT,
                                      size: DATA_SIZE,
                                      r:    255,
                                      g:    255,
                                      b:    255,
                                      a:    255 }

      when :load

      end
    end

    def item_symbol_to_string(symbol)
      symbol.to_s.gsub('_',' ').capitalize
    end
  end
end
