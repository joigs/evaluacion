class HomeController < ApplicationController

  def index
    @user = Current.user





    @facturacions = Facturacion.order(number: :desc)
    @facturacions = @facturacions.where.not(number: 0)

    @notifications = current_notifications

  end


  private

  def current_notifications
    notifications = []

    if Current.user.cotizar
      notifications += Notification.joins(:facturacions)
                                   .where(notification_type: [:solicitud_pendiente, :factura_pendiente])
                                   .distinct
    end

    if Current.user.solicitar
      notifications += Notification.joins(:facturacions)
                                   .where(notification_type: :entrega_pendiente)
                                   .distinct
    end

    notifications.uniq
  end
end
