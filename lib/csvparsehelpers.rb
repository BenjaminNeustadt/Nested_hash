require 'roo'

module CSVParseHelpers
  # This method makes use of 'roo' Gem to handle the xlsm file

  def standardize_csv(csv_or_xlsm_file)
    File.extname(csv_or_xlsm_file) == '.xlsm' and
     parse_xlsm(csv_or_xlsm_file) or
     csv_or_xlsm_file
  end

  # WIth the following method we can add the possibility of using an xlsm file,
  # if it is, the return will be the call to parse_xlsm(file_in_question),
  # else it just returns the file
  def parse_xlsm(xlsm_file)
    workbook = Roo::Spreadsheet.open(xlsm_file)
    workbook.sheet(workbook.sheets.last).to_csv
  end

end