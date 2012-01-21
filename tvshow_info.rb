require 'rubygems'
require 'nokogiri'
require 'pp'

class File
  
  module Catshow
    EPISODE_SUFFIXES = %w( .mkv .avi .mp4 )
    
    TVSHOW_NFO_FILENAME = "tvshow.nfo"
    EPISODE_NFO_FILEEXTENSION = ".nfo"
  end
  
  module ShowInfo
    class << self
      
      # return a hash of information about a particular episode
      # path is a path to the nfo XML file
      def about_episode( path )
      
      end
      
      # return a hash of information about a particular show
      # path is a path to the tvshow.nfo XML file
      def about_tvshow( path )
        
      end
      
    end
  end
  
  class << self
    
    def tvshow?(path)
      path = expand_path( path )
      directory?(path) and exists?( join(path, Catshow::TVSHOW_NFO_FILENAME) )
    end
    
    def season?(path)
      path = expand_path( path )
      directory?(path) and tvshow?( join(path, '..') ) and !!basename(path).match(/^Season\s+\d+$/i)
    end
    
    def episode?(path)
      path = expand_path( path )
      file?(path) and season?( join(path, '..') ) and path.end_with?( *Catshow::EPISODE_SUFFIXES )
    end
    
    def about_episode(episode_path)
      
    end
    
    def seasons(tvshow_path)
      []
    end
    
    def episodes(season_path)
      
    end
    
    def episode_to_nfo_path( episode_path )
      return false unless episode?( episode_path )
      
      episode_path.gsub /#{ extname(episode_path) }$/, Catshow::EPISODE_NFO_FILEEXTENSION
    end
  end
end

puts "episode?"
pp File.episode? "/Users/spike/Desktop/catshow_files/tv/Frisky Dingo/Season 01/Frisky Dingo - 1x06 - Emergency Room.avi"

puts "episode_to_nfo_path"
pp File.episode_to_nfo_path( '/Users/spike/Desktop/catshow_files/tv/Frisky Dingo/Season 01/Frisky Dingo - 1x06 - Emergency Room.avi' )