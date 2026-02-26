# frozen_string_literal: true

RSpec.describe WhatsrbCloud::Resources::Webhooks do
  let(:client) { WhatsrbCloud::Client.new(api_key: 'wrb_live_test') }

  describe '#list' do
    it 'returns a List of Webhook objects' do
      FakeServer.stub_get('/webhooks', response: {
                            'data' => [
                              { 'id' => 'wh_1', 'url' => 'https://example.com/hook', 'events' => ['message.received'],
                                'active' => true }
                            ],
                            'meta' => { 'total' => 1 }
                          })

      list = client.webhooks.list
      expect(list.data.size).to eq(1)
      expect(list.data.first).to be_a(WhatsrbCloud::Objects::Webhook)
      expect(list.data.first.url).to eq('https://example.com/hook')
      expect(list.data.first).to be_active
    end
  end

  describe '#create' do
    it 'creates a webhook and returns the secret' do
      FakeServer.stub_post('/webhooks', response: {
                             'id' => 'wh_new', 'url' => 'https://example.com/hook',
                             'events' => ['message.received'], 'active' => true, 'secret' => 'whsec_abc123'
                           })

      wh = client.webhooks.create(url: 'https://example.com/hook', events: ['message.received'])
      expect(wh.id).to eq('wh_new')
      expect(wh.secret).to eq('whsec_abc123')
      expect(wh.events).to eq(['message.received'])
    end
  end

  describe '#retrieve' do
    it 'returns a Webhook object' do
      FakeServer.stub_get('/webhooks/wh_1', response: {
                            'id' => 'wh_1', 'url' => 'https://example.com/hook',
                            'events' => ['message.received'], 'active' => true
                          })

      wh = client.webhooks.retrieve('wh_1')
      expect(wh.id).to eq('wh_1')
    end
  end

  describe '#update' do
    it 'updates webhook events' do
      FakeServer.stub_patch('/webhooks/wh_1', response: {
                              'id' => 'wh_1', 'url' => 'https://example.com/hook',
                              'events' => %w[message.received session.connected], 'active' => true
                            })

      wh = client.webhooks.update('wh_1', events: %w[message.received session.connected])
      expect(wh.events).to eq(%w[message.received session.connected])
    end
  end

  describe '#delete' do
    it 'returns true on success' do
      FakeServer.stub_delete('/webhooks/wh_1')
      expect(client.webhooks.delete('wh_1')).to be true
    end
  end
end
