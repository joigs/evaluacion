class OxiesController < ApplicationController
  before_action :block_if_current_exists, only: %i[new create]

  def new
    hoy   = Time.zone.today
    @oxy  = Oxy.new(month: hoy.month, year: hoy.year)

    ultimo_oxy_distinto = Oxy
                            .where.not(month: hoy.month, year: hoy.year)
                            .order(year: :desc, month: :desc)
                            .first

    ultimo_oxy = ultimo_oxy_distinto || Oxy.order(created_at: :desc).first

    if ultimo_oxy.present?
      @oxy.numero_conductores = ultimo_oxy.numero_conductores
      @oxy.total_uf           = ultimo_oxy.total_uf
    end
  end



  def create
    p = params.require(:oxy)
              .permit(:month, :year, :suma,
                      :numero_conductores, :conductores_eliminados)

    eliminados = p[:conductores_eliminados].to_i
    @oxy      = Oxy.new(p)

    if p[:numero_conductores].blank?
      @oxy.errors.add(:numero_conductores,
                      "no se ingresó el número de conductores del mes pasado")
    else
      calculado = p[:numero_conductores].to_i - eliminados
      @oxy.numero_conductores = calculado

      if calculado.negative?
        @oxy.errors.add(:numero_conductores,
                        "el resultado sería negativo. Revisa los valores.")
      end
    end

    @oxy.valid?

    if @oxy.errors.any?
      flash.now[:alert] = "Hay campos obligatorios sin completar."
      render :new, status: :unprocessable_entity
    else
      @oxy.total_uf = @oxy.suma * @oxy.numero_conductores.to_f
      @oxy.save
      redirect_to home_path, notice: "Registro creado correctamente"
    end
  end


  def show
    @oxy = Oxy.includes(:oxy_records).find(params[:id])
  end


  def add_records
    @oxy  = Oxy.find(params[:id])
    count = params[:cantidad].to_i
    fecha = Date.parse(params[:fecha])



    ActiveRecord::Base.transaction do
      count.times { @oxy.oxy_records.create!(fecha: fecha) }
      @oxy.increment!(:numero_conductores,  count)
      @oxy.increment!(:total_uf,            @oxy.suma * count)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @oxy, notice: "#{count} registros añadidos" }
    end
  rescue => e
    flash.now[:alert] = e.message
    render :show, status: :unprocessable_entity
  end

  private

  def oxy
    @oxy = Oxy.find(params[:id])

  end


  def oxy_params
    params.require(:oxy).permit(:month, :year, :numero_conductores, :suma, :total_uf, :conductores_eliminados)
  end


  def block_if_current_exists
    if Oxy.exists?(month: Date.current.month, year: Date.current.year)
      redirect_to home_path,
                  alert: "Ya existe un registro Oxy para " \
                    "#{I18n.l Date.current, format: '%B %Y'}."
    end
  end
end
