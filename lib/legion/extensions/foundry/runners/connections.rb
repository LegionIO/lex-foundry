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
            { connections: response.body }
          end

          def get(name:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                  api_version: '2024-10-01-preview', **)
            path = arm_connections_path(subscription_id, resource_group, workspace)
            response = management_client(token: token, endpoint: endpoint)
                       .get("#{path}/#{name}?api-version=#{api_version}")
            { connection: response.body }
          end

          def create(name:, type:, target:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                     api_version: '2024-10-01-preview', **)
            path = arm_connections_path(subscription_id, resource_group, workspace)
            body = { properties: { category: type, target: target } }
            response = management_client(token: token, endpoint: endpoint)
                       .put("#{path}/#{name}?api-version=#{api_version}", body)
            { connection: response.body }
          end

          def delete(name:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                     api_version: '2024-10-01-preview', **)
            path = arm_connections_path(subscription_id, resource_group, workspace)
            management_client(token: token, endpoint: endpoint)
              .delete("#{path}/#{name}?api-version=#{api_version}")
            { deleted: true }
          end
          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)

          private

          def arm_connections_path(subscription_id, resource_group, workspace)
            "/subscriptions/#{subscription_id}/resourceGroups/#{resource_group}" \
              "/providers/Microsoft.MachineLearningServices/workspaces/#{workspace}/connections"
          end
        end
      end
    end
  end
end
