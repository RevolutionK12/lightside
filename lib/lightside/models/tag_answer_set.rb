module LightSide
  class TagPrompt
    include LightSide::Resources

    setup do
      self.resource_base        = "tags/prompts"
      self.readonly_attributes  = %w( name num_times )
      self.writable_attributes  = %w( )
    end

  end
end
