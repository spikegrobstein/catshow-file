require 'rubygems'
require 'nokogiri'
require 'pp'

class File
  
  module Catshow
    EPISODE_SUFFIXES = %w( mkv avi mp4 )
  end
  
  class << self
    
    def tvshow?(path)
      directory?(path) and exists?( join(path, 'tvshow.nfo') )
    end
    
    def season?(path)
      directory?(path) and tvshow?( join(path, '..') ) and !!basename(path).match(/^Season\s+\d+$/i)
    end
    
    def episode?(path)
      pp path.end_with?( *Catshow::EPISODE_SUFFIXES )
      pp season?( join(path, '..') )
      file?(path) and season?( join(path, '..') ) and path.end_with?( *Catshow::EPISODE_SUFFIXES )
    end
    
    def seasons(path)
      []
    end
  end
end

