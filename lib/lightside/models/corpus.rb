module LightSide
  class Corpus
    include LightSide::Resources

    setup do
      self.resource_base        = "corpora"
      self.readonly_attributes  = %w( url owner training_answers created modified )
      self.writable_attributes  = %w( prompt description active )
    end

    def training_answer_ids
      training_answers.map { |url| url.split("/").last }
    end

  end
end
