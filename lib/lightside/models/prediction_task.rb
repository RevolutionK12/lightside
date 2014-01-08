module LightSide
  class PredictionTask
    include LightSide::Resources

    setup do
      self.resource_base        = "prediction-tasks"
      self.readonly_attributes  = %w( url process task_id owner status messages prediction_results created modified )
      self.writable_attributes  = %w( answer_set )
    end

    def process_start
      RestClient.post(process, "", Config.headers) do |response, request, result|
        case response.code
        when 200, 202
          return JSON.parse(response)
        when 404
          raise ResourceNotFound, "could not find #{name} with ID=#{id}"
        else
          raise JSON.parse(response)["detail"]
        end
      end
    end

  end
end
