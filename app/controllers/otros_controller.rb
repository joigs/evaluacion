class OtrosController < ApplicationController
  before_action :set_otro, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user

  # GET /otros
  def index
    @months = %w[Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre]
    @years  = (2025..Date.current.year).to_a.reverse

    sel_month = (params[:month] || Date.current.month).to_i
    sel_year  = (params[:year]  || Date.current.year).to_i

    sel_month = 1  unless (1..12).cover?(sel_month)
    sel_year  = 2025 if sel_year < 2025

    @selected_month = sel_month
    @selected_year  = sel_year

    @otros = Otro
               .includes(:empresa)
               .where(month: sel_month, year: sel_year)
               .order("empresas.nombre")
  end


  # GET /otros/1
  def show
    @otro = Otro.find(params[:id])

    iva = Iva.find_by(year: @otro.year, month: @otro.month)

    @v1_uf     = @otro.v1
    @v1_clp    = iva ? (@otro.v1 * iva.valor).round(0) : nil
    @total_clp   = iva ? (@otro.total * iva.valor).round(0) : nil
    @iva_missing = iva.nil?

    @empresa_nombre = @otro.empresa&.nombre || "—"
  end

  # GET /otros/new
  def new
    @otro = Otro.new
  end

  def create
    empresa_nombre = params[:otro].delete(:empresa_nombre_hidden).to_s.strip

    empresa = Empresa.find_or_create_by(nombre: empresa_nombre) if empresa_nombre.present?

    @otro = Otro.new(otro_params)
    @otro.empresa = empresa if empresa

    if @otro.save
      redirect_to @otro, notice: "Registro creado con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end



  # GET /otros/1/edit
  def edit; end

  # POST /otros


  # PATCH/PUT /otros/1
  def update
    if @otro.update(otro_params)
      redirect_to @otro, notice: "Otro actualizado con éxito."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /otros/1
  def destroy
    @otro.destroy
    redirect_to otros_path, notice: "Otro eliminado con éxito."
  end

  private

  def set_otro
    @otro = Otro.find(params[:id])
  end

  def otro_params
    params.require(:otro).permit(:n1, :t_pesos, :v1, :fecha)
  end

  def authorize_user
    authorize!
  end
end
