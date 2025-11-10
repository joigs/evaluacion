# app/controllers/api/v1/facturacions_controller.rb

module Api
  module V1
    class FacturacionsController < ApplicationController
      skip_before_action :protect_pages
      before_action :authenticate_api_key!

      # GET /api/v1/facturacions
      def index

        year  = params[:year].present?  ? params[:year].to_i  : Date.current.year

        full_year =  params[:month].to_s == 'all'

        if full_year
          start_date = Date.new(year, 1, 1)
          end_date   = Date.new(year, 12, 31)
          Rails.logger.info "CMPCCHECK full_year=true year=#{year.inspect}"

          facturacions =
            Facturacion
              .where.not(oc: nil)
              .where(fecha_inspeccion: start_date..end_date)
              .distinct

          current_oxy  = Oxy.includes(:oxy_records).where(year: year).order(:month)
          current_cmpc = Cmpc.includes(:cmpc_records).where(year: year).order(:month)

          current_ald_records = Ald.where(year: year).order(:month)
          ivas_by_month = Iva.where(year: year).pluck(:month, :valor).to_h
          current_ald = current_ald_records.map { |ald|
            uf_val = ivas_by_month[ald.month]
            ald_payload(ald, uf_val)
          }

          otros        = Otro.includes(:empresa).where(year: year).order(:month)

          render json: {
            facturacions: facturacions.as_json,
            current_oxy:  current_oxy.as_json(include: :oxy_records),
            current_cmpc: current_cmpc.as_json(include: :cmpc_records),
            current_ald:  current_ald, # ya viene con payload enriquecido
            otros:        otros.as_json(include: { empresa: { only: [:nombre] } })
          }

        else

          month = params[:month].present? ? params[:month].to_i : Date.current.month
          start_date = Date.new(year, month, 1)
          end_date   = start_date.end_of_month

          facturacions =
            Facturacion
              .where.not(oc: nil)
              .where(fecha_inspeccion: start_date..end_date)
              .distinct

          current_oxy = Oxy
                          .includes(:oxy_records)
                          .find_by(month: month, year: year)

          current_cmpc = Cmpc
                           .includes(:cmpc_records)
                           .find_by(month: month, year: year)

          # === ALD: solo cambios aquí ===
          current_ald_record = Ald.find_by(month: month, year: year)
          uf_val = Iva.find_by(year: year, month: month)&.valor
          current_ald = current_ald_record ? ald_payload(current_ald_record, uf_val) : nil
          # === fin cambios ALD ===

          otros = Otro
                    .includes(:empresa)
                    .where(month: month, year: year)

          render json: {
            facturacions: facturacions.as_json,
            current_oxy:  current_oxy.as_json(include: :oxy_records),
            current_cmpc: current_cmpc.as_json(include: :cmpc_records),
            current_ald:  current_ald,
            otros:        otros.as_json(include: { empresa: { only: [:nombre] } })
          }
        end

      end



      private

      def ald_payload(ald, uf_valor)
        v1_uf = Ald::V1
        v2_uf = Ald::V2

        uf    = uf_valor ? BigDecimal(uf_valor.to_s) : nil
        n1    = BigDecimal(ald.n1.to_s)
        n2    = BigDecimal(ald.n2.to_s)
        pesos = BigDecimal(ald.total_pesos.to_s)

        total_clp =
          if uf
            (((v1_uf * n1 + v2_uf * n2) * uf) + pesos)
              .round(0, BigDecimal::ROUND_HALF_UP).to_i
          else
            nil
          end

        {
          **ald.as_json.symbolize_keys,
          v1_uf:       v1_uf.to_s('F'),
          v1_clp:      uf ? (v1_uf * uf).round(0, BigDecimal::ROUND_HALF_UP).to_i : nil,
          v2_uf:       v2_uf.to_s('F'),
          v2_clp:      uf ? (v2_uf * uf).round(0, BigDecimal::ROUND_HALF_UP).to_i : nil,
          total_clp:   total_clp,
          iva_missing: uf.nil?
        }
      end

      def authenticate_api_key!
        provided_key = request.headers['X-API-KEY'] || params[:api_key]
        expected_key = ENV['EVALUACION_API_KEY']

        Rails.logger.warn "[API_KEY] provided=#{provided_key.inspect}(#{provided_key&.bytesize}) "\
                            "expected=#{expected_key.inspect}(#{expected_key&.bytesize})"

        unless provided_key.present? &&
          expected_key.present? &&
          provided_key.bytesize == expected_key.bytesize &&
          ActiveSupport::SecurityUtils.secure_compare(provided_key, expected_key)
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

    end
  end
end
