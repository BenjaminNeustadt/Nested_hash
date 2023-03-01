require_relative '../lib/data_parse.rb'


RSpec.describe '#data_parse' do

  let(:input_csv) do
    <<~CSV
      Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
		  Version 2.01 Issued 09-2022,Current,Type_Communications,Manufacturer_1,Model_1,1.0.0,1.0.0,1.0.0,image1hash
    CSV
  end
  #  A          B            C              D              E                                     F                                  G                                                      H                                     I                                                       J                  K                                                    L                              M
  # Version,Entry.number,Entry.status,Device_Type.name,Device_Model.manufacturer_identifier,Device_Model.model_identifier,Device_Model.hardware_version.version,Device_Model.hardware_version.revision,Device_Model.model_identifier_concatenated_with_hardware_version,Device_Model.firmware_version,SMETS_CHTS Version.Version_number_and_effective_date,GBCS Version.version_number,Manufacturer_Image.hash
  #  A                                 B    C          D             E    F   G H     I       J        K                L               M
  # Version 2.051 Issued on 21-09-2022,1,Current,Communications Hub,106C,4331,0,AC,433100AC,124074DA,"CHTS V1.0 ","GBCS Version 1.0 ",option2

  it 'parses a csv file with one row' do

    expected_output = {
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

    actual = data_parse(input_csv)
    expect(actual).to eq expected_output
  end

end
