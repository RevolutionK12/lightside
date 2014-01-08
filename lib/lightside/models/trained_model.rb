module LightSide
  class TrainedModel
    include LightSide::Resources

    setup do
      self.resource_base        = "trained-models"
      self.readonly_attributes  = %w( url corpus learner feature_set creation_method recipe_file active created modified )
      self.writable_attributes  = %w( name evaluations predictions )
    end

  end
end
