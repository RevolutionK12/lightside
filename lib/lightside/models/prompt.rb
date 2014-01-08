module LightSide
  class Prompt
    include LightSide::Resources

    setup do
      self.resource_base        = "prompts"
      self.readonly_attributes  = %w( url owner parent corpora answer_sets created modified )
      self.writable_attributes  = %w( title text instructions description lower upper default_models alignments tags active )
    end

  end
end
