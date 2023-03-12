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
