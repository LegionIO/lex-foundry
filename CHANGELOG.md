# Changelog

## [0.1.0] - 2026-03-21

### Added
- Initial release
- Deployments runner (list, get, create, delete) via Azure Management API
- Models runner (list, get) via Azure AI Foundry workspace endpoint
- Connections runner (list, get, create, delete) via Azure Management API
- Standalone Client class
- Faraday-based HTTP client with Bearer token authentication
- Two connection builders: management_client (management.azure.com) and workspace_client ({endpoint}.api.azureml.ms)
