module LightSide
  class ResolvedScore
    include LightSide::Resources

    setup do
      self.resource_base        = "resolved-scores"
      self.readonly_attributes  = %w( url created modified )
      self.writable_attributes  = %w( training_answer label )
    end

  end
end
