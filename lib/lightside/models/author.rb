module LightSide
  class Author
    include LightSide::Resources

    setup do
      self.resource_base        = "authors"
      self.readonly_attributes  = %w( url owner answers created modified )
      self.writable_attributes  = %w( designator email auth_token active )
    end

  end
end
