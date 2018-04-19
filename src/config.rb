require 'json'

class Config 
    
    @path
    @config

    def initialize (path)
        @path = path
        begin
            @config = JSON.parse(
                File.read(@path)
            )
        rescue Exception => e
            puts "[FATAL ERROR] failed reading config file '#{@path}': #{e}"
            exit
        end
    end

    def get_raw
        return @config
    end

    def get_img_path
        return @config['imgsavedir']
    end

    def get_list_file
        return @config['urllistfile']
    end

    def get_twitter_creds
        return @config['twitter']
    end

end