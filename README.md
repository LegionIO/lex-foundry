# lex-foundry

LegionIO extension for Azure AI Foundry (formerly Azure AI Studio). Provides runners for the Azure AI Foundry REST API — model catalog, deployments, and workspace connections.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-foundry'
```

## Authentication

All methods require an Azure AD / Entra ID Bearer token passed as `token:`.

## Usage

### Standalone Client

```ruby
client = Legion::Extensions::Foundry::Client.new(
  token:           'your-bearer-token',
  endpoint:        'my-workspace',
  subscription_id: 'sub-id',
  resource_group:  'rg-name',
  workspace:       'ws-name'
)

client.list(subscription_id: 'sub-id', resource_group: 'rg', workspace: 'ws')
```

### Runners Directly

```ruby
Legion::Extensions::Foundry::Runners::Models.list(token: 'tok', endpoint: 'my-workspace')
Legion::Extensions::Foundry::Runners::Deployments.list(token: 'tok', endpoint: 'ep', subscription_id: 'sid', resource_group: 'rg', workspace: 'ws')
Legion::Extensions::Foundry::Runners::Connections.list(token: 'tok', endpoint: 'ep', subscription_id: 'sid', resource_group: 'rg', workspace: 'ws')
```

## API Version

Default: `2024-10-01-preview`. Pass `api_version:` to override.

## License

MIT
