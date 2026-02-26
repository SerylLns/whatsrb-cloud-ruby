# frozen_string_literal: true

module WhatsrbCloud
  class Configuration
    attr_accessor :api_key, :base_url, :timeout

    def initialize
      @api_key  = nil
      @base_url = 'https://api.whatsrb.com'
      @timeout  = 30
    end
  end
end
