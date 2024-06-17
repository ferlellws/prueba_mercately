class ApplicationController < ActionController::Base
  before_action :initialize_order

  def initialize_order
    return if Rails.env.test?  # Evitar inicialización en entorno de prueba

    @order ||= Order.find_by(id: session[:order_id], checked_out: false)

    if @order.nil?
      @order = Order.create
      session[:order_id] = @order.id
    end
  end
end
