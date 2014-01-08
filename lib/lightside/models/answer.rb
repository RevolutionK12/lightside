module LightSide
  class Answer
    include LightSide::Resources

    setup do
      self.resource_base        = "answers"
      self.readonly_attributes  = %w( url predicted prediction_results created modified )
      self.writable_attributes  = %w( parent author answer_set text author_comments reviewer_commentss submission viewed auth_token )
    end

  end
end
