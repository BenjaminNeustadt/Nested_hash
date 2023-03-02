require 'csv'

$INFO = false

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

  def firmware_key_value_create_hash(data) 

## Must transform the previous firmware hash into the new hash format

    data[self.device_type][self.manufacturer][self.model_hardware_version][self.firmware_version] ||= {
      data[self.device_type][self.manufacturer][self.model_hardware_version][:gbcs_version] => {
        smets_chts_version: data[self.device_type][self.manufacturer][self.model_hardware_version][:smets_chts_version],
        image_hash: data[self.device_type][self.manufacturer][self.model_hardware_version][:image_hash]
      }
    }

## Then we take the current row and create the inner hash.
    inner_hash = {
      self.gbcs_version => {
        smets_chts_version: self.smets_chts_version,
        image_hash: self.image_hash
      }
    }

 ## This will merge the previous and the current hash into the firmware_version hash so we end up with an array of hashes
    data[self.device_type][self.manufacturer][self.model_hardware_version][self.firmware_version].merge!(inner_hash)
    
## Then we need to delete the previous keys that were saved on the first row since they are now nested under the key 'firmware_version'
    data[self.device_type][self.manufacturer][self.model_hardware_version].delete_if{|k,v| k.is_a?(Symbol)}

  end

  def innermost_standard(data)

    inner_hash = {
      firmware_version: self.firmware_version,                          
      smets_chts_version: self.smets_chts_version, 
      gbcs_version: self.gbcs_version,              
      image_hash: self.image_hash
    }

    data[self.device_type][self.manufacturer][self.model_hardware_version] = inner_hash

  end

end

def data_parse(csv_file)
  csv_table = CSV.parse(csv_file, headers: true)
  data = {}

  csv_table.by_row.each do |row|
    unless row["Entry.status"] == "Removed"

      row_object = Row.new(row)

  ## HASH KEYS if they dont exits, abstracted to the Row class, since we are iterating on a ROW
      row_object.device_type_key(data)
      row_object.manufacturer_key(data)
      row_object.model_hardware_version_key(data)

      if row_object.model_hardware_version_key(data).length > 0
  ## Must transform the previous firmware hash into the new hash format
         row_object.firmware_key_value_create_hash(data)

         #then you ccan chack with another conditional here
         # and return the same logic as above

  # puts data if $INFO
      else
         row_object.innermost_standard(data)
      end
    end
  end
## We use implicit return, I might prefer to put the explicit return, but the code is now cleaner so it's ok
  data
end
