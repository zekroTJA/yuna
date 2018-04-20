require 'monitor'

class Timer
    @ran = false

    def initialize (times, interval = 10, &handler)
        while true
            _ctime = Time.new
            time = [ _ctime.hour, _ctime.min ]
            unless times.select { |t| t == time }.empty?
                unless @ran
                    Thread.new do
                        handler.call
                    end
                    @ran = true
                end
            else 
                if @ran
                    @ran = false
                end
            end
            sleep(interval)
        end
    end

end