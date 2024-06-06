# frozen_string_literal: true

Redis.exists_returns_integer = false
class RedisConfig
  RAILS_ENV = ENV['RAILS_ENV'] || 'development'
  REDIS_PROVIDER_URL = ENV[ENV['REDIS_PROVIDER'] || 'REDIS_URL']

  class << self
    def client
      @client ||= begin
        if test?
          MockRedis.new
        elsif REDIS_PROVIDER_URL
          Redis.new(url: REDIS_PROVIDER_URL)
        elsif development?
          Redis.new(host: 'localhost', port: 6379)
        else
          raise 'Could not find a suitable Redis for this environment!'
        end
      end
    end

    private

    def development?
      RAILS_ENV == 'development'
    end

    def test?
      RAILS_ENV == 'test'
    end
  end
end
