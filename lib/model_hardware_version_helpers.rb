module ModelHardwareVersionHelpers

  private

  # predicate helper methods
  def _model_hardware_version
    data[device_type][manufacturer][model_hardware_version]
  end

  def model_hardware_version_value_is_collection_on?
    _model_hardware_version.is_a?(Array)
  end

  def assign_model_hardware_version_on
    data[device_type][manufacturer][model_hardware_version] = [_model_hardware_version, inner_hash]
  end

end

