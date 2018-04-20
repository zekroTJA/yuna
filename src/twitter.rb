require 'twitter'

class TwitterClient

    @client

    def initialize (creds)
        @client = Twitter::REST::Client.new creds
    end

    def send (content = '', image = nil)
        begin
            if image.nil?
                @client.update content
            else
                @client.update_with_media content, File.new(image)
            end
            return true
        rescue Exception => e
            puts "[ERROR] in 'TwitterClient#send': #{e}"
            return false
        end
    end

end