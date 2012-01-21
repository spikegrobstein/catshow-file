$:.push File.expand_path("../lib", __FILE__)

require 'rubygems'
require 'pp'

require 'catshow_file'

##
# Usage: ruby example.rb <path_to_tvshows_directory>
#
# Example:
#  ruby example.rb /Volumes/Drobo/TV
#
# Will iterate over all directories and recursively print out
# information about each season and episode of each show.
##

tvshow_dir = ARGV[0]
File.tvshows( tvshow_dir ).each do |tvshow|
  tvshow_info = File::Nfo.for_tvshow( tvshow )
  puts tvshow_info[:title]
  
  File.seasons( tvshow ).each do |season|
    puts "  #{ File.basename season }"
    File.episodes( season ).each do |episode|
      episode_info = File::Nfo.for_episode( episode )
      puts "    #{ episode_info[:episode] } - #{ episode_info[:title] }"
    end
  end
end
