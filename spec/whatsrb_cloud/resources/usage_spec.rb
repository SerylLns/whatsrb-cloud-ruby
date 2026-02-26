# frozen_string_literal: true

RSpec.describe WhatsrbCloud::Resources::Usage do
  let(:client) { WhatsrbCloud::Client.new(api_key: 'wrb_live_test') }

  describe '#fetch' do
    it 'returns usage data as a hash' do
      FakeServer.stub_get('/usage', response: {
                            'messages_sent' => 150,
                            'messages_received' => 89,
                            'sessions_active' => 3,
                            'plan' => 'pro',
                            'period' => '2026-02'
                          })

      result = client.usage
      expect(result['messages_sent']).to eq(150)
      expect(result['sessions_active']).to eq(3)
      expect(result['plan']).to eq('pro')
    end
  end
end
