class CmpcsController < ApplicationController
  before_action :block_if_current_exists, only: %i[new create]

  def new
    hoy   = Time.zone.today
    @cmpc  = Cmpc.new(month: hoy.month, year: hoy.year)


  end



  def create
    p = params.require(:cmpc)
              .permit(:month, :year)

    @cmpc      = Cmpc.new(p)



    @cmpc.valid?

    if @cmpc.errors.any?
      flash.now[:alert] = "Hay campos obligatorios sin completar."
      render :new, status: :unprocessable_entity
    else

      @cmpc.save
      redirect_to home_path, notice: "Registro creado correctamente"
    end
  end


  def show
    @cmpc = Cmpc.includes(:cmpc_records).find(params[:id])
  end


  def add_records
    @cmpc  = Cmpc.find(params[:id])
    count = params[:cantidad].to_i
    fecha = Date.parse(params[:fecha])
    suma  = params[:suma].to_d

    ActiveRecord::Base.transaction do
      count.times { @cmpc.cmpc_records.create!(fecha: fecha, suma: suma) }
      @cmpc.increment!(:numero_servicios,  count)
      @cmpc.increment!(:total_uf,         suma * count)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @cmpc, notice: "#{count} registros añadidos" }
    end
  rescue => e
    flash.now[:alert] = e.message
    render :show, status: :unprocessable_entity
  end


  def index
    @cmpcs = Cmpc.order(year: :desc, month: :desc)
  end
  # app/controllers/cmpcs_controller.rb
  def destroy_records
    @cmpc = Cmpc.find(params[:id])
    ids   = Array(params[:ids]).map(&:to_i).uniq

    if ids.blank?
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to cmpc_path(@cmpc), alert: "No seleccionaste registros." }
      end
      return
    end

    servicios_eliminados = 0
    total_uf_a_restar    = BigDecimal("0")

    Cmpc.transaction do
      registros = @cmpc.cmpc_records.where(id: ids).to_a

      registros.each do |r|
        # Si algún día agregas columna 'cantidad', la usamos; si no existe, cuenta 1 por fila.
        cantidad = r.respond_to?(:cantidad) && r.cantidad.present? ? r.cantidad.to_i : 1
        suma_dec = BigDecimal(r.suma.to_s) # nil -> 0
        servicios_eliminados += cantidad
        total_uf_a_restar    += (suma_dec * cantidad)
      end

      # Destruye con callbacks/validaciones
      registros.each(&:destroy!)

      # Actualiza totales evitando negativos
      @cmpc.numero_servicios = [@cmpc.numero_servicios - servicios_eliminados, 0].max
      @cmpc.total_uf         = [@cmpc.total_uf - total_uf_a_restar, 0].max
      @cmpc.save!
    end

    @cmpc.reload

    respond_to do |format|
      format.turbo_stream # renderiza destroy_records.turbo_stream.erb
      format.html { redirect_to cmpc_path(@cmpc), notice: "Registros eliminados correctamente." }
    end
  rescue => e
    Rails.logger.error("destroy_records error: #{e.class}: #{e.message}")
    respond_to do |format|
      # Importante: 422 para que e.detail.success sea false en Stimulus
      format.turbo_stream { head :unprocessable_entity }
      format.html { redirect_to cmpc_path(@cmpc), alert: "No se pudieron eliminar los registros." }
    end
  end






  private

  def cmpc
    @cmpc = Cmpc.find(params[:id])

  end


  def cmpc_params
    params.require(:cmpc).permit(:month, :year, :numero_servicios, :suma, :total_uf)
  end


  def block_if_current_exists
    if Cmpc.exists?(month: Date.current.month, year: Date.current.year)
      redirect_to home_path,
                  alert: "Ya existe un registro Cmpc para " \
                    "#{I18n.l Date.current, format: '%B %Y'}."
    end
  end
end
