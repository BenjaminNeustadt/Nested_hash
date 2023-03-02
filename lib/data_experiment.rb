



module Headers

Headers = {
  device_type:              "Device_Type.name",
  manufacturer:             "Device_Model.manufacturer_identifier",
  model_hardware_version:   "Device_Model.model_identifier_concatenated_with_hardware_version",
  firmware_version:         "Device_Model.firmware_version",
  smets_chts_version:       "SMETS_CHTS Version.Version_number_and_effective_date",
  gbcs_version:             "GBCS Version.version_number",
  image_hash:               "Manufacturer_Image.hash"
}

end

class Transform
  include Headers

  attr_reader :data

  def initialize (csv_table)
    @table = csv_table
    @data = {}
    @headers = extract_headers
  end

  attr_reader :table
  def extract_header
    table.headers
    # table.by_row.each do |row|
    # unless row["Entry.status"] == "Removed"

    # # OUTER HASH
    # @device_type            = row[Headers[:device_type]]
    # @manufacturer           = row[Headers[:manufacturer]]
    # @model_hardware_version = row[Headers[:model_hardware_version]]

    # # INNER HASH
    # @firmware_version       = row[Headers[:firmware_version]]
    # @smets_chts_version     = row[Headers[:smets_chts_version]]
    # @gbcs_version           = row[Headers[:gbcs_version]]
    # @image_hash             = row[Headers[:image_hash]]
    # end

  end

 first_key =  data[device_type][manufacturer]

      firmware_key ||= {
        gbcs_version_key => {
          smets_key => {
         image_hash:
          }
        }
      }
  # def outer_keys
  # end

  # def rows
  # end

  # def defining_methods
  # end

end


class Row

end