require "net/http"
require "json"

module RegistroMandantesApi
  class Error < StandardError; end
  class Unauthorized < Error; end
  class Unavailable < Error; end

  class Client
    def initialize(config = RegistroMandantesApi.config)
      @config = config
    end

    def mandantes(q: nil, cached: true)
      return fetch(q: q) unless cached && @config.cache_ttl.positive?

      Rails.cache.fetch(cache_key(q), expires_in: @config.cache_ttl) { fetch(q: q) }
    end

    def refresh!(q: nil)
      data = fetch(q: q)

      if @config.cache_ttl.positive?
        Rails.cache.write(cache_key(q), data, expires_in: @config.cache_ttl)
      end

      data
    end

    private

    def fetch(q: nil)
      raise Error, "Configuración incompleta" unless @config.configured?

      uri = @config.endpoint_url
      uri.query = URI.encode_www_form(q: q) if q.present?

      request = Net::HTTP::Get.new(uri)
      request["X-Registro-Api-Key"] = @config.api_key
      request["Accept"] = "application/json"

      response = Net::HTTP.start(
        uri.hostname, uri.port,
        use_ssl:      uri.scheme == "https",
        open_timeout: @config.open_timeout,
        read_timeout: @config.read_timeout
      ) { |http| http.request(request) }

      case response
      when Net::HTTPSuccess    then JSON.parse(response.body).fetch("data", [])
      when Net::HTTPUnauthorized then raise Unauthorized, "API key inválida"
      else raise Unavailable, "HTTP #{response.code}"
      end
    rescue JSON::ParserError => e
      raise Error, "Respuesta inválida: #{e.message}"
    rescue Timeout::Error, SystemCallError, IOError => e
      raise Unavailable, e.message
    end

    def cache_key(q)
      ["registro_mandantes", q.presence || "all"].join(":")
    end
  end
end