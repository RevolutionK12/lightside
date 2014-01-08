module LightSide
  class TagAnswerSet
    include LightSide::Resources

    setup do
      self.resource_base        = "tags/answer_sets"
      self.readonly_attributes  = %w( name num_times )
      self.writable_attributes  = %w( )
    end

  end
end
