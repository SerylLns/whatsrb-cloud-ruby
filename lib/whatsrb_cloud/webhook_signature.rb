# frozen_string_literal: true

require 'openssl'

module WhatsrbCloud
  module WebhookSignature
    PREFIX = 'sha256='

    module_function

    def verify?(payload:, secret:, signature:)
      return false if payload.nil? || secret.nil? || signature.nil?

      hex = OpenSSL::HMAC.hexdigest('SHA256', secret, payload)
      expected = "#{PREFIX}#{hex}"

      # Support both "sha256=<hex>" and raw "<hex>" formats
      to_compare = signature.start_with?(PREFIX) ? signature : "#{PREFIX}#{signature}"

      secure_compare(expected, to_compare)
    end

    def secure_compare(a, b)
      return false unless a.bytesize == b.bytesize

      OpenSSL.fixed_length_secure_compare(a, b)
    end

    private_class_method :secure_compare
  end
end
