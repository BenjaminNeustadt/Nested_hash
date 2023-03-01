require_relative '../lib/data_parse.rb'


RSpec.describe '#data_parse' do

  let(:input_csv) do
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 1,1,Current,Type_Communications,Mfg_1,Model_1,1.0.0,AC,1.1.0,1.1.1,CHTS V1,GBCS Version 1,image1hash
    CSV
  end

  let(:input_csv_2) do
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 2,2,Current,Type_Meter,Mfg_2,Model_2,2.0.0,AC,2.2.0,2.2.2,CHTS V2,GBCS Version 2,image2hash
    CSV
  end

  let(:input_csv_3) do
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 3,3,Current,Type_Boiler,Mfg_3,Model_3,3.0.0,AC,3.3.0,3.3.3,CHTS V3,GBCS Version 3,image3hash
    CSV
  end
  #  A          B            C              D              E                                     F                                  G                                                      H                                     I                                                       J                  K                                                    L                              M
  # Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
  #  A          B   C            D            E    F   G H     I       J        K                L               M
  # Version 2.0,1,Current,Communications Hub,106C,4331,0,AC,433100AC,124074DA,"CHTS V1.0 ","GBCS Version 1.0 ",option2

  it 'parses a csv file with one row' do

    expected_output = {
      'Type_Communications' => {               # D (Device_Type.name)
        'Mfg_1' => {                           # E (Device_Model.manufacturer_identifier)
          '1.1.0' => {                       # I (Device_Model.model_identifier_concatenated_with_hardware_version)
            firmware_version: '1.1.1',         # J (Device_Model.firmware_version)
            smets_chts_version: 'CHTS V1',     # K (SMETS_CHTS Version.Version_number_and_effective_date)
            gbcs_version: 'GBCS Version 1',    # L (GBCS Version.version_number)
            image_hash: 'image1hash'           # M (Manufacturer_Image.hash)
          }
        }
      }
    }

    actual = data_parse(input_csv)
    expect(actual).to eq expected_output
  end

  it 'parses a different a csv file with one row' do

    expected = {
      'Type_Meter' => {
        'Mfg_2' => {
          '2.2.0' => {
            firmware_version: '2.2.2',
            smets_chts_version: 'CHTS V2',
            gbcs_version: 'GBCS Version 2',
            image_hash: 'image2hash'
          }
        }
      }
    }

    actual = data_parse(input_csv_2)
    expect(actual).to eq expected
  end

  it 'parses a different a csv file with one row' do

    expected = {
      'Type_Boiler' => {
        'Mfg_3' => {
          '3.3.0' => {
            firmware_version: '3.3.3',
            smets_chts_version: 'CHTS V3',
            gbcs_version: 'GBCS Version 3',
            image_hash: 'image3hash'
          }
        }
      }
    }

    actual = data_parse(input_csv_3)
    expect(actual).to eq expected
  end

  it 'parses two rows that have different keys' do

    input_csv =
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 1,1,Current,Type_Communications,Mfg_1,Model_1,1.0.0,AC,1.1.0,1.1.1,CHTS V1,GBCS Version 1,image1hash
      Version 2,2,Current,Type_Meter,Mfg_2,Model_2,2.0.0,AC,2.2.0,2.2.2,CHTS V2,GBCS Version 2,image2hash
    CSV

    expected = {
      'Type_Communications' => {            # D (Device_Type.name)
        'Mfg_1' => {                        # E (Device_Model.manufacturer_identifier)
          '1.1.0' => {                      # I (Device_Model.model_identifier_concatenated_with_hardware_version)
            firmware_version: '1.1.1',      # J (Device_Model.firmware_version)
            smets_chts_version: 'CHTS V1',  # K (SMETS_CHTS Version.Version_number_and_effective_date)
            gbcs_version: 'GBCS Version 1', # L (GBCS Version.version_number)
            image_hash: 'image1hash'        # M (Manufacturer_Image.hash)
          }
        }
      },
      'Type_Meter' => {                     # D (Device_Type.name)
        'Mfg_2' => {                        # E (Device_Model.manufacturer_identifier)
          '2.2.0' => {                      # I (Device_Model.model_identifier_concatenated_with_hardware_version)
            firmware_version: '2.2.2',      # J (Device_Model.firmware_version)
            smets_chts_version: 'CHTS V2',  # K (SMETS_CHTS Version.Version_number_and_effective_date)
            gbcs_version: 'GBCS Version 2', # L (GBCS Version.version_number)
            image_hash: 'image2hash'        # M (Manufacturer_Image.hash)
          }
        }
      },
    }

    actual = data_parse(input_csv)
    expect(actual).to eq expected
  end

  # I think at this stage it is useful to test with real data
  it 'parses three rows: two model test, one real data row' do

    input_csv =
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
      Version 1,1,Current,Type_Communications,Mfg_1,Model_1,1.0.0,AC,1.1.0,1.1.1,CHTS V1,GBCS Version 1,image1hash
      Version 2,2,Current,Type_Meter,Mfg_2,Model_2,2.0.0,AC,2.2.0,2.2.2,CHTS V2,GBCS Version 2,image2hash
      Version 2.051 Issued on 21-09-2022,1,Current,Communications Hub,106C,4331,0,AC,433100AC,124074DA,"CHTS V1.0 ","GBCS Version 1.0 ",137ED5BC81A21F6D2187BC380381AEA7705BF65D3E4DAEA28EFD44113079D5E9
    CSV

    expected = {
       'Type_Communications' => {            # D (Device_Type.name)
         'Mfg_1' => {                        # E (Device_Model.manufacturer_identifier)
           '1.1.0' => {                      # I (Device_Model.model_identifier_concatenated_with_hardware_version)
             firmware_version: '1.1.1',      # J (Device_Model.firmware_version)
             smets_chts_version: 'CHTS V1',  # K (SMETS_CHTS Version.Version_number_and_effective_date)
             gbcs_version: 'GBCS Version 1', # L (GBCS Version.version_number)
             image_hash: 'image1hash'        # M (Manufacturer_Image.hash)
           }
         }
       },
       'Type_Meter' => {                     # D (Device_Type.name)
         'Mfg_2' => {                        # E (Device_Model.manufacturer_identifier)
           '2.2.0' => {                      # I (Device_Model.model_identifier_concatenated_with_hardware_version)
             firmware_version: '2.2.2',      # J (Device_Model.firmware_version)
             smets_chts_version: 'CHTS V2',  # K (SMETS_CHTS Version.Version_number_and_effective_date)
             gbcs_version: 'GBCS Version 2', # L (GBCS Version.version_number)
             image_hash: 'image2hash'        # M (Manufacturer_Image.hash)
           }
         }
       },
      'Communications Hub' => {
        '106C' => {
          '433100AC' => {
            firmware_version: '124074DA',
            smets_chts_version: 'CHTS V1.0 ',
            gbcs_version: 'GBCS Version 1.0 ',
            image_hash: '137ED5BC81A21F6D2187BC380381AEA7705BF65D3E4DAEA28EFD44113079D5E9'
          }
        }
      }
    }

    actual = data_parse(input_csv)
    expect(actual).to eq expected
  end

end

