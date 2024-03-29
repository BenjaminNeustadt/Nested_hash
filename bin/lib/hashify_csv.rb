
def hashify_csv(csv_file, destination)
  file = File.new(csv_file, 'r')

  File.open(destination, 'w') do |f|

    f.puts CentralProductList.new(file).data_parse

  end
rescue Errno::ENOENT => e
  STDERR.puts 'An error occured - check your file exists and its location.'.red
  exit(1)
end
