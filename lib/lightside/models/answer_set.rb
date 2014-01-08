module LightSide
  class AnswerSet
    include LightSide::Resources

    setup do
      self.resource_base        = "answer-sets"
      self.readonly_attributes  = %w( url owner answers prediction_tasks created modified )
      self.writable_attributes  = %w( prompt icon tile_color auth_token trained_models tags )
    end

  end
end
