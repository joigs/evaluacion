require "bigdecimal"

class InformesController < ApplicationController
  before_action :set_informe,     only: [:show, :edit, :update, :destroy]
  before_action :authorize_user
  before_action :load_mandantes,  only: [:new, :edit, :create, :update]

  MANDANTE_RUT_N_CORTE = "85805200".freeze
  DIA_CORTE            = 25

  def index
    @months = %w[Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre]
    @years  = (2025..Date.current.year).to_a.reverse

    sel_month = (params[:month] || Date.current.month).to_i
    sel_year  = (params[:year]  || Date.current.year).to_i

    sel_month = 1    unless (1..12).cover?(sel_month)
    sel_year  = 2025 if sel_year < 2025

    @selected_month = sel_month
    @selected_year  = sel_year

    @informes = Informe.where(month: sel_month, year: sel_year)
                       .order(:mandante_nombre)

    iva     = Iva.find_by(year: sel_year, month: sel_month)
    @uf_mes = iva ? BigDecimal(iva.valor.to_s) : nil
  end

  def show
    iva = Iva.find_by(year: @informe.year, month: @informe.month)

    @total_clp   = iva ? (@informe.total * BigDecimal(iva.valor.to_s)).round(0) : nil
    @iva_missing = iva.nil?
  end

  def new
    @informe = Informe.new(n_informes: nil, valor_unitario: nil, total: nil)
  end

  def create
    @informe = Informe.new(informe_params)
    @informe.mandante_nombre = resolve_mandante_nombre(@informe.mandante_rut)

    ajustar_fecha_por_corte!(@informe)

    if @informe.save
      redirect_to @informe, notice: "Registro creado con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @informe.assign_attributes(informe_params)
    @informe.mandante_nombre = resolve_mandante_nombre(@informe.mandante_rut)

    ajustar_fecha_por_corte!(@informe)

    if @informe.save
      redirect_to @informe, notice: "Informe actualizado con éxito."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @informe.destroy
    redirect_to informes_path, notice: "Informe eliminado con éxito."
  end

  def refresh_mandantes
    data = RegistroMandantesApi::Client.new.refresh!
    render json: { data: data }, status: :ok
  rescue RegistroMandantesApi::Error => e
    Rails.logger.error("[Informes] refresh mandantes falló: #{e.class} #{e.message}")
    render json: { error: "No se pudo actualizar la lista." }, status: :service_unavailable
  end

  private

  def set_informe
    @informe = Informe.find(params[:id])
  end

  def informe_params
    params.require(:informe).permit(:mandante_rut, :fecha, :n_informes, :valor_unitario)
  end

  def load_mandantes
    @mandantes       = RegistroMandantesApi::Client.new.mandantes
    @mandantes_error = nil
  rescue RegistroMandantesApi::Error => e
    Rails.logger.error("[Informes] mandantes no disponibles: #{e.class} #{e.message}")
    @mandantes       = []
    @mandantes_error = "No se pudo obtener la lista de empresas mandantes."
  end

  def resolve_mandante_nombre(rut)
    rut = rut.to_s.strip
    return nil if rut.blank?

    encontrado = find_mandante(rut)
    return encontrado["nombre"] if encontrado

    params.dig(:informe, :mandante_nombre_fallback).to_s.strip.presence
  end

  def find_mandante(rut)
    rut = rut.to_s.strip
    return nil if rut.blank?

    (@mandantes || []).find { |m| m["rut"].to_s.strip == rut }
  end

  def ajustar_fecha_por_corte!(informe)
    return if informe.fecha.blank?
    return if informe.fecha.day <= DIA_CORTE

    mandante = find_mandante(informe.mandante_rut)
    return if mandante.nil?
    return unless mandante["rut_n"].to_s.strip == MANDANTE_RUT_N_CORTE

    informe.fecha = informe.fecha.next_month.beginning_of_month
  end

  def authorize_user
    authorize!
  end
end
