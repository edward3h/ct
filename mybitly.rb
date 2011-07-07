require 'cgi'
require 'net/http'
require 'json'

class Bitly
    def initialize(username, key)
        @defaults = {'login' => username, 'apiKey' => key}
    end

    def shorten(*urls)
        if urls
            r = []
            urls.flatten.map{|u| cleanup(u)}.each do |u|
                jr = make_request('shorten', 'longUrl' => u)
                r << BitlyUrl.new(jr['data']['url'], jr['data']['long_url']) if jr && jr['data']
            end
            r
        end
    end
    
    def expand(*urls)
        if urls
            jr = make_request('expand', 'shortUrl' => urls.flatten.map{|u| cleanup(u)})
            if(jr && jr['data'] && jr['data']['expand'])
                jr['data']['expand'].map{|m| BitlyUrl.new(m['short_url'], m['long_url'])}
            end
        end
    end

    def make_request(path, params)
        query = @defaults.merge(params).map do |k, v|
            if(v.is_a? Array)
                v.map{|vx| "#{k}=#{vx}"}.join("&")
            else
                "#{k}=#{v}"
            end
        end.join("&")
        requrl = "http://api.bit.ly/v3/#{path}?#{query}"
        resp = Net::HTTP::get(URI.parse(requrl))
        jr = JSON.parse(resp)
        if(jr && jr["status_code"] != 200)
            puts "Bitly API error #{jr["status_code"]} #{jr["status_txt"]}"
            nil
        else
            jr
        end
    end

    def cleanup(url)
        CGI::escape(url.strip) if url
    end
end

class BitlyUrl
    attr_reader :short, :long
    
    def initialize(short, long)
        @short = short
        @long = long
    end

    alias :short_url :short
    alias :long_url :long
end
