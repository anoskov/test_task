require 'optparse'
require './data_scraper'
require 'pp'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Learning Option parsing in Ruby"

  opts.on("-d", "--data DATA", "Data file with serial numbers of devices") do |data|
    options[:data] = data
  end

  opts.on("-s", "--serial_number SN", "Device serial number") do |sn|
    options[:sn] = sn
  end

  opts.on("--from FROM", "From a direct link, or the result of check form") do |from|
    options[:from] = from
  end
end
optparse.parse!

def run_scraper(opts)
  if opts[:data]
    begin
      f = File.open(opts[:data])
    rescue Errno::ENOENT => msg
      puts msg
      exit 0;
    end
    result = f.map { |sn| DataScraper.new(sn.strip, opts[:from]).scrape.to_h }      
  else
    result = DataScraper.new(opts[:sn], opts[:from]).scrape.to_h
  end
  File.open('scrape_result.json', 'w+') { |file| file.write result.to_json }
end

run_scraper(options)