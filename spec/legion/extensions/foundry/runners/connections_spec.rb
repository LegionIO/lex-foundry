# frozen_string_literal: true

RSpec.describe Legion::Extensions::Foundry::Runners::Connections do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Foundry::Helpers::Client
      extend Legion::Extensions::Foundry::Runners::Connections
    end
  end

  let(:token)           { 'test-bearer-token' }
  let(:endpoint)        { 'my-workspace' }
  let(:subscription_id) { 'sub-123' }
  let(:resource_group)  { 'rg-test' }
  let(:workspace)       { 'ws-test' }
  let(:conn)            { instance_double(Faraday::Connection) }

  let(:base_path) do
    "/subscriptions/#{subscription_id}/resourceGroups/#{resource_group}" \
      "/providers/Microsoft.MachineLearningServices/workspaces/#{workspace}/connections"
  end

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#list' do
    it 'lists workspace connections' do
      body = { 'value' => [{ 'name' => 'my-conn' }] }
      allow(conn).to receive(:get)
        .with("#{base_path}?api-version=2024-10-01-preview")
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.list(
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:connections]).to eq(body)
    end

    it 'uses a custom api_version' do
      body = { 'value' => [] }
      allow(conn).to receive(:get)
        .with("#{base_path}?api-version=2024-05-01-preview")
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.list(
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace,
        api_version:     '2024-05-01-preview'
      )
      expect(result[:connections]).to eq(body)
    end
  end

  describe '#get' do
    it 'gets a named connection' do
      body = { 'name' => 'my-conn', 'properties' => {} }
      allow(conn).to receive(:get)
        .with("#{base_path}/my-conn?api-version=2024-10-01-preview")
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.get(
        name:            'my-conn',
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:connection]).to eq(body)
    end
  end

  describe '#create' do
    it 'creates a connection via PUT' do
      body = { 'name' => 'new-conn' }
      allow(conn).to receive(:put)
        .with("#{base_path}/new-conn?api-version=2024-10-01-preview",
              hash_including(properties: hash_including(category: 'AzureBlob')))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.create(
        name:            'new-conn',
        type:            'AzureBlob',
        target:          'https://myaccount.blob.core.windows.net',
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:connection]).to eq(body)
    end

    it 'includes target in the request body' do
      body = { 'name' => 'new-conn' }
      target = 'https://myaccount.blob.core.windows.net'
      allow(conn).to receive(:put)
        .with("#{base_path}/new-conn?api-version=2024-10-01-preview",
              hash_including(properties: { category: 'AzureBlob', target: target }))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.create(
        name:            'new-conn',
        type:            'AzureBlob',
        target:          target,
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:connection]).to eq(body)
    end
  end

  describe '#delete' do
    it 'deletes a connection' do
      allow(conn).to receive(:delete)
        .with("#{base_path}/old-conn?api-version=2024-10-01-preview")
        .and_return(instance_double(Faraday::Response, body: nil, status: 204))

      result = test_class.delete(
        name:            'old-conn',
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:deleted]).to be true
    end
  end
end
