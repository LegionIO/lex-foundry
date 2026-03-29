# lex-foundry: Azure AI Foundry Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-ai/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to Azure AI Foundry (formerly Azure AI Studio). Provides runners for workspace connections, online endpoint deployments, and model catalog via the Azure AI Foundry REST API.

**GitHub**: https://github.com/LegionIO/lex-foundry
**License**: MIT
**Version**: 0.1.2
**Specs**: 21 examples

## Architecture

```
Legion::Extensions::Foundry
├── Runners/
│   ├── Connections    # list, get, create, delete (workspace connections)
│   ├── Deployments    # list, get, create, delete (online endpoint deployments)
│   └── Models         # list, get (workspace model catalog)
├── Helpers/
│   └── Client         # Two Faraday client factories (module)
└── Client             # Standalone client class (includes all runners, holds @config)
```

`Helpers::Client` is a **module** with two distinct factory methods:
- `management_client(token:, ...)` — Faraday connection to `https://management.azure.com` (ARM API). Used by `Connections` and `Deployments` runners.
- `workspace_client(token:, endpoint:, ...)` — Faraday connection to `https://#{endpoint}.api.azureml.ms`. Used by `Models` runner.

Both use `Authorization: Bearer #{token}` header. The token is an Azure AD / Entra ID bearer token.

## Key Design Decisions

- Two client factories are required because the Azure AI Foundry API surface spans two base URLs: the ARM management plane (`management.azure.com`) and the workspace plane (`*.api.azureml.ms`).
- `Connections` and `Deployments` runners build ARM resource paths via private helper methods (`arm_connections_path`, `arm_deployments_path`). These paths include `subscription_id`, `resource_group`, and `workspace` positional segments.
- Default `api_version` is `'2024-10-01-preview'` on all runner methods.
- `Deployments` paths target `onlineEndpoints/default/deployments` — these are ML online endpoints, not Azure OpenAI deployments.
- Return value shapes vary by runner: `{ connections: ... }`, `{ connection: ... }`, `{ deployments: ... }`, `{ deployment: ... }`, `{ models: ... }`, `{ model: ... }`, `{ deleted: true }`.
- `include Legion::Extensions::Helpers::Lex` is guarded with `const_defined?` pattern.

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` >= 2.0 | HTTP client for Azure AI Foundry API |
| `multi_json` | JSON parser abstraction |

## Testing

```bash
bundle install
bundle exec rspec        # 21 examples
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
