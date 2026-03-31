# Changelog

## [0.1.4] - 2026-03-31

### Added
- Standardized `usage:` key in all runner return hashes with `input_tokens`, `output_tokens`, `cache_read_tokens`, and `cache_write_tokens` fields parsed from Anthropic Foundry API responses (defaults to zero when not present)

## [0.1.3] - 2026-03-30

### Changed
- update to rubocop-legion 0.1.7, resolve all offenses

## [0.1.2] - 2026-03-22

### Changed
- Add legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, and legion-transport as runtime dependencies in gemspec
- Update spec_helper with real sub-gem helper requires and full Helpers::Lex stub (all 7 includes)
- Add simplecov to Gemfile test group

## [0.1.0] - 2026-03-21

### Added
- Initial release
- Deployments runner (list, get, create, delete) via Azure Management API
- Models runner (list, get) via Azure AI Foundry workspace endpoint
- Connections runner (list, get, create, delete) via Azure Management API
- Standalone Client class
- Faraday-based HTTP client with Bearer token authentication
- Two connection builders: management_client (management.azure.com) and workspace_client ({endpoint}.api.azureml.ms)
