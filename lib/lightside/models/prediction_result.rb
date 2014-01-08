module LightSide
  class PredictionResult
    include LightSide::Resources

    setup do
      self.resource_base        = "prediction-results"
      self.readonly_attributes  = %w( url answer prediction_task trained_model distribution label possible_labels created modified )
      self.writable_attributes  = %w( )
    end

  end
end
