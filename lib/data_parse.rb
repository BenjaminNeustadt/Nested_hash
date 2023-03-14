require 'csv'
require_relative './row'

class CentralProductList
## The functionality of what a Row has has been abstracted to Row class

  def initialize(csv_or_xlsm_file)
    @csv_file = standardize_csv(csv_or_xlsm_file)
    @csv_table = CSV.parse(@csv_file, headers: true)
    @accumulated_result = {}
  end
  
  attr_reader :csv_table, :accumulated_result

  # WIth the following method we can add the possibility of using an xlsm file,
  # if it is, the return will be the call to parse_xlsm(file_in_question),
  # else it just returns the file

  def standardize_csv(csv_or_xlsm_file)
    File.extname(csv_or_xlsm_file) == '.xlsm' and
     parse_xlsm(csv_or_xlsm_file) or
     csv_or_xlsm_file
  end

  # This method makes use of 'roo' Gem to handle the xlsm file

  def parse_xlsm(xlsm_file)
    workbook = Roo::Spreadhseet.open(xlsm_file)
    workbook.sheet(workbook.sheets.last).to_csv
  end

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