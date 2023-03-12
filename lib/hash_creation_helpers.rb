module HashCreationHelpers

  private

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

  public

  def model_hardware_version_key(data)
    data[device_type][manufacturer][model_hardware_version] ||= {}
  end

  def create_hash_structures(data)
    device_type_key(data)
    manufacturer_key(data)
    model_hardware_version_key(data)
  end

end
