require_relative './csvheaders.rb'
class Row
  include CSVHeaders

  def initialize(row)
    @row = row
  end

  attr_reader :row

## Creating hashes if they dont exist
  def device_type_key(data)
    data[device_type] ||= {}
  end

  def manufacturer_key(data)
    data[device_type][manufacturer] ||= {}
  end

  def model_hardware_version_key(data)
    data[device_type][manufacturer][model_hardware_version] ||= {}
  end

  def inner_hash

    inner_hash = {
      firmware_version: firmware_version,
      smets_chts_version: smets_chts_version,
      gbcs_version: gbcs_version,
      image_hash: image_hash
    }

  end

  def _model_hardware_version(data)
    data[device_type][manufacturer][model_hardware_version]
  end

  def item_is_collection?(data)
    _model_hardware_version(data).is_a?(Array)
  end

  # def item
  #   data[self.device_type][self.manufacturer][self.model_hardware_version]
  # end

  def item_is_collection?(data)
    data[device_type][manufacturer][model_hardware_version].is_a?(Array)
  end

  def build_array_for_inner_hashes(data)

    item = data[device_type][manufacturer][model_hardware_version]
##  We check if the value is already an array and append to it if so.
    if item_is_collection?(data) 
      item << inner_hash
    else
##  Otherwise we create a new hash
      data[device_type][manufacturer][model_hardware_version] = [item, inner_hash]
    end

  end

  def innermost_standard(data)

    data[device_type][manufacturer][model_hardware_version] = inner_hash

  end

  def create_hash_structures(data)
      device_type_key(data)
      manufacturer_key(data)
      model_hardware_version_key(data)
  end

end
