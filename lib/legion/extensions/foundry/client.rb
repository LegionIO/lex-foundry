# frozen_string_literal: true

require 'legion/extensions/foundry/helpers/client'
require 'legion/extensions/foundry/runners/deployments'
require 'legion/extensions/foundry/runners/models'
require 'legion/extensions/foundry/runners/connections'

module Legion
  module Extensions
    module Foundry
      class Client
        include Legion::Extensions::Foundry::Runners::Deployments
        include Legion::Extensions::Foundry::Runners::Models
        include Legion::Extensions::Foundry::Runners::Connections

        attr_reader :config

        def initialize(token:, endpoint:, api_version: '2024-10-01-preview', **opts)
          @config = { token: token, endpoint: endpoint, api_version: api_version, **opts }
        end

        private

        def management_client(**override_opts)
          merged = config.merge(override_opts)
          Legion::Extensions::Foundry::Helpers::Client.management_client(**merged)
        end

        def workspace_client(**override_opts)
          merged = config.merge(override_opts)
          Legion::Extensions::Foundry::Helpers::Client.workspace_client(**merged)
        end
      end
    end
  end
end
