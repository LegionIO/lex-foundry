# frozen_string_literal: true

RSpec.describe Legion::Extensions::Foundry::Runners::Models do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Foundry::Helpers::Client
      extend Legion::Extensions::Foundry::Runners::Models
    end
  end

  let(:token)    { 'test-bearer-token' }
  let(:endpoint) { 'my-workspace' }
  let(:conn)     { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#list' do
    it 'lists models from the catalog' do
      body = { 'value' => [{ 'name' => 'gpt-4o' }, { 'name' => 'phi-3' }] }
      allow(conn).to receive(:get)
        .with('/models?api-version=2024-10-01-preview')
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.list(token: token, endpoint: endpoint)
      expect(result[:models]['value'].length).to eq(2)
    end

    it 'uses a custom api_version' do
      body = { 'value' => [] }
      allow(conn).to receive(:get)
        .with('/models?api-version=2024-05-01-preview')
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.list(token: token, endpoint: endpoint, api_version: '2024-05-01-preview')
      expect(result[:models]).to eq(body)
    end
  end

  describe '#get' do
    it 'gets a specific model by id' do
      body = { 'name' => 'gpt-4o', 'properties' => {} }
      allow(conn).to receive(:get)
        .with('/models/gpt-4o?api-version=2024-10-01-preview')
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.get(model_id: 'gpt-4o', token: token, endpoint: endpoint)
      expect(result[:model]).to eq(body)
    end

    it 'uses a custom api_version' do
      body = { 'name' => 'phi-3' }
      allow(conn).to receive(:get)
        .with('/models/phi-3?api-version=2024-05-01-preview')
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.get(
        model_id:    'phi-3',
        token:       token,
        endpoint:    endpoint,
        api_version: '2024-05-01-preview'
      )
      expect(result[:model]).to eq(body)
    end
  end
end
