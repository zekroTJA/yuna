require_relative 'davidgetter'
require_relative 'config'
require_relative 'twitter'
require_relative 'timer'


##### GLOBAL VARS #####

$config = Config.new 'config.json'
$getter = DavidGetter.new $config.get_list_file, $config.get_img_path
$twitter = TwitterClient.new $config.get_twitter_creds


##### HELP FUNCTIONS #####

def get_time
    _t = Time.new
    pad = lambda { |x| if x > 9 then x else "0" + x.to_s end }
    return "#{pad.call _t.month}/#{pad.call _t.day}/#{_t.year} - #{pad.call _t.hour}:#{pad.call _t.min}:#{pad.call _t.sec}"
end


def trigger
    info = $getter.get_next
    unless info.nil?
        dl_file = info['filename']
        tweet_cont = info['author'].nil? || info['title'].nil? ? 
                     info['origin'] : 
                     "'#{info['title']}' by #{info['author']}\n\n(#{info['origin']})"
        unless dl_file.nil?
            if $twitter.send tweet_cont, dl_file
                puts "[#{get_time}] Send image #{info['url']} (#{info['origin']})]"
            else
                puts "[#{get_time}] Failed sending image to twitter"
            end
        end
    else
        puts "[#{get_time}] Queue is empty. Send nothing."
    end
end



##### MAIN SCRIPT STARTS HERE #####

_display_times = $config.get_raw()['timer']['times'].map { |t| "#{t[0]}:#{t[1]}" }.join ', '
puts "
| #{get_time}  
|  Started Tool
|  Defined Times: #{_display_times}\n
"

if ($config.get_raw()['timer'].nil? || $config.get_raw()['timer']['times'].nil? || $config.get_raw()['timer']['times'].empty?)
    puts "[FATAL ERROR] Please speify times to trigger action in 'config.json' file!"
    exit
end

Timer.new $config.get_raw()['timer']['times'], $config.get_raw()['timer']['interval'] do
    trigger
end