require "addressable/uri"
require "multimap"
require 'em-synchrony'
require 'em-synchrony/em-http'

module Mailgunner
  module Synchrony
    class Message

      def initialize(message_hash)
        @api_host = ENV['MAIL_HOST']
        @api_key = ENV['MAIL_KEY']
        structify message_hash
      end

      def deliver!
        r = ''
        begin
          r = EM::HttpRequest.new(post_url).apost(body: message_data.to_hash)
        rescue Exception => e
          # Do something clever..
        end

        r
      end

    private
      def structify(message_hash)
        message_hash.merge!({mime_type: 'text/plain'}) unless message_hash[:mime_type]
        attrs = [:to, :from, :cc, :bcc, :subject, :body, :multipart, :mime_type, :has_attachments]
        struct = Struct.new(*attrs).new
        message_hash.each { |k,v| struct.send("#{k}=", v) }
        @message = struct
      end

      def message_data
        instantiate_message_data_multimap
        add_subject_to_message_data
        add_addresses_to_message_data
        add_content_parts_to_message_data
        add_attachments_to_message_data
        @message_data
      end

      def instantiate_message_data_multimap
        @message_data = Multimap.new
      end

      def add_subject_to_message_data
        @message_data[:subject] = @message.subject
      end

      def add_addresses_to_message_data
        address_fields.each do |field|
          case @message.send(field)
          when String
            @message_data[field] = @message.send(field)
          when Array
            @message.send(field).each do |address|
              @message_data[field] = address
            end
          else
            raise "Unknown data type"

          end
        end
      end

      def add_content_parts_to_message_data
        content_mime_types.each do |mime_type|
          if @message.multipart and !@message.send("#{mime_type}_part").nil?
            @message_data[mime_type] = @message.send("#{mime_type}_part")
          elsif !@message.multipart and @message.mime_type == "#{mime_type}/plain"
            @message_data[mime_type] = @message.body
          end
        end
      end

      def add_attachments_to_message_data
        raise("Attachments support is still pending") if @message.has_attachments
        # Reference:
        # data[:attachment] = File.new(File.join("files", "test.jpg"))
        # data[:attachment] = File.new(File.join("files", "test.txt"))
      end

      def post_url
        Addressable::URI.parse("https://api:#{@api_key}"\
         "@api.mailgun.net/v2/#{@api_host}/messages").to_s
      end

      def address_fields
        [:to, :from, :cc, :bcc].select { |field| !@message.send(field).nil? }
      end

      def content_mime_types
        [:text, :html]
      end
    end
  end
end