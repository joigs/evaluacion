# app/controllers/api/v1/facturacions_controller.rb

module Api
  module V1
    class FacturacionsController < ApplicationController
      skip_before_action :protect_pages
      before_action :authenticate_api_key!

      # GET /api/v1/facturacions
      def index

        year  = params[:year].present?  ? params[:year].to_i  : Date.current.year
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

        current_ald = Ald
                        .find_by(month: month, year: year)

        otros = Otro
                  .includes(:empresa)
                  .where(month: month, year: year)

        render json: {
          facturacions: facturacions.as_json,
          current_oxy:  current_oxy.as_json(include: :oxy_records),
          current_ald:  current_ald&.as_json(include: :empresa),
          otros:        otros.as_json(include: { empresa: { only: [:nombre] } })        }
      end



      private

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
