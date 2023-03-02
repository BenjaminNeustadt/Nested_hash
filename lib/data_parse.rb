require 'csv'

$INFO = true

module CSVHeaders 

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

end

class Row
  include CSVHeaders

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

## Creating hashes if they dont exist
  def device_type_key(data)
    data[self.device_type] ||= {}
  end

  def manufacturer_key(data)
    data[self.device_type][self.manufacturer] ||= {}
  end

  def model_hardware_version_key(data)
    data[self.device_type][self.manufacturer][self.model_hardware_version] ||= {}
  end

  def inner_hash

    inner_hash = {
      firmware_version: self.firmware_version,                          
      smets_chts_version: self.smets_chts_version, 
      gbcs_version: self.gbcs_version,              
      image_hash: self.image_hash
    }

  end

  def build_array_for_inner_hashes(data) 
##  We check if the value is already an array and append to it if so.

    if data[self.device_type][self.manufacturer][self.model_hardware_version].is_a?(Array)
      data[self.device_type][self.manufacturer][self.model_hardware_version] << inner_hash
    else
##      # otherwise we create a new hash
      data[self.device_type][self.manufacturer][self.model_hardware_version] = [data[self.device_type][self.manufacturer][self.model_hardware_version], inner_hash]
    end

  end

  def innermost_standard(data)

    data[self.device_type][self.manufacturer][self.model_hardware_version] = inner_hash

  end

  def create_hash_structures(data)
      self.device_type_key(data)
      self.manufacturer_key(data)
      self.model_hardware_version_key(data)
  end

end

def data_parse(csv_file)
  csv_table = CSV.parse(csv_file, headers: true)
  data = {}

  csv_table.by_row.each do |row|
    unless row["Entry.status"] == "Removed"

      row_object = Row.new(row)

## HASH KEYS if they dont exits, abstracted to the Row class, since we are iterating on a ROW
      row_object.create_hash_structures(data)
      
      if row_object.model_hardware_version_key(data).length > 0

         row_object.build_array_for_inner_hashes(data)

      else
         row_object.innermost_standard(data)
      end
    end
  end
  data
end
