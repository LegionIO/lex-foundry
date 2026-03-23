# lex-foundry

Legion Extension for Azure AI Foundry (formerly Azure AI Studio). Provides runners for the Azure AI Foundry REST API — workspace connections, online endpoint deployments, and the model catalog.

## Purpose

Wraps the Azure AI Foundry management and workspace APIs as named runners consumable by any LegionIO task chain. Use this extension when you need to manage Azure ML workspace resources (connections, deployments, models) within the LEX runner/actor lifecycle. For inference against deployed models, use `lex-azure-ai` instead.

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

## API Coverage

| Runner | Methods |
|--------|---------|
| `Connections` | `list`, `get`, `create`, `delete` |
| `Deployments` | `list`, `get`, `create`, `delete` |
| `Models` | `list`, `get` |

## API Version

Default: `2024-10-01-preview`. Pass `api_version:` to override.

## Related

- `lex-azure-ai` — Azure OpenAI inference (chat completions, embeddings)
- `extensions-ai/CLAUDE.md` — Architecture patterns shared across all AI extensions

## License

MIT
