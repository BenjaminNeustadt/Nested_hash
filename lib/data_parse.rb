def data_parse(csv_file)
  {
    'Type_Communications' => {               # D (Device_Type.name)
      'Manufacturer_1' => {                  # E (Device_Model.manufacturer_identifier)
        'Model_1' => {                       # I (Device_Model.model_identifier_concatenated_with_hardware_version)
          firmware_version: '1.0.0',         # J (Device_Model.firmware_version)
          smets_chts_version: '1.0.0',       # K (SMETS_CHTS Version.Version_number_and_effective_date)
          gbcs_version: '1.0.0',             # L (GBCS Version.version_number)
          image_hash: 'image1hash'           # M (Manufacturer_Image.hash)
        }
      }
    }
  }
end
