module LightSide
  class AssignmentIcon
    include LightSide::Resources

    setup do
      self.resource_base        = "assignment-icons"
      self.readonly_attributes  = %w( url name description image created )
      self.writable_attributes  = %w( )
    end

  end
end
