# frozen_string_literal: true

RSpec.describe Legion::Extensions::Foundry::Client do
  let(:token)    { 'test-bearer-token' }
  let(:endpoint) { 'my-workspace' }
  let(:client)   { described_class.new(token: token, endpoint: endpoint) }

  it 'stores config on initialization' do
    expect(client.config[:token]).to eq(token)
    expect(client.config[:endpoint]).to eq(endpoint)
    expect(client.config[:api_version]).to eq('2024-10-01-preview')
  end

  it 'accepts a custom api_version' do
    c = described_class.new(token: token, endpoint: endpoint, api_version: '2024-05-01-preview')
    expect(c.config[:api_version]).to eq('2024-05-01-preview')
  end

  it 'includes Deployments runner methods' do
    expect(client).to respond_to(:list)
  end

  it 'includes Models runner methods' do
    expect(client).to respond_to(:get)
  end

  it 'includes Connections runner methods' do
    expect(client).to respond_to(:create)
  end
end
