module LightSide
  class TrainedModelEvaluation
    include LightSide::Resources

    setup do
      self.resource_base        = "trained-model-evaluations"
      self.readonly_attributes  = %w( url trained_model accuracy entropy kappa weighted_kappa label created modified )
      self.writable_attributes  = %w( )
    end

  end
end
