require 'chunky_png'

SPRITES = [ [ 255, 255, 255, 255, 255, 255, 255, 255 ],
            [ 0, 0, 0, 0, 0, 0, 0, 0 ], 
            [ 85, 170, 85, 170, 85, 170, 85, 170 ],
            [ 0, 60, 24, 60, 126, 126, 126, 60 ],
            [ 0, 56, 100, 114, 95, 73, 41, 31 ],
            [ 20, 42, 20, 20, 93, 93, 62, 99 ],
            [ 60, 126, 255, 255, 255, 253, 255, 255 ],
            [ 60, 102, 195, 129, 129, 129, 133, 129 ],
            [ 129, 66, 36, 0, 0, 36, 66, 129 ],
            [ 0, 60, 66, 66, 66, 66, 60, 0 ],
            [ 76, 158, 170, 190, 84, 30, 37, 88 ],
            [ 0, 56, 84, 124, 56, 44, 68, 102 ],
            [ 0, 8, 28, 42, 127, 85, 65, 34 ] ]
SPRITE_SIZE = [ 8, 8 ]

png = ChunkyPNG::Image.new  SPRITE_SIZE[0] * SPRITES.length,
                            SPRITE_SIZE[1],
                            ChunkyPNG::Color::TRANSPARENT

SPRITES.each.with_index do |sprite,index|
  sprite.each.with_index do |line,y|
    SPRITE_SIZE[0].times do |x|
      color = line >> x & 1 == 1 ? ChunkyPNG::Color::WHITE : ChunkyPNG::Color::BLACK
      png[x + SPRITE_SIZE[0] * index, y] = color
    end
  end
end

png.save('sprites.png', :interlace => true)
