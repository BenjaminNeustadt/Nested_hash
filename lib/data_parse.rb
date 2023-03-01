require 'csv'
def data_parse(string_input)

  csv_table = CSV.parse(string_input, headers: true)
  row_1 = csv_table[0]


  {
    row_1["Device_Type.name"] => {
    row_1["Device_Model.manufacturer_identifier"] => {
    row_1["Device_Model.model_identifier_concatenated_with_hardware_version"] => {
           firmware_version: row_1["Device_Model.firmware_version"], # J (Device_Model.firmware_version)
           smets_chts_version: row_1["SMETS_CHTS Version.Version_number_and_effective_date"],     # K (SMETS_CHTS Version.Version_number_and_effective_date)
           gbcs_version: row_1["GBCS Version.version_number"],    # L (GBCS Version.version_number)
           image_hash: row_1["Manufacturer_Image.hash"]         # M (Manufacturer_Image.hash)
         }
       }
     }
   }

end
