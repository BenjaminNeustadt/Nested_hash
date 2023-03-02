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
