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
      # path is a path to the episode video file
      def for_episode( path )
        xml = Nokogiri::XML( File.open(File::episode_to_nfo_path(path)) )
        xml = xml.xpath('episodedetails')
        
        {
          :title => xml.xpath('title').text,
          :season => xml.xpath('season').text.to_i,
          :episode => xml.xpath('episode').text.to_i,
          :aired => xml.xpath('aired').text,
          :plot => xml.xpath('plot').text,
          :thumb => xml.xpath('thumb').text
        }
      end
      
      # return a hash of information about a particular show
      # path is a path to the tvshow directory
      def for_tvshow( path )
        xml = Nokogiri::XML( File.open(File.join(path, Catshow::TVSHOW_NFO_FILENAME)) )
        xml = xml.xpath('tvshow')
                
        {
          :title => xml.xpath('title').text,
          :plot => xml.xpath('plot').text,
          :mpaa => xml.xpath('mpaa').text,
          :genre => xml.xpath('genre').text,
          :studio => xml.xpath('studio').text
        }
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
    
    # return an array of tvshow directory paths given a directory
    def tvshows( path )
      Dir.open(path).collect do |f|
        nil if f.match /^\./
        join(path, f) if tvshow?( join(path, f) )
      end.compact
    end
    
    # return an array of season directory paths given a tvshow directory
    def seasons(path)
      Dir.open(path).collect do |f|
        nil if f.match /^\./
        join(path, f) if season?( join(path, f) )
      end.compact
    end
    
    # return an array of episode video file paths given a season directory
    def episodes(path)
      Dir.open(path).collect do |f|
        nil if f.match /^\./
        join(path, f) if episode?( join(path, f) )
      end.compact
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

puts "Info:"
pp File::ShowInfo::for_episode( '/Users/spike/Desktop/catshow_files/tv/Frisky Dingo/Season 01/Frisky Dingo - 1x06 - Emergency Room.avi' )

puts "show info"
show_nfo_path = '/Users/spike/Desktop/catshow_files/tv/Frisky Dingo'
pp File::ShowInfo::for_tvshow( show_nfo_path )
pp File.exists?( show_nfo_path )

puts "tv shows"
pp File.tvshows "/Users/spike/Desktop/catshow_files/tv"

puts "seasons"
pp File.seasons "/Users/spike/Desktop/catshow_files/tv/Frisky Dingo"

puts "episodes"
pp File.episodes "/Users/spike/Desktop/catshow_files/tv/Frisky Dingo/Season 01"