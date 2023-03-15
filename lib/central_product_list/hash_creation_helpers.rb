module HashCreationHelpers

  private

  ## Creating hashes if they dont exist
  def device_type_key
    data[device_type] ||= {}
  end

  def manufacturer_key
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

  def model_hardware_version_key
    data[device_type][manufacturer][model_hardware_version] ||= {}
  end

  def create_hash_structures
    device_type_key
    manufacturer_key
    model_hardware_version_key
  end

end
