require 'lib/string.rb'
require 'lib/file.rb'

require 'app/menu.rb'
require 'app/debug.rb'

require 'app/main_menu.rb'
require 'app/dungeon_editor.rb'
require 'app/character_editor.rb'
require 'app/game.rb'


def setup(args)
  if File.exist? WYOFG::DungeonEditor::DUNGEONS_SAVE_FILE
    puts "File #{WYOFG::DungeonEditor::DUNGEONS_SAVE_FILE} exists."
  else
    puts "File #{WYOFG::DungeonEditor::DUNGEONS_SAVE_FILE} does not exists."
  end

  if File.exist? WYOFG::CharacterEditor::CHARACTERS_SAVE_FILE
    puts "File #{WYOFG::CharacterEditor::CHARACTERS_SAVE_FILE} exists."
  else
    puts "File #{WYOFG::CharacterEditor::CHARACTERS_SAVE_FILE} does not exists."
  end

  args.state.dungeons   = nil
  args.state.characters = nil

  args.state.main_menu        = WYOFG::MainMenu.new args
  args.state.dungeon_editor   = WYOFG::DungeonEditor.new args
  args.state.character_editor = WYOFG::CharacterEditor.new args
  args.state.game             = WYOFG::Game.new args

  args.state.scene  = args.state.main_menu

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
