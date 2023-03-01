require 'csv'
def data_parse(string_input)

  csv_table = CSV.parse(string_input, headers: true)

  data = {}
  csv_table.by_row.each do |row|

    specific_row = {
      row["Device_Type.name"] => {
        row["Device_Model.manufacturer_identifier"] => {
          row["Device_Model.model_identifier_concatenated_with_hardware_version"] => {
            firmware_version: row["Device_Model.firmware_version"],                          # J (Device_Model.firmware_version)
            smets_chts_version: row["SMETS_CHTS Version.Version_number_and_effective_date"], # K (SMETS_CHTS Version.Version_number_and_effective_date)
            gbcs_version: row["GBCS Version.version_number"],                                # L (GBCS Version.version_number)
            image_hash: row["Manufacturer_Image.hash"]                                       # M (Manufacturer_Image.hash)
          }
        }
      }
    }

    data.merge!(specific_row)
  end
  data
end
