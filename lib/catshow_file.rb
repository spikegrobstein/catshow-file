require 'nokogiri'

require "catshow_file/version"

module Catshow
  EPISODE_SUFFIXES = %w( .mkv .avi .mp4 )

  TVSHOW_NFO_FILENAME = "tvshow.nfo"
  EPISODE_NFO_FILEEXTENSION = ".nfo"
  
  File.include CatshowFile::File
end
