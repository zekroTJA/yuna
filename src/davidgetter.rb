#!/usr/bin/ruby

require 'uri'
require 'open-uri'
require 'whenever'
# require_relative 'main'




class DavidGetter 

    def initialize (list_file, img_path)
        @list_file = list_file
        @img_path = img_path
    end

    # TEST URLS
    # https://www.deviantart.com/art/The-Crypt-King-741021746
    # https://imgur.com/gallery/79bjmLm

    # Gets the top entry of the LIST_FILE, returns it, if
    # the file is not empty and deletes the entry from the file.
    def get_next_list_entry!
        begin 
            # Read out every line of list file
            # into an array
            full_file = []
            File.open(@list_file, 'r') do |file|
                while _line = file.gets
                    unless _line == '' || _line.start_with?('#')
                        full_file << _line.sub(/\n/, '')
                    end
                end
            end
            # If the array is not empty, shift the first
            # entry into an output variable and save the
            # shifted array in the file by overwriting.
            # Then, return the output variable
            if !full_file.empty?
                _out = full_file.shift.split('|')
                File.open(@list_file, 'w') do |file|
                    full_file.each { |ln| 
                        file.puts ln 
                    }
                end
                return _out
            end
            return nil
        rescue Exception => e
            puts "[FATAL ERROR] in 'DavidGetter#get_next_list_entry': #{e}"
            exit
        end
    end

    # Get the first image url from a website by link
    def get_image_url (origin_url)
        begin
            html = open(origin_url).read
            urls = URI.extract(html)
                .select { |lnk| lnk[/\.jpg$|\.png$|\.gif$|\.jpeg/m] }
            return urls.empty? ? nil : urls[0]
        rescue Exception => e
            puts "[ERROR] in 'DavidGetter#get_image': #{e}"
            return nil
        end
    end

    # Download image by image url and save it to file
    def dl_image (url)
        _filename = @img_path + '/' + url.split('/').last
        begin
            if !File.directory?(@img_path)
                require 'fileutils'
                FileUtils::mkdir_p @img_path
                puts "[INFO] created path '#{@img_path}'"
            end
            puts "[INFO] writing image file '#{_filename}'"
            File.open(_filename, 'wb') do |file|
                file.write open(url).read
            end
            return _filename
        rescue Exception => e
            puts "[ERROR] in 'DavidGetter#dl_image': #{e}"
        end
        return nil
    end

    # Get top url from iMG list, get url of image out of that url
    # and download the file returning the file path after success.
    def get_next
        _info = self.get_next_list_entry!
        unless _info.nil?
            _url = _info[0]
            _imgurl = self.get_image_url _url
            unless _imgurl.nil?
                _filename = self.dl_image _imgurl
                return {
                    'filename' => _filename,
                    'author' => _info[1],
                    'title' => _info[2],
                    'origin' => _url
                }
            end
        end
        return nil
    end

end