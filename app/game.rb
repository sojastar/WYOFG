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

    DUNGEON_SIZE  = [ 15, 15 ]
    DUNGEON_DEPTH = 3

    CLASSES       = [ :wanderer, :cleric, :mage, :warrior, :barbarian ]
    STATS         = [ :strength, :vitality, :agility, :intelligence, :luck, :aura, :morality ]

    def initialize(args)
      @mode = :load_player

      @level  = 0

    end

    def tick(args)
      case @mode
      when :load_character

      when :load_dungeon

      when :dive

      end

      render(args)

      self
    end

    def render(args)
      case @mode
      when :load_character
        args.state.character_editor.character_menu.render(args)

      when :load_dungeon
        args.state.dungeon_editor.dungeon_menu.render(args)

      when :dive

      end
    end
  end
end
