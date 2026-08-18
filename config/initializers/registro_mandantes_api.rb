module RegistroMandantesApi
  Config = Struct.new(:base_url, :api_key, :open_timeout, :read_timeout, :cache_ttl, keyword_init: true) do
    def configured?
      base_url.present? && api_key.present?
    end

    def endpoint_url
      URI.join(base_url.chomp("/") + "/", "api/v1/mandantes")
    end
  end

  def self.config
    @config ||= Config.new(
      base_url:     ENV["EVALUACION_REGISTRO_MANDANTES_BASE_URL"],
      api_key:      ENV["EVALUACION_REGISTRO_MANDANTES_API_KEY"],
      open_timeout: ENV.fetch("EVALUACION_REGISTRO_MANDANTES_OPEN_TIMEOUT", 5).to_i,
      read_timeout: ENV.fetch("EVALUACION_REGISTRO_MANDANTES_READ_TIMEOUT", 15).to_i,
      cache_ttl:    ENV.fetch("EVALUACION_REGISTRO_MANDANTES_CACHE_TTL", 3600).to_i
    )
  end
end

if Rails.env.production? && !RegistroMandantesApi.config.configured?
  Rails.logger.warn("[RegistroMandantesApi] Faltan variables de entorno de conexión con registro")
end