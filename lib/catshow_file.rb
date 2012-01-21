require 'nokogiri'

require "catshow-file/version"
require "catshow-file/file"

module Catshow
  EPISODE_SUFFIXES = %w( .mkv .avi .mp4 )

  TVSHOW_NFO_FILENAME = "tvshow.nfo"
  EPISODE_NFO_FILEEXTENSION = ".nfo"  
end

class File
  include CatshowFile
end