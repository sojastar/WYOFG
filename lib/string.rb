class String
  def to_lines(line_max_length)
    blocks  = self.split(' ')
    lines   = [ "" ]
    blocks.each do |block|
      if lines.last.length + block.length < line_max_length
        lines.last << block + ' '
      else
        lines.last.chop!
        lines << block + ' '
      end
    end
    lines.last.chop!
    lines
  end
end
