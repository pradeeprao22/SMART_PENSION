require 'weblog_parser'

raise RuntimeError('File Missing') if ARGV[0].nil?

parser = WeblogParser.new(ARGV[0])
parser.webparse

puts 'Webpages with most views'
parser.list_most_page_views

puts

puts 'Webpages with most unique views'
parser.list_most_unique_views

