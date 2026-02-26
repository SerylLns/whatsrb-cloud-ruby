# frozen_string_literal: true

module WhatsrbCloud
  module Objects
    class Message
      attr_reader :id, :session_id, :to, :status, :message_type, :content,
                  :whatsapp_message_id, :sent_at, :delivered_at, :created_at

      def initialize(data)
        @id                   = data['id']
        @session_id           = data['session_id']
        @to                   = data['to']
        @status               = data['status']
        @message_type         = data['message_type']
        @content              = data['content']
        @whatsapp_message_id  = data['whatsapp_message_id']
        @sent_at              = parse_time(data['sent_at'])
        @delivered_at         = parse_time(data['delivered_at'])
        @created_at           = parse_time(data['created_at'])
      end

      def to_h
        {
          'id' => @id, 'session_id' => @session_id, 'to' => @to,
          'status' => @status, 'message_type' => @message_type, 'content' => @content
        }
      end

      private

      def parse_time(value)
        return nil if value.nil?

        Time.parse(value)
      rescue ArgumentError
        nil
      end
    end
  end
end
