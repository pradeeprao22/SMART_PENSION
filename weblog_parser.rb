require './lib/error'

class WeblogParser
  attr_reader :file_path, :visits

  def initialize(file_path)
    @file_path = file_exists?(file_path)
    @visits = {}
  end

  def webparse
    File.readlines(file_path).each do |line|
      url, ip_address = *line.split(' ')
      visits[url] ||= []
      visits[url] << ip_address
    end
  end

  def list_most_page_views
    print_views(page_views, 'visits')
  end

  def list_most_unique_views
    print_views(unique_views, 'unique views')
  end

  private

  def file_exists?(path)
    raise Error::FileNotFound.new('File does not exist') unless File.file?(path)

    path
  end

  def count_views(unique:)
    visits.each_with_object({}) do |(url, ip_addresses), views|
      views[url] = unique ? ip_addresses.uniq.count : ip_addresses.count
    end
  end

  def descending(hash)
    hash
      .sort_by(&:last)
      .reverse
      .inject([]) { |arr, v| arr << Hash[v[0], v[1]] }
  end

  def page_views
    descending(count_views(unique: false))
  end

  def unique_views
    descending(count_views(unique: true))
  end

  def print_views(logs, type)
    logs.each do |page|
      page.each { |url, count| puts "#{url} #{count} #{type}" }
    end
  end
end
