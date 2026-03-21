# frozen_string_literal: true

RSpec.describe Legion::Extensions::Foundry::Runners::Deployments do
  let(:test_class) do
    Class.new do
      extend Legion::Extensions::Foundry::Helpers::Client
      extend Legion::Extensions::Foundry::Runners::Deployments
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
      "/providers/Microsoft.MachineLearningServices/workspaces/#{workspace}" \
      '/onlineEndpoints/default/deployments'
  end

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe '#list' do
    it 'lists deployments' do
      body = { 'value' => [{ 'name' => 'my-deployment' }] }
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
      expect(result[:deployments]).to eq(body)
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
      expect(result[:deployments]).to eq(body)
    end
  end

  describe '#get' do
    it 'gets a named deployment' do
      body = { 'name' => 'my-deployment', 'properties' => {} }
      allow(conn).to receive(:get)
        .with("#{base_path}/my-deployment?api-version=2024-10-01-preview")
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.get(
        name:            'my-deployment',
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:deployment]).to eq(body)
    end
  end

  describe '#create' do
    it 'creates a deployment via PUT' do
      body = { 'name' => 'new-deployment' }
      allow(conn).to receive(:put)
        .with("#{base_path}/new-deployment?api-version=2024-10-01-preview",
              hash_including(properties: hash_including(model: 'gpt-4o')))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.create(
        name:            'new-deployment',
        model:           'gpt-4o',
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:deployment]).to eq(body)
    end

    it 'uses a custom sku' do
      body = { 'name' => 'new-deployment' }
      allow(conn).to receive(:put)
        .with("#{base_path}/new-deployment?api-version=2024-10-01-preview",
              hash_including(sku: { name: 'Premium' }))
        .and_return(instance_double(Faraday::Response, body: body))

      result = test_class.create(
        name:            'new-deployment',
        model:           'gpt-4o',
        sku:             'Premium',
        token:           token,
        endpoint:        endpoint,
        subscription_id: subscription_id,
        resource_group:  resource_group,
        workspace:       workspace
      )
      expect(result[:deployment]).to eq(body)
    end
  end

  describe '#delete' do
    it 'deletes a deployment' do
      allow(conn).to receive(:delete)
        .with("#{base_path}/old-deployment?api-version=2024-10-01-preview")
        .and_return(instance_double(Faraday::Response, body: nil, status: 204))

      result = test_class.delete(
        name:            'old-deployment',
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
