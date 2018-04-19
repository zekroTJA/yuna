require_relative 'davidgetter'
require_relative 'config'
require_relative 'twitter'

config = Config.new 'config.json'
getter = DavidGetter.new config.get_list_file, config.get_img_path
twitter = TwitterClient.new config.get_twitter_creds


info = getter.get_next

dl_file = info['filename']

tweet_cont = info['author'].nil? || info['title'].nil? ? 
             info['origin'] : 
             "'#{info['title']}' by #{info['author']}\n\n(#{info['origin']})"


unless dl_file.nil?
    puts twitter.send tweet_cont, dl_file
end