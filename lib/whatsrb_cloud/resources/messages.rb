# frozen_string_literal: true

module WhatsrbCloud
  module Resources
    class Messages
      def initialize(connection:, session_id:)
        @connection = connection
        @session_id = session_id
      end

      def list
        response = @connection.get("/sessions/#{@session_id}/messages")
        data = (response['data'] || []).map { |m| Objects::Message.new(m) }
        Objects::List.new(data: data, meta: response['meta'] || {})
      end

      def retrieve(message_id)
        response = @connection.get("/sessions/#{@session_id}/messages/#{message_id}")
        Objects::Message.new(response)
      end

      def create(**params)
        response = @connection.post("/sessions/#{@session_id}/messages", params)
        Objects::Message.new(response)
      end
    end
  end
end
