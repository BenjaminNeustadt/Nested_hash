require 'csv'

def data_parse(csv_file)

  csv_table = CSV.parse(csv_file, headers: true)
  data = {}

  csv_table.by_row.each do |row|

    unless row["Entry.status"] == "Removed"

      device_type = row["Device_Type.name"]
      manufacturer = row["Device_Model.manufacturer_identifier"]
      model_hardware_version = row["Device_Model.model_identifier_concatenated_with_hardware_version"]
      # INNER HASH
      firmware_version = row["Device_Model.firmware_version"]
      smets_chts_version = row["SMETS_CHTS Version.Version_number_and_effective_date"]
      gbcs_version = row["GBCS Version.version_number"]
      image_hash = row["Manufacturer_Image.hash"]
      data[device_type] ||= {}
      data[device_type][manufacturer] ||= {}
      #unless data[device_type][manufacturer][model_hardware_version]

      data[device_type][manufacturer][model_hardware_version] ||= {}
      if data[device_type][manufacturer][model_hardware_version].length > 0
        # Must transform the previous firmware hash into the new hash format
        previous_hash = {
          data[device_type][manufacturer][model_hardware_version][:gbcs_version] => {
            smets_chts_version: data[device_type][manufacturer][model_hardware_version][:smets_chts_version],
            image_hash: data[device_type][manufacturer][model_hardware_version][:image_hash]
          }
        }
        # Then we take the current row and create the inner hash.
        inner_hash = {
          gbcs_version => {
            smets_chts_version: smets_chts_version,
            image_hash: image_hash
          }
        }
        # This will merge the previous and the current hash so we end up with an array of hashes
        data[device_type][manufacturer][model_hardware_version]["firmware_version"] ||= previous_hash.merge(inner_hash)
        # Then we need to delete the previous keys that were saved on the first row since they are now nested under the key 'firmware_version'
        data[device_type][manufacturer][model_hardware_version].delete_if{|k,v| k != "firmware_version"}
        puts data
      else
        inner_hash = {
            firmware_version: firmware_version,                          
            smets_chts_version: smets_chts_version, 
            gbcs_version: gbcs_version,              
            image_hash: image_hash
          }
        data[device_type][manufacturer][model_hardware_version] = inner_hash
      end
    end
  end
  data
end

=begin

_END_
==NOTES
    data[device_type][manufacturer][model_hardware_version] ||= {}

    inner_hash = 
    {
            firmware_version: row["Device_Model.firmware_version"],                          # J (Device_Model.firmware_version)
            smets_chts_version: row["SMETS_CHTS Version.Version_number_and_effective_date"], # K (SMETS_CHTS Version.Version_number_and_effective_date)
            gbcs_version: row["GBCS Version.version_number"],                                # L (GBCS Version.version_number)
            image_hash: row["Manufacturer_Image.hash"]                                       # M (Manufacturer_Image.hash)
    }
=end