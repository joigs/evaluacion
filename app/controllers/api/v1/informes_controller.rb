require "bigdecimal"

module Api
  module V1
    class InformesController < ApplicationController
      skip_before_action :protect_pages
      before_action :authenticate_api_key!

      EMPRESA_LABEL = "Informes Técnicos".freeze

      # GET /api/v1/informes
      def index
        year      = params[:year].present? ? params[:year].to_i : Date.current.year
        full_year = params[:month].to_s == "all"

        month = nil
        scope = Informe.where(year: year)

        unless full_year
          month = params[:month].present? ? params[:month].to_i : Date.current.month
          month = Date.current.month unless (1..12).cover?(month)
          scope = scope.where(month: month)
        end

        informes = scope.order(:year, :month, :fecha, :mandante_nombre)

        render json: {
          empresa:  EMPRESA_LABEL,
          year:     year,
          month:    full_year ? "all" : month,
          informes: informes.map { |i| informe_payload(i) }
        }
      end

      private

      def informe_payload(informe)
        iva      = iva_for(informe.year, informe.month)
        total_uf = BigDecimal(informe.total.to_s)

        {
          id:              informe.id,
          fecha:           informe.fecha&.strftime("%Y-%m-%d"),
          month:           informe.month,
          year:            informe.year,
          mandante_rut:    informe.mandante_rut,
          mandante_nombre: informe.mandante_nombre,
          empresa:         EMPRESA_LABEL,
          n_informes:      informe.n_informes.to_i,
          valor_unitario:  informe.valor_unitario.to_s,
          total:           total_uf.to_s("F"),
          iva_missing:     iva.nil?,
          total_clp:       iva ? (total_uf * BigDecimal(iva.valor.to_s)).round(0, BigDecimal::ROUND_HALF_UP).to_i : nil
        }
      end

      def iva_for(year, month)
        @iva_cache ||= {}
        key = [year.to_i, month.to_i]
        return @iva_cache[key] if @iva_cache.key?(key)

        @iva_cache[key] = Iva.find_by(year: year, month: month)
      end

      def authenticate_api_key!
        provided_key = request.headers["X-API-KEY"] || params[:api_key]
        expected_key = ENV["EVALUACION_API_KEY"]

        unless provided_key.present? &&
               expected_key.present? &&
               provided_key.bytesize == expected_key.bytesize &&
               ActiveSupport::SecurityUtils.secure_compare(provided_key, expected_key)
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end
    end
  end
end