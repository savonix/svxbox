module Rack
  class Out
    DEFAULTS = { :key => "rack:out" }
    
    def initialize(app, options = {})
      @app, @options = app, DEFAULTS.merge(options)
      @redis = Redis.new @options[:redis] if @options[:redis].is_a?(Hash)
      @redis = @options[:redis] if @options[:redis].is_a?(Redis)
    end
    
    # Add like this: r.sadd('rackout','192.168.254.1')
    #
    def call(env)
      request = Rack::Request.new(env)

      begin      
        if @redis.sismember @options[:key], request.ip.to_s
          http_error(403)
        else
          @app.call env
        end
      rescue 
        @app.call env
      end
      
    end

    ##
    # Outputs an HTTP `4xx` or `5xx` response.
    #
    # @param  [Integer]                code
    # @param  [String, #to_s]          message
    # @param  [Hash{String => String}] headers
    # @return [Array(Integer, Hash, #each)]
    def http_error(code, message = nil, headers = {})
      [code, {'Content-Type' => 'text/plain; charset=utf-8'}.merge(headers),
        [http_status(code), (message.nil? ? "\n" : " (#{message})\n")]]
    end

    ##
    # Returns the standard HTTP status message for the given status `code`.
    #
    # @param  [Integer] code
    # @return [String]
    def http_status(code)
      [code, Rack::Utils::HTTP_STATUS_CODES[code]].join(' ')
    end
  end
end
