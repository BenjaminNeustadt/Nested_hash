require 'csv'

$INFO = false

  DEVICE_TYPE             = "Device_Type.name"
  MANUFACTURER            = "Device_Model.manufacturer_identifier"
  MODEL_HARDWARE_VERSION  = "Device_Model.model_identifier_concatenated_with_hardware_version"
  FIRMWARE_VERSION        = "Device_Model.firmware_version"
  SMETS_CHTS              = "SMETS_CHTS Version.Version_number_and_effective_date"
  GBCS_VERSION            = "GBCS Version.version_number" 
  IMAGE_HASH              = "Manufacturer_Image.hash"





class Row

  OUTER_HASH_VALUES =  {

    device_type:              "Device_Type.name",
    manufacturer:             "Device_Model.manufacturer_identifier",
    model_hardware_version:   "Device_Model.model_identifier_concatenated_with_hardware_version",

  }

  INNER_HASH_VALUES = {

    firmware_version:         "Device_Model.firmware_version",
    smets_chts_version:       "SMETS_CHTS Version.Version_number_and_effective_date",
    gbcs_version:             "GBCS Version.version_number",
    image_hash:               "Manufacturer_Image.hash"

  }

  def initialize(row)
    @row = row
  end

  attr_reader :row

  def device_type
    row[OUTER_HASH_VALUES[:device_type]]
  end

  def manufacturer
    row[OUTER_HASH_VALUES[:manufacturer]]
  end

  def model_hardware_version
    row[OUTER_HASH_VALUES[:model_hardware_version]]
  end

  # INNER HASH
  def firmware_version
    row[INNER_HASH_VALUES[:firmware_version]]
  end

  def smets_chts_version
    row[INNER_HASH_VALUES[:smets_chts_version]]
  end

  def gbcs_version
    row[INNER_HASH_VALUES[:gbcs_version]]
  end

  def image_hash
    row[INNER_HASH_VALUES[:image_hash]]
  end

end

def data_parse(csv_file)
  csv_table = CSV.parse(csv_file, headers: true)
  data = {}

  csv_table.by_row.each do |row|
    unless row["Entry.status"] == "Removed"

      row_object = Row.new(row)

    # HASH KEYS

    data[row_object.device_type] ||= {}

    data[row_object.device_type][row_object.manufacturer] ||= {}

    data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version] ||= {}

    if data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version].length > 0

      # Must transform the previous firmware hash into the new hash format
      data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version][row_object.firmware_version] ||= {
        data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version][:gbcs_version] => {
          smets_chts_version: data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version][:smets_chts_version],
          image_hash: data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version][:image_hash]
        }
      }
      # Then we take the current row and create the inner hash.
      inner_hash = {
        row_object.gbcs_version => {
          smets_chts_version: row_object.smets_chts_version,
          image_hash: row_object.image_hash
        }
      }
      # This will merge the previous and the current hash into the firmware_version hash so we end up with an array of hashes
      data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version][row_object.firmware_version].merge!(inner_hash)
      # Then we need to delete the previous keys that were saved on the first row since they are now nested under the key 'firmware_version'
      puts data if $INFO
      
      data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version].delete_if{|k,v| k.is_a?(Symbol)}
      
      puts data if $INFO

    else

      inner_hash = {
          firmware_version: row_object.firmware_version,                          
          smets_chts_version: row_object.smets_chts_version, 
          gbcs_version: row_object.gbcs_version,              
          image_hash: row_object.image_hash
      }

      data[row_object.device_type][row_object.manufacturer][row_object.model_hardware_version] = inner_hash

      end
    end
  end
  return data
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

   OUTER_HASH_VALUES = [
     {device_type: "Device_Type.name"},
     {manufacturer: "Device_Model.manufacturer_identifier" },
     {model_hardware_version: "Device_Model.model_identifier_concatenated_with_hardware_version"}
   ]

   # INNER HASH
   INNER_HASH_VALUES = [
     {firmware_version: "Device_Model.firmware_version"},
     {smets_chts_version: "SMETS_CHTS Version.Version_number_and_effective_date"},
     {gbcs_version: "GBCS Version.version_number"},
     {image_hash: "Manufacturer_Image.hash"}
   ]
       
def retrieve_data_values(row)
  OUTER_HASH_VALUES.each do |key, value|
    key = row[value]
  @firmware_version = row["Device_Model.firmware_version"]
  @smets_chts_version = row["SMETS_CHTS Version.Version_number_and_effective_date"]
  @gbcs_version = row["GBCS Version.version_number"]
  @image_hash = row["Manufacturer_Image.hash"]
  @device_type = row["Device_Type.name"]
  @manufacturer = row["Device_Model.manufacturer_identifier"]
  @model_hardware_version = row["Device_Model.model_identifier_concatenated_with_hardware_version"]
  end
end
=end