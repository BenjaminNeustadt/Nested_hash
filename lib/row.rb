require_relative './csvheaders.rb'
class Row
  include CSVHeaders

  private

  attr_reader :row

  def initialize(row)
    @row = row
  end

## Creating hashes if they dont exist
  def device_type_key(data)
    data[device_type] ||= {}
  end

  def manufacturer_key(data)
    data[device_type][manufacturer] ||= {}
  end

  def inner_hash
    {
      firmware_version: firmware_version,
      smets_chts_version: smets_chts_version,
      gbcs_version: gbcs_version,
      image_hash: image_hash
    }
  end

  # predicate helper methods
  def _model_hardware_version(data)
    data[device_type][manufacturer][model_hardware_version]
  end

  def model_hardware_version_value_is_collection_on?(data)
    _model_hardware_version(data).is_a?(Array)
  end

  def assign_model_hardware_version_on(data)
    data[device_type][manufacturer][model_hardware_version] = [_model_hardware_version(data), inner_hash]
  end

  public

  def model_hardware_version_key(data)
    data[device_type][manufacturer][model_hardware_version] ||= {}
  end

  def build_array_for_inner_hashes(data)
    ##  We check if the value is already an array and append to it if so.
    if model_hardware_version_value_is_collection_on?(data)
      _model_hardware_version(data) << inner_hash
    else
      ##  Otherwise we create a new hash
      assign_model_hardware_version_on(data)
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
