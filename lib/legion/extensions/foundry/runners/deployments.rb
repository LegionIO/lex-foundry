# frozen_string_literal: true

require 'legion/extensions/foundry/helpers/client'

module Legion
  module Extensions
    module Foundry
      module Runners
        module Deployments
          extend Legion::Extensions::Foundry::Helpers::Client

          def list(token:, endpoint:, subscription_id:, resource_group:, workspace:,
                   api_version: '2024-10-01-preview', **)
            path = arm_deployments_path(subscription_id, resource_group, workspace)
            response = management_client(token: token, endpoint: endpoint)
                       .get("#{path}?api-version=#{api_version}")
            { deployments: response.body }
          end

          def get(name:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                  api_version: '2024-10-01-preview', **)
            path = arm_deployments_path(subscription_id, resource_group, workspace)
            response = management_client(token: token, endpoint: endpoint)
                       .get("#{path}/#{name}?api-version=#{api_version}")
            { deployment: response.body }
          end

          def create(name:, model:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                     sku: 'Standard', api_version: '2024-10-01-preview', **)
            path = arm_deployments_path(subscription_id, resource_group, workspace)
            body = { properties: { model: model }, sku: { name: sku } }
            response = management_client(token: token, endpoint: endpoint)
                       .put("#{path}/#{name}?api-version=#{api_version}", body)
            { deployment: response.body }
          end

          def delete(name:, token:, endpoint:, subscription_id:, resource_group:, workspace:,
                     api_version: '2024-10-01-preview', **)
            path = arm_deployments_path(subscription_id, resource_group, workspace)
            management_client(token: token, endpoint: endpoint)
              .delete("#{path}/#{name}?api-version=#{api_version}")
            { deleted: true }
          end
          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex, false)

          private

          def arm_deployments_path(subscription_id, resource_group, workspace)
            "/subscriptions/#{subscription_id}/resourceGroups/#{resource_group}" \
              "/providers/Microsoft.MachineLearningServices/workspaces/#{workspace}" \
              '/onlineEndpoints/default/deployments'
          end
        end
      end
    end
  end
end
