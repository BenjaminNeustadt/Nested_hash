module ModelHardwareVersionHelpers

  private

  # predicate helper methods
  def model_hardware_version_value
    data[device_type][manufacturer][model_hardware_version]
  end

  def model_hardware_version_value_is_collection?
    model_hardware_version_value.is_a?(Array)
  end

  def assign_model_hardware_version_collection
    data[device_type][manufacturer][model_hardware_version] = [model_hardware_version_value, inner_hash]
  end

end

