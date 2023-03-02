#!/usr/bin/env ruby
# frozen_string_literal: false

require_relative '../lib/data_parse.rb'
require 'colorize'


def process

  puts "Data is  successcullfy transformed into Hash".cyan

end

def hashify_csv(csv_file)
  file = File.new(csv_file, 'r')

  File.open('can_write_data.rb', 'w') do |f|
    result = data_parse(file)
    f.puts "#{result}"
  end

  process

rescue Errno::ENOENT => e
  puts "An error occured - check your file exists and its location.".red
  exit(1)
end

document = 'Ctral-Products-Lis.csv'

hashify_csv(document)