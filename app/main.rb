require 'lib/string.rb'

require 'app/menu.rb'
require 'app/debug.rb'

require 'app/main_menu.rb'
require 'app/dungeon_editor.rb'
require 'app/character_editor.rb'
require 'app/game.rb'


def setup(args)
  args.state.scene  = WYOFG::MainMenu.new

  args.state.dungeons   = nil
  args.state.characters = nil

  args.state.setup_done = true
end

def tick(args)
  setup(args) unless args.state.setup_done

  args.state.scene = args.state.scene.tick(args)
end

module GTK
  class Console
    def console_toggle_keys
      [ :backtick ]
    end
  end
end
