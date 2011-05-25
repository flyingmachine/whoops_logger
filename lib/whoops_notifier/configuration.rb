# Copyright (c) 2007, Tammer Saleh, Thoughtbot, Inc.
module WhoopsNotifier
  # Used to set up and modify settings for the notifier.
  class Configuration

    OPTIONS = [:host, :http_open_timeout, :http_read_timeout,
        :port, :protocol, :proxy_host,
        :proxy_pass, :proxy_port, :proxy_user, :secure].freeze

    # The host to connect to
    attr_accessor :host

    # The port on which your Whoops server runs (defaults to 443 for secure
    # connections, 80 for insecure connections).
    attr_accessor :port

    # +true+ for https connections, +false+ for http connections.
    attr_accessor :secure

    # The HTTP open timeout in seconds (defaults to 2).
    attr_accessor :http_open_timeout

    # The HTTP read timeout in seconds (defaults to 5).
    attr_accessor :http_read_timeout

    # The hostname of your proxy server (if using a proxy)
    attr_accessor :proxy_host

    # The port of your proxy server (if using a proxy)
    attr_accessor :proxy_port

    # The username to use when logging into your proxy server (if using a proxy)
    attr_accessor :proxy_user

    # The password to use when logging into your proxy server (if using a proxy)
    attr_accessor :proxy_pass

    # The logger used by WhoopsNotifier
    attr_accessor :logger


    alias_method :secure?, :secure

    def initialize
      @secure                   = false
      @host                     = nil
      @http_open_timeout        = 2
      @http_read_timeout        = 5
    end

    # Allows config options to be read like a hash
    #
    # @param [Symbol] option Key for a given attribute
    def [](option)
      send(option)
    end

    # Returns a hash of all configurable options
    def to_hash
      OPTIONS.inject({}) do |hash, option|
        hash.merge(option.to_sym => send(option))
      end
    end

    # Returns a hash of all configurable options merged with +hash+
    #
    # @param [Hash] hash A set of configuration options that will take precedence over the defaults
    def merge(hash)
      to_hash.merge(hash)
    end

    def port
      @port || default_port
    end

    def protocol
      if secure?
        'https'
      else
        'http'
      end
    end

    private

    def default_port
      if secure?
        443
      else
        80
      end
    end

  end

end