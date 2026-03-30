# frozen_string_literal: true

require 'legion/extensions/foundry/helpers/client'

module Legion
  module Extensions
    module Foundry
      module Runners
        module Models
          extend Legion::Extensions::Foundry::Helpers::Client

          def list(token:, endpoint:, api_version: '2024-10-01-preview', **)
            response = workspace_client(token: token, endpoint: endpoint)
                       .get("/models?api-version=#{api_version}")
            { models: response.body }
          end

          def get(model_id:, token:, endpoint:, api_version: '2024-10-01-preview', **)
            response = workspace_client(token: token, endpoint: endpoint)
                       .get("/models/#{model_id}?api-version=#{api_version}")
            { model: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)
        end
      end
    end
  end
end
