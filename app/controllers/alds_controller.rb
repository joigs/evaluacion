class AldsController < ApplicationController
  before_action :set_ald, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user

  # GET /alds
  def index
    @alds = Ald.order(year: :desc, month: :desc)



    if params[:year].present?
      y = params[:year].to_i
      @alds = @alds.where(year: y)
    end

    if params[:month].present?
      m = params[:month].to_i
      if (1..12).cover?(m)
        @alds = @alds.where(month: m)
      else
        flash[:alert] = "Mes inválido."
      end
    end
  end

  # GET /alds/1
  def show
    @ald = Ald.find(params[:id])

    # UF para el período
    iva = Iva.find_by(year: @ald.year, month: @ald.month)

    @v1_uf      = Ald::V1
    @v1_clp     = iva ? (@v1_uf * iva.valor).round(0) : nil
    @v2_uf      = Ald::V2
    @v2_clp     = iva ? (@v2_uf * iva.valor).round(0) : nil
    @total_clp  = iva ? (@ald.total * iva.valor).round(0) : nil
    @iva_missing = iva.nil?
  end
  # GET /alds/new
  def new
    if params[:month].present? && params[:year].present?
      target = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      target = Date.current
    end

    @ald = Ald.new(month: target.month, year: target.year)
  end


  def create
    @ald = Ald.new(ald_params)
    if @ald.save
      redirect_to @ald, notice: "ALD creado con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end


  # GET /alds/1/edit
  def edit; end

  # POST /alds

  # PATCH/PUT /alds/1
  def update
    if @ald.update(ald_params)
      redirect_to @ald, notice: "ALD actualizado con éxito."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /alds/1
  def destroy
    @ald.destroy
    redirect_to alds_path, notice: "ALD eliminado con éxito."
  end

  private

  def set_ald
    @ald = Ald.find(params[:id])
  end

  def ald_params
    params.require(:ald).permit(:month, :year, :n1, :n2, :t_pesos)
  end

  def authorize_user
    authorize!
  end
end
