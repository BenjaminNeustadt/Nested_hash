require_relative './csvheaders.rb'
class Row
  include CSVHeaders

  def initialize(row)
    @row = row
  end

  attr_reader :row

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
##  Otherwise we create a new hash
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
