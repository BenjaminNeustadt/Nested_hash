module ModelHardwareVersionHelpers

  private

  # predicate helper methods
  def _model_hardware_version(data)
    data[device_type][manufacturer][model_hardware_version]
  end

  def model_hardware_version_value_is_collection_on?(data)
    _model_hardware_version(data).is_a?(Array)
  end

  def assign_model_hardware_version_on(data)
    data[device_type][manufacturer][model_hardware_version] = [_model_hardware_version(data), inner_hash]
  end

end

