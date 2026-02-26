# frozen_string_literal: true

module WhatsrbCloud
  module Resources
    class Usage
      def initialize(connection:)
        @connection = connection
      end

      def fetch
        @connection.get('/usage')
      end
    end
  end
end
