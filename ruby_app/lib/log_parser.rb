# frozen_string_literal: true

class LogParser
  def initialize(file_path)
    raise 'File does not exist' unless File.exist?(file_path)

    @file = File.read(file_path)
  end

  def output_pages_ordered_by_most_views
    format_output(pages_ordered_by_most_views)
  end

  def output_pages_ordered_by_most_unique_views
    format_output(pages_ordered_by_most_unique_views)
  end

  private

  def log_entries
    @file.split("\n")
  end

  def parsed_log_entries
    @parsed_log_entries ||=
      log_entries.each_with_object(Hash.new { |h, k| h[k] = [] }) do |entry, h|
        page, ip = entry.split(' ')
        h[page] << ip
      end
  end

  def page_views
    count_page_views(unique: false)
  end

  def unique_page_views
    count_page_views(unique: true)
  end

  def count_page_views(unique:)
    parsed_log_entries.transform_values do |viewing_ips|
      unique ? viewing_ips.uniq.size : viewing_ips.size
    end
  end

  def pages_ordered_by_most_views
    order_by_most_views(page_views)
  end

  def pages_ordered_by_most_unique_views
    order_by_most_views(unique_page_views)
  end

  def order_by_most_views(views)
    views.sort_by { |_page, viewing_ip_count| viewing_ip_count }.reverse.to_h
  end

  def format_output(ordered_pages)
    ordered_pages.map do |page, view_count|
      "Page: #{page} Views: #{view_count}"
    end.join("\n")
  end
end
