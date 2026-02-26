# frozen_string_literal: true

RSpec.describe WhatsrbCloud::WebhookSignature do
  let(:secret) { 'whsec_test_secret' }
  let(:payload) { '{"event":"message.received","data":{"id":"msg_1"}}' }
  let(:valid_signature) { OpenSSL::HMAC.hexdigest('SHA256', secret, payload) }

  describe '.verify?' do
    it 'returns true for a valid signature' do
      expect(described_class.verify?(payload: payload, secret: secret, signature: valid_signature)).to be true
    end

    it 'returns false for an invalid signature' do
      expect(described_class.verify?(payload: payload, secret: secret, signature: 'invalid')).to be false
    end

    it 'returns false for a tampered payload' do
      tampered = '{"event":"message.received","data":{"id":"msg_HACKED"}}'
      expect(described_class.verify?(payload: tampered, secret: secret, signature: valid_signature)).to be false
    end

    it 'returns false for a wrong secret' do
      expect(described_class.verify?(payload: payload, secret: 'wrong_secret', signature: valid_signature)).to be false
    end

    it 'returns false when signature is nil' do
      expect(described_class.verify?(payload: payload, secret: secret, signature: nil)).to be false
    end

    it 'returns false when payload is nil' do
      expect(described_class.verify?(payload: nil, secret: secret, signature: valid_signature)).to be false
    end

    it 'returns false when secret is nil' do
      expect(described_class.verify?(payload: payload, secret: nil, signature: valid_signature)).to be false
    end
  end
end
