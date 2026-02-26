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
        Objects::Message.new(response['data'])
      end

      def create(**params)
        body = build_message_body(params)
        response = @connection.post("/sessions/#{@session_id}/messages", { message: body })
        Objects::Message.new(response['data'])
      end

      private

      def build_message_body(params)
        if params[:text]
          { to: params[:to], message_type: 'text', content: params[:text] }
        else
          params.slice(:to, :message_type, :content)
        end
      end
    end
  end
end
