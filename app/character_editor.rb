module WYOFG
  class CharacterEditor
    SAVE_ENTRIES  = 10

    SHOPS = { armoury:  { name:   "Armoury",
                          goods:   { two_hand_sword: { type: :two_hand_sword,
                                                              price:  0,
                                                              can_use:  [] },
                                            broadsword:     { type:   :broadsword,
                                                              price:  0,
                                                              can_use:  [] },
                                            shortsword:     { type:   :shortsword,
                                                              price:  0,
                                                              can_use:  [] },
                                            axe:            { type:   :axe,
                                                              price:  0,
                                                              can_use:  [] },
                                            mace:           { type:   :mace,
                                                              price:  0,
                                                              can_use:  [] },
                                            flail:          { type:   :flail,
                                                              price:  0,
                                                              can_use:  [] },
                                            dagger:         { type:   :dagger,
                                                              price:  0,
                                                              can_use:  [] },
                                            gauntlet:       { type:   :gauntlet,
                                                              price:  0,
                                                              can_use:  [] } } },
              accoutrements:  { name:   "Accoutrements",
                                goods:  { heavy_armour:   { type:   :heavy_armour,
                                                            price:  0,
                                                            can_use:  [] },
                                          chain_armour:   { type:   :chain_armour,
                                                            price:  0,
                                                            can_use:  [] },
                                          leather_amour:  { type:   :leather_armour,
                                                            price:  0,
                                                            can_use:  [] },
                                          heavy_robe:     { type:   :heavy_robe,
                                                            price:  0,
                                                            can_use:  [] },
                                          gold_helmet:    { type:   :gold_helmet,
                                                            price:  0,
                                                            can_use:  [] },
                                          headpiece:      { type:   :headpiece,
                                                            price:  0,
                                                            can_use:  [] },
                                          shield:         { type:   :shield,
                                                            price:  0,
                                                            can_use:  [] },
                                          torch:          { type:   :torch,
                                                            price:  0,
                                                            can_use:  [] } } },
              emporium: { name:   "Emporium",
                          goods:  { necronomicon:   { type:   :necronomicon,
                                                      price:  0,
                                                      can_use:  [] },
                                    scrolls:        { type:   :scrolls,
                                                      price:  0,
                                                      can_use:  [] },
                                    ring:           { type:   :ring,
                                                      price:  0,
                                                      can_use:  [] },
                                    mystic_amulet:  { type:   :mystic_amulet,
                                                      price:  0,
                                                      can_use:  [] },
                                    sash:           { type:   :sash,
                                                      price:  0,
                                                      can_use:  [] },
                                    cloak:          { type:   :cloak,
                                                      price:  0,
                                                      can_use:  [] },
                                    healing_salve:  { type:   :healing_salve,
                                                      price:  0,
                                                      can_use:  [] },
                                    potions:        { type:   :potions,
                                                      price:  0,
                                                      can_use:  [] } } } }

    TITLE       = 'Character Editor'
    TITLE_SIZE  = 1
    TITLE_FONT  = 'yoster.ttf'

    DATA_SIZE     = 1
    DATA_FONT     = 'yoster.ttf'
    DATA_OFFSET_Y = 600

    SAVE_ENTRIES      = 10
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
        args.state.characters = SAVE_ENTRIES.times.map do |character|
                                  base_stats  = WYOFG::Game::STATS
                                                .zip( Array.new(WYOFG::Game::STATS.length) { rand(6) + 2 } )
                                                .to_h
                                  stats = WYOFG::Game::STATS
                                          .zip( Array.new(WYOFG::Game::STATS.length) { 0 } )
                                          .to_h

                                  { class:        class_from_stats(base_stats,stats),
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
          @current_row  = WYOFG::Game::STATS.length if @current_row < 0
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

        current_char[:class] = class_from_stats(current_char[:base_stats],
                                                current_char[:stats])

      when :armoury
      when :accoutrements
      when :emporium
      when :load
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

        #character[:stats].each_pair.with_index do |pair,line|
        WYOFG::Game::STATS.each.with_index do |stat,line|
          final_stat  = character[:base_stats][stat] + character[:stats][stat]
          indent      = line == @current_row ? '>' : ' '
          args.outputs.primitives <<  { x:    @data_offset_x,
                                        y:    DATA_OFFSET_Y - (line + 2 ) * ( @data_margin + @data_line_height ),
                                        #text: "#{indent} #{pair.first}: #{pair.last}",
                                        text: "#{indent} #{stat}: #{final_stat}",
                                        font: DATA_FONT,
                                        size: DATA_SIZE,
                                        r:    255,
                                        g:    255,
                                        b:    255,
                                        a:    255 }
        end

      when :armoury
      when :accoutrements
      when :emporium
      when :load
      end
    end
  end
end
