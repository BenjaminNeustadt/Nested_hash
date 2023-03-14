require_relative './csvheaders.rb'
require_relative './model_hardware_version_helpers'
require_relative './hash_creation_helpers'

class Row
  include CSVHeaders
  include ModelHardwareVersionHelpers
  include HashCreationHelpers

  private

  attr_reader :row, :data

  def initialize(row, data)
    @row = row
    @data = data
  end

  public

  def build_array_for_inner_hashes
    ##  We check if the value is already an array and append to it if so.
    if model_hardware_version_value_is_collection_on?
      _model_hardware_version << inner_hash
    else
      ##  Otherwise we create a new hash
      assign_model_hardware_version_on
    end
  end

  def innermost_standard
    data[device_type][manufacturer][model_hardware_version] = inner_hash
  end

end
