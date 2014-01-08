module LightSide
  class TrainingTask
    include LightSide::Resources

    setup do
      self.resource_base        = "training-tasks"
      self.readonly_attributes  = %w( url process task_id owner status messages trained_model created modified )
      self.writable_attributes  = %w( corpus )
    end

    def process_start
      RestClient.post(process, "", Config.headers) do |response, request, result|
        case response.code
        when 200, 202
          yield JSON.parse(response)
        when 404
          raise ResourceNotFound, "could not find #{name} with ID=#{id}"
        else
          raise JSON.parse(response)["detail"]
        end
      end
    end

  end
end
