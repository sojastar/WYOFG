module WYOFG
  class CharacterEditor
    STATS_COUNT   = WYOFG::Game::CLASSE.keys.length
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

    #HELP_OFFSET     = [ 50, 600 ]
    #HELP_ENTRY_SIZE = [ 300, 40 ]
    #HELP_TEXT_SIZE  = 1
    #HELP_FONT       = 'yoster.ttf'

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
      if args.state.characters.nil?
        args.state.characters = SAVE_ENTRIES.times.map do |character|
                                  { stats:        Array.new(WYOFG::Game::STATS.length) { 0 },
                                    stat_points:  5,
                                    gold:         150,
                                    stuff:        [] }
                                  .to_h
                                end
      end
      @current_char_index = 0

      @mode  = :stats 

      @current_row  = 0

      @menu  = nil
    end

    def tick(args)
      current_char  = args.state.characters[@current_char_index]

      case @mode
      when :stats
        @current_row += 1 if args.inputs.keyboard.key_down.down
        @current_row  = 0 if @current_row >= STATS_COUNT
        @current_row -= 1 if args.inputs.keyboard.key_down.down
        @current_row  = STATS_COUNT if @current_row < 0

        if WYOFG::Game::STATS.keys[@current_row] == :class
          current_char[@current_row] += 1 if args.state.keyboard.key_down.right
          current_char[@current_row]  = 0 if current_char[:class] >= WYOFG::Game::STATS.length

          current_char[@current_row] -= 1 if args.state.keyboard.key_down.left
          current_char[@current_row]  = WYOFG::Game::STATS.length if current_char[:class] < 0
          
        else
          current_char[@current_row] += 1 if args.state.keyboard.key_down.right &&
                                              current_char[] > 0

          current_char[@current_row] -= 1 if args.state.keyboard.key_down.left
          current_char[@current_row]  = 0 if current_char[:class] < 0
        end

      when :armoury
      when :accoutrements
      when :emporium
      when :load
      end

      render(args)

      self
    end

    def render(args)
      case @mode
      when :stats
        CLASSES.each_pair do |klass,stats|
        end

      when :armoury
      when :accoutrements
      when :emporium
      when :load
      end
    end
  end
end
