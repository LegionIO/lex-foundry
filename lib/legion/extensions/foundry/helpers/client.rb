# frozen_string_literal: true

require 'faraday'
require 'multi_json'

module Legion
  module Extensions
    module Foundry
      module Helpers
        module Client
          module_function

          def management_client(token:, **)
            Faraday.new(url: 'https://management.azure.com') do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{token}"
              conn.headers['Content-Type']  = 'application/json'
            end
          end

          def workspace_client(token:, endpoint:, **)
            Faraday.new(url: "https://#{endpoint}.api.azureml.ms") do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['Authorization'] = "Bearer #{token}"
              conn.headers['Content-Type']  = 'application/json'
            end
          end
        end
      end
    end
  end
end
