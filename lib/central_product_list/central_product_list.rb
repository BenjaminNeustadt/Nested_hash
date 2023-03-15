require 'csv'
require 'row'
require 'csvparsehelpers'

class CentralProductList
  include CSVParseHelpers

  def initialize(csv_or_xlsm_file)
    @csv_file = standardize_csv(csv_or_xlsm_file)
    @csv_table = CSV.parse(@csv_file, headers: true)
    @accumulated_result = {}
  end
  
  attr_reader :csv_table, :accumulated_result


  def model_hardware_exists?(object)
    object.model_hardware_version_key.length.positive?
  end

  def data_parse
    csv_table.by_row.each do |r|
      unless r['Entry.status'] == 'Removed'
        row = Row.new(r, accumulated_result)
        ## Creates the hash structure if it does not already exist
        row.create_hash_structures
        if model_hardware_exists?(row)
          ## Build an array with the key of the existant inner hash as a key for
          #  the array containing as many inner_hashes as necessary
          row.build_array_for_inner_hashes
        else
          ## Otherwise just give the standard inner hash as a single value
          #  belonging to key
          row.innermost_standard
        end
      end
    end
    accumulated_result
  end

end