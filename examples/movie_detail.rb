#! /usr/bin/ruby

$:.push File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'catshow-file'
require 'pp'

movie_dir = '/Volumes/Drobo/couchpotato'

data = {}

# report on:
# number of films
# most common year
# most common rating
# most common genre

# year to decade
def y2d(y)
	return 0 if y.to_i == 0
	y.to_i - y.to_s.scan(/./).last.to_i
end

def tally(data)
  data.reduce({}) { |m, y| m[y] ||= 0; m[y] += 1; m }
end

def histogram(data)
  longest_title = 0
  data.keys.each do |k|
    longest_title = k.length if k.length > longest_title
  end
  
  max = 0
  max_item = nil
  total = 0
  
  data.keys.sort.each do |k|
    next if k.nil? || k.length == 0 || k == ''

    if data[k] > max
      max = data[k]
      max_item = k
    end
    
    total += data[k]
    
    puts "#{k.ljust(longest_title + 2)} #{ '#' * data[k] }"
  end
  
  puts "Max: #{ max_item } -- #{ max }/#{ total } (#{ sprintf('%.01f', max.to_f / total.to_f * 100) }%)"
  puts "==============================================="
end

%w( ratings years decades genres ).each do |category|
	data[category.to_sym] = []
end

data[:skipped] = 0

Dir.new(movie_dir).collect do |movie|
  next if movie.match /^\./
  
  movie_path = File.join(movie_dir, movie)
  unless File.movie_dir?( movie_path)
    data[:skipped] += 1
    next
  end
  
  puts "reading #{ movie }"
  
  begin
    info = File::Nfo.for_movie( movie_path )
  rescue
    next
  end
  
  movie.match /\((\d+?)\)$/
  year = $1
  decade = y2d(year)
  
  data[:years] << year
  data[:decades] << "#{ decade }s"
  data[:ratings] << info[:rating].gsub(/^Rated\s*/, '')
  
  info[:genres].each { |g| data[:genres] << g }
end

puts "----------------------------------------------------------------------------"
puts "Skipped: #{ data[:skipped] }"

[ :years, :decades, :ratings, :genres ].each do |d|
  histogram(tally(data[d]))
end

