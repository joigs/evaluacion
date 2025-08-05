class HomeController < ApplicationController
  def index
    @user = Current.user

    @facturacions  = Facturacion.where.not(number: 0).order(number: :desc)
    @notifications = current_notifications

    today = Date.current
    prev  = today.prev_month

    @current_oxy = Oxy.find_by(month: today.month,  year: today.year)
    @current_cmpc = Cmpc.find_by(month: today.month,  year: today.year)

    @current_ald = Ald.find_by(month: today.month,  year: today.year)
    @prev_ald    = Ald.find_by(month: prev.month,   year: prev.year)

    missing_prev = @prev_ald.nil?
    missing_curr = @current_ald.nil?
    last_day     = today == today.end_of_month

    puts("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")
    puts(@current_oxy.inspect)
    puts(@current_cmpc.inspect)
    @show_ald_alert   = false
    @ald_missing_date = nil

    if last_day && missing_curr
      @show_ald_alert   = true
      @ald_missing_date = today
    elsif missing_prev
      @show_ald_alert   = true
      @ald_missing_date = prev
    end
    @last_day_of_month = today == today.end_of_month
    @show_ald_alert   = @ald_missing_date.present?
    @ald_alert_month  = @ald_missing_date&.month
    @ald_alert_year   = @ald_missing_date&.year
    @last_ald_record = Ald.order(year: :desc, month: :desc).first
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
