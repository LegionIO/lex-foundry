# frozen_string_literal: true

require 'legion/extensions/foundry/version'
require 'legion/extensions/foundry/helpers/client'
require 'legion/extensions/foundry/runners/deployments'
require 'legion/extensions/foundry/runners/models'
require 'legion/extensions/foundry/runners/connections'
require 'legion/extensions/foundry/client'

module Legion
  module Extensions
    module Foundry
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
