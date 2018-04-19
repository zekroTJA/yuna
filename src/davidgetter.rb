#!/usr/bin/ruby

require 'uri'
require 'open-uri'
require 'whenever'


LIST_FILE = 'BOTLIST'
IMG_PATH = './images/'


class DavidGetter

    # TEST URLS
    # https://www.deviantart.com/art/The-Crypt-King-741021746
    # https://imgur.com/gallery/79bjmLm

    # Gets the top entry of the LIST_FILE, returns it, if
    # the file is not empty and deletes the entry from the file.
    def self.get_next_list_entry!
        begin 
            # Read out every line of list file
            # into an array
            full_file = []
            File.open(LIST_FILE, 'r') do |file|
                while _line = file.gets
                    full_file << _line.sub(/\n/, '')
                end
            end
            # If the array is not empty, shift the first
            # entry into an output variable and save the
            # shifted array in the file by overwriting.
            # Then, return the output variable
            if !full_file.empty?
                _out = full_file.shift
                File.open(LIST_FILE, 'w') do |file|
                    full_file.each { |ln| 
                        file.puts ln 
                    }
                end
                return _out
            end
            return nil
        rescue Exception => e
            puts "[FATAL ERROR] while 'get_next_list_entry': #{e}"
            exit
        end
    end

    # Get the first image url from a website by link
    def self.get_image (origin_url)
        begin
            html = open(origin_url).read
            urls = URI.extract(html)
                .select { |lnk| lnk[/\.jpg$|\.png$|\.gif$|\.jpeg/m] }
            return urls.empty? ? nil : urls[0]
        rescue Exception => e
            puts "[ERROR] while 'get_image': #{e}"
            return nil
        end
    end

    def self.dl_image (url)
        _filename = IMG_PATH + url.split('/').last
        begin
            if !File.directory?(IMG_PATH)
                require 'fileutils'
                FileUtils::mkdir_p IMG_PATH
                puts "[INFO] created path '#{IMG_PATH}'"
            end
            puts "[INFO] writing image file '#{_filename}'"
            File.open(_filename, 'wb') do |file|
                file.write open(url).read
            end
            return _filename
        rescue Exception => e
            puts "[ERROR] while 'dl_image': #{e}"
        end
        return nil
    end

end