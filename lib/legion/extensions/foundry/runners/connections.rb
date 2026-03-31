# frozen_string_literal: true

require 'legion/extensions/foundry/helpers/client'

module Legion
  module Extensions
    module Foundry
      module Runners
        module Connections
          extend Legion::Extensions::Foundry::Helpers::Client

          def list(token:, endpoint:, subscription_id:, resource_group:, workspace:,
                   api_version: '2024-10-01-preview', **)
            path = arm_connections_path(subscription_id, resource_group, workspace)
            response = management_client(token: token, endpoint: endpoint)
                       .get("#{path}?api-version=#{api_version}")
            body = response.body
            { connections: body, usage: extract_usage(body) }
          end

          def get(name:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                  api_version: '2024-10-01-preview', **)
            path = arm_connections_path(subscription_id, resource_group, workspace)
            response = management_client(token: token, endpoint: endpoint)
                       .get("#{path}/#{name}?api-version=#{api_version}")
            body = response.body
            { connection: body, usage: extract_usage(body) }
          end

          def create(name:, type:, target:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                     api_version: '2024-10-01-preview', **)
            path = arm_connections_path(subscription_id, resource_group, workspace)
            request_body = { properties: { category: type, target: target } }
            response = management_client(token: token, endpoint: endpoint)
                       .put("#{path}/#{name}?api-version=#{api_version}", request_body)
            body = response.body
            { connection: body, usage: extract_usage(body) }
          end

          def delete(name:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                     api_version: '2024-10-01-preview', **)
            path = arm_connections_path(subscription_id, resource_group, workspace)
            management_client(token: token, endpoint: endpoint)
              .delete("#{path}/#{name}?api-version=#{api_version}")
            { deleted: true, usage: extract_usage(nil) }
          end
          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)

          private

          def arm_connections_path(subscription_id, resource_group, workspace)
            "/subscriptions/#{subscription_id}/resourceGroups/#{resource_group}" \
              "/providers/Microsoft.MachineLearningServices/workspaces/#{workspace}/connections"
          end

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
