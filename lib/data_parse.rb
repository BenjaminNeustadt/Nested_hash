require 'csv'
require_relative './row'

def model_hardware_exists?(object, data)
  object.model_hardware_version_key(data).length.positive?
end

## The functionality of what a Row has has been abstracted to Row class
def data_parse(csv_file)
  csv_table = CSV.parse(csv_file, headers: true)
  data = {}

  csv_table.by_row.each do |r|
    unless r['Entry.status'] == 'Removed'

      row = Row.new(r)

      ## Creates the hash structure if it does not already exist
      row.create_hash_structures(data)


      if model_hardware_exists?(row, data)

        ## Build an array with the key of the existant inner hash as a key for
        #  the array containing as many inner_hashes as necessary
        row.build_array_for_inner_hashes(data)

      else
        ## Otherwise just give the standard inner hash as a single value
        #  belonging to key
        row.innermost_standard(data)

      end
    end
  end
  data
end
