require 'rubygems'
require 'nokogiri'
require 'pp'

class File
  
  module Catshow
    EPISODE_SUFFIXES = %w( mkv avi mp4 )
  end
  
  class << self
    
    def tvshow?(path)
      path = expand_path( path )
      directory?(path) and exists?( join(path, 'tvshow.nfo') )
    end
    
    def season?(path)
      path = expand_path( path )
      directory?(path) and tvshow?( join(path, '..') ) and !!basename(path).match(/^Season\s+\d+$/i)
    end
    
    def episode?(path)
      path = expand_path( path )
      file?(path) and season?( join(path, '..') ) and path.end_with?( *Catshow::EPISODE_SUFFIXES )
    end
    
    def seasons(path)
      []
    end
  end
end

pp File.episode? "/Users/spike/Desktop/catshow_files/tv/Frisky Dingo/Season 01/Frisky Dingo - 1x06 - Emergency Room.avi"