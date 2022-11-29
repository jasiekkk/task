# frozen_string_literal: true

require_relative 'lib/log_parser'

parsed_log = LogParser.new(ARGV[0])

puts 'Pages ordered by most views:'
puts parsed_log.output_pages_ordered_by_most_views
puts "\n"
puts 'Pages ordered by most unique views:'
puts parsed_log.output_pages_ordered_by_most_unique_views
