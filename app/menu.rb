module WYOFG
  module UI
    class Menu
      DEFAULT_LINE_SIZE       = 30
      DEFAULT_TEXT_SIZE       = 0
      DEFAULT_TEXT_COLOR      = [ 0, 0, 0, 255]
      DEFAULT_BG_COLOR        = [ 255, 255, 255, 255 ]
      DEFAULT_MARGIN          = 10
      DEFAULT_POINTER_CHAR    = '>'

      attr_reader :items, :current_item,
                  :position, :pixel_size

      def initialize(items,options)
        @items        = items
        @current_item = 0

        @options  = options
        @options[:line_max_size]  = DEFAULT_LINE_SIZE       unless @options.has_key?(:line_max_size)
        @options[:text_size]      = DEFAULT_TEXT_SIZE       unless @options.has_key?(:text_size)
        @options[:text_color]     = DEFAULT_TEXT_COLOR      unless @options.has_key?(:text_color)
        @options[:bg_color]       = DEFAULT_BG_COLOR        unless @options.has_key?(:bg_color)
        @options[:margin]         = DEFAULT_MARGIN          unless @options.has_key?(:margin)
        @options[:pointer_char]   = DEFAULT_POINTER_CHAR    unless @options.has_key?(:pointer_char)

        calculate_pixel_size

        @position = [ 0, 0 ]
      end

      def calculate_pixel_size
        longest_line  = items.map { |item|
                          item[:text].to_lines @options[:line_max_size]
                        }
                        .flatten
                        .sort { |l1,l2| l2.length <=> l1.length }
                        .first
        @text_pixel_size  = $gtk.args.gtk.calcstringbox(longest_line,
                                                        @options[:text_size],
                                                        @options[:font])

        @pointer_size = $gtk.args.gtk.calcstringbox(@options[:pointer_char],
                                                    @options[:text_size],
                                                    @options[:font])

        @items_max_height = @items.map { |item|
                                text_lines  = item[:text].length.div(@options[:line_max_size]) + 1
                              if @options.has_key?(:icon_height)
                                [ @text_pixel_size[1] * text_lines, 
                                  @options[:icon_height] ].max
                              else
                                @text_pixel_size[1] * text_lines
                              end
                            }.max 

        @icon_offset, @text_offset  = if @options.has_key?(:icon_width)
                                        [ 2 * @options[:margin] + @pointer_size[0],
                                          3 * @options[:margin] + @pointer_size[0] + @options[:icon_width] ]
                                      else
                                        [ 0, 2 * @options[:margin] + @pointer_size[0] ]
                                      end

        @pixel_size = [ @text_offset + @text_pixel_size[0] + @options[:margin],
                        @items.length * @text_pixel_size[1] ]
      end

      def move_to(x,y)
        @position = [ x, y ]
      end

      def tick(args)
        if  args.inputs.keyboard.key_down.down ||
            args.inputs.controller_one.key_down.down
          @current_item += 1
          @current_item  = 0 if @current_item >= @items.length 
        end

        if  args.inputs.keyboard.key_down.up ||
            args.inputs.controller_one.key_down.up
          @current_item -= 1
          @current_item  = @items.length - 1 if @current_item < 0 
        end

        if  args.inputs.keyboard.key_down.enter ||
            args.inputs.keyboard.key_down.space ||
            args.inputs.controller_one.key_down.a
          @items[@current_item][:value]
        else
          :none
        end
      end

      def render(args)
        # Background :
        args.outputs.primitives <<  { x:  @position[0],
                                      y:  @position[1],
                                      w:  @pixel_size[0],
                                      h:  @pixel_size[1],
                                      r:  @options[:bg_color][0],
                                      g:  @options[:bg_color][1],
                                      b:  @options[:bg_color][2],
                                      a:  @options[:bg_color][3],
                                      primitive_marker: :solid }

        @items.each.with_index do |item,index|
          y = @position[1] + @items_max_height * (@items.length - index )

          # Cursor :
          if index == @current_item
            args.outputs.primitives <<  { x:          @position[0] + @options[:margin],
                                          y:          y,
                                          text:       @options[:pointer_char],
                                          font:       @options[:font],
                                          size_enum:  @options[:text_size],
                                          r:          @options[:text_color][0],
                                          g:          @options[:text_color][1],
                                          b:          @options[:text_color][2],
                                          a:          @options[:text_color][3] }
          end

          if item[:icon] != :none
            # Icon :
            args.outputs.primitives << { x:     @position[0] + @icon_offset,
                                         y:     y,
                                         w:     @options[:icon_width],
                                         h:     @options[:icon_height],
                                         path:  item[:icon] }
          end

          # Text :
          args.outputs.primitives <<  { x:          @position[0] + @text_offset,
                                        y:          y,
                                        text:       item[:text],
                                        font:       @options[:font],
                                        size_enum:  @options[:text_size],
                                        r:          @options[:text_color][0],
                                        g:          @options[:text_color][1],
                                        b:          @options[:text_color][2],
                                        a:          @options[:text_color][3] }
        end
      end
    end
  end
end
