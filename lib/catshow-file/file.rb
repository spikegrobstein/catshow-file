module CatshowFile

  module Nfo
    class << self
    
      # given a path to an episode video file
      # return a hash of information about a particular episode
      def for_episode( path )
        xml = Nokogiri::XML( File.open(File::episode_nfo_path(path)) )
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
    
      # given a path to a tvshow directory
      # return a hash of information about a particular show
      def for_tvshow( path )
        xml = Nokogiri::XML( File.open(File.tvshow_nfo_path(path)) )
        xml = xml.xpath('tvshow')
              
        {
          :title => xml.xpath('title').text,
          :plot => xml.xpath('plot').text,
          :mpaa => xml.xpath('mpaa').text,
          :genre => xml.xpath('genre').text,
          :studio => xml.xpath('studio').text
        }
      end
      
      ##
      # given a path to a movie directory
      # return a hash of information about a particular movie
      # reads in movie.nfo
      def for_movie( path )
        xml = Nokogiri::XML( File.open(File.movie_nfo_path(path)) )
        xml = xml.xpath('movie')
        
        movie_data = {
          :title => xml.xpath('title').text,
          :rating => xml.xpath('rating').text,
          :year => xml.xpath('year').text,
          :outline => xml.xpath('outline').text,
          :runtime => xml.xpath('runtime').text,
          :release_date => xml.xpath('premiered').text,
          :rating => xml.xpath('mpaa').text
        }
      end
    
    end
  end

  def self.included(base)
    base.send :extend, CatshowFile
  end
  
  # returns true if the given path contains a TV show
  # detected by looking for a #{path}/tvshow.nfo file
  def tvshow?(path)
    path = expand_path( path )
    directory?(path) and exists?( join(path, Catshow::TVSHOW_NFO_FILENAME) )
  end

  # returns true if the given path contains a season
  # detected by looking for a directory in a tvshow directory AND the directory is called Season XX
  def season?(path)
    path = expand_path( path )
    directory?(path) and tvshow?( join(path, '..') ) and !!basename(path).match(/^Season\s+\d+$/i)
  end

  # returns true if the given path piints to a video file
  # video files have a video file extension (eg: mkv, mp4, avi) and are in a Season directory
  def episode?(path)
    path = expand_path( path )
    file?(path) and season?( join(path, '..') ) and path.end_with?( *Catshow::EPISODE_SUFFIXES )
  end
  
  # returns true if the given path points to a movie directory
  def movie_dir?(path)
    path = expand_path( path )
    directory?(path) and exists?( join(path, Catshow::MOVIE_NFO_FILENAME) )
  end
  
  # return the title of the current TV show
  def tvshow( path )
    path = expand_path( path )
    
    begin
      return basename( path ) if tvshow?( path )
    end while ( path = expand_path( File.join( path, '..' )) ) != '/'
      
    return false
  end

  # return an array of tvshow directory paths given a directory
  def tvshows( path )
    collect_items( path ) { |p| tvshow?(p) }
  end
  
  # return the season of the current directory
  def season( path )
    path = expand_path( path )
    
    begin
      if season? path
        basename( path ).match /(\d+)$/
        season_number = $1.to_i
        
        return season_number
      end
      return basename( path ) if season?( path )
    end while ( path = expand_path( File.join( path, '..' )) ) != '/'
    
    return false
  end

  # return an array of season directory paths given a tvshow directory
  def seasons(path)
    collect_items( path ) { |p| season?(p) }
  end

  # return an array of episode video file paths given a season directory
  def episodes(path)
    collect_items( path ) { |p| episode?(p) }
  end

  # given a path to an episode, return the path to the nfo file.
  def episode_nfo_path( episode_path )
    return false unless episode?( episode_path )
  
    episode_path.gsub /#{ extname(episode_path) }$/, Catshow::EPISODE_NFO_FILEEXTENSION
  end

  # given a path to a tvshow, return the path to its nfo file.
  def tvshow_nfo_path( tvshow_path )
    return false unless tvshow?( tvshow_path )
  
    File.join(tvshow_path, Catshow::TVSHOW_NFO_FILENAME)
  end
  
  # given a path to a movie, return the path to its nfo file.
  def movie_nfo_path( movie_path )
    return false unless movie_dir?( movie_path )
    
    File.join(movie_path, Catshow::MOVIE_NFO_FILENAME)
  end

  private

  # iterates over files in +path+ and collects the ones
  # which the block evaluates to true for.
  def collect_items(path, &block)
    Dir.open(path).collect do |f|
      nil if f.match /^\./
      join(path, f) if yield( join(path, f) )
    end.compact
  end
    
end
