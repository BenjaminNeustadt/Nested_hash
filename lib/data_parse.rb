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

  option_3 =
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 3,3,Current,Type_Boiler,Mfg_3,Model_3,3.0,AC,3.0,3.0,CHTS V3,GBCS Version 3,image3hash
    CSV

  if csv_file == option_1

   {
     'Type_Communications' => {               # D (Device_Type.name)
       'Mfg_1' => {                           # E (Device_Model.manufacturer_identifier)
         'Model_1' => {                       # I (Device_Model.model_identifier_concatenated_with_hardware_version)
           firmware_version: '1.0',           # J (Device_Model.firmware_version)
           smets_chts_version: 'CHTS V1',     # K (SMETS_CHTS Version.Version_number_and_effective_date)
           gbcs_version: 'GBCS Version 1',    # L (GBCS Version.version_number)
           image_hash: 'image1hash'           # M (Manufacturer_Image.hash)
         }
       }
     }
   }
   elsif csv_file == option_2

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
   elsif csv_file == option_3

    {
      'Type_Boiler' => {
        'Mfg_3' => {
          'Model_3' => {
            firmware_version: '3.0',
            smets_chts_version: 'CHTS V3',
            gbcs_version: 'GBCS Version 3',
            image_hash: 'image3hash'
          }
        }
      }
    }

   end
end