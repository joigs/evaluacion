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



  def destroy_records
    @cmpc = Cmpc.find(params[:id])
    ids  = params[:ids] || []

    ActiveRecord::Base.transaction do
      deleted = @cmpc.cmpc_records.where(id: ids).delete_all
      @cmpc.decrement!(:numero_servicios, deleted)
      @cmpc.decrement!(:total_uf,           @cmpc.suma * deleted)
    end

    @cmpc.reload
    @cmpc.cmpc_records.reload

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @cmpc, notice: "#{deleted} registros eliminados" }
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
