module LightSide
  class HumanScore
    include LightSide::Resources

    setup do
      self.resource_base        = "human-scores"
      self.readonly_attributes  = %w( url created modified )
      self.writable_attributes  = %w( training_answer label )
    end

  end
end
