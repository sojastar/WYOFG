class File
  def self.exist?(full_path)
    split_path  = full_path.split('/')
    path        = split_path[0..-2].join('/')
    filename    = split_path.last

    $gtk.args.gtk.list_files(path).include? filename
  end
end
