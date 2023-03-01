require 'csv'
def data_parse(csv_file)

  csv_table = CSV.parse(csv_file, headers: true)

  data = {}
  csv_table.by_row.each do |row|
    unless row["Entry.status"] == "Removed"
    device_type = row["Device_Type.name"]
    manufacturer = row["Device_Model.manufacturer_identifier"]
    model_hardware_version = row["Device_Model.model_identifier_concatenated_with_hardware_version"]

    # If the key is not already in use, we begin building the outermost key
    data[device_type] ||= {}
    data[device_type][manufacturer] = {}
    data[device_type][manufacturer][model_hardware_version] = {
            firmware_version: row["Device_Model.firmware_version"],                          # J (Device_Model.firmware_version)
            smets_chts_version: row["SMETS_CHTS Version.Version_number_and_effective_date"], # K (SMETS_CHTS Version.Version_number_and_effective_date)
            gbcs_version: row["GBCS Version.version_number"],                                # L (GBCS Version.version_number)
            image_hash: row["Manufacturer_Image.hash"]                                       # M (Manufacturer_Image.hash)
    }
    end
  end
  data
end

