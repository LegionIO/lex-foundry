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
            body = response.body
            { models: body, usage: extract_usage(body) }
          end

          def get(model_id:, token:, endpoint:, api_version: '2024-10-01-preview', **)
            response = workspace_client(token: token, endpoint: endpoint)
                       .get("/models/#{model_id}?api-version=#{api_version}")
            body = response.body
            { model: body, usage: extract_usage(body) }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)

          private

          def extract_usage(body)
            {
              input_tokens:       body&.dig('usage', 'input_tokens') || 0,
              output_tokens:      body&.dig('usage', 'output_tokens') || 0,
              cache_read_tokens:  body&.dig('usage', 'cache_read_input_tokens') || 0,
              cache_write_tokens: body&.dig('usage', 'cache_creation_input_tokens') || 0
            }
          end
        end
      end
    end
  end
end
