module LightSide
  class AssignmentTileColor
    include LightSide::Resources

    setup do
      self.resource_base        = "assignment-tile-colors"
      self.readonly_attributes  = %w( url color )
      self.writable_attributes  = %w( )
    end

  end
end
