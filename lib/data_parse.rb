def data_parse(csv_file)

  option_1 =
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 2,1,Current,Type_Communications,Mfg_1,Model_1,1.0,AC,1.0,1.0,CHTS V1,GBCS Version 1,image1hash
    CSV

  option_2 =
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 2,2,Current,Type_Meter,Mfg_2,Model_2,2.0,AC,2.0,2.0,CHTS V2,GBCS Version 2,image2hash
    CSV

  if csv_file == option_1

   {
     'Type_Communications' => {               # D (Device_Type.name)
       'Mfg_1' => {                           # E (Device_Model.manufacturer_identifier)
         'Model_1' => {                       # I (Device_Model.model_identifier_concatenated_with_hardware_version)
           firmware_version: '1.0',         # J (Device_Model.firmware_version)
           smets_chts_version: 'CHTS V1',       # K (SMETS_CHTS Version.Version_number_and_effective_date)
           gbcs_version: 'GBCS Version 1',             # L (GBCS Version.version_number)
           image_hash: 'image1hash'           # M (Manufacturer_Image.hash)
         }
       }
     }
   }
  else

    {
      'Type_Meter' => {
        'Mfg_2' => {
          'Model_2' => {
            firmware_version: '2.0',
            smets_chts_version: 'CHTS V2',
            gbcs_version: 'GBCS Version 2',
            image_hash: 'image2hash'
          }
        }
      }
    }

  end

end
