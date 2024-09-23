module WYOFG
  module Debug
    def self.put_dungeon(dungeon,width,height)
      dungeon.each.with_index do |row,y|
        row.each.with_index do |tile,x|
          print "#{tile[:type]} "
        end
        print "\n"
      end
    end
  end
end
