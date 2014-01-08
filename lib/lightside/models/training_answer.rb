module LightSide
  class TrainingAnswer
    include LightSide::Resources

    setup do
      self.resource_base        = "training-answers"
      self.readonly_attributes  = %w( url created modified )
      self.writable_attributes  = %w( corpus text )
    end

  end
end
