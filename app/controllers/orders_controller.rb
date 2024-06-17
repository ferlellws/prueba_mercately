class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy add decrease add_from_input checkout]

  # GET /orders or /orders.json
  def index
    @orders = Order.includes(:order_items).where(checked_out: true)
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to @order, notice: "Orden completamente eliminada" }
      format.json { head :no_content }
    end
  end

  def add
    @product = Product.find_by(id: params[:product_id])
    @current_order_item = @order.order_items.find_by(product_id: @product.id)
    quantity = params[:quantity]

    if @current_order_item.present? && quantity.to_i.positive?
      @current_quantity = @current_order_item.quantity + quantity.to_i
      @current_order_item.update(quantity: @current_quantity)
    else
      @current_quantity = quantity
      @order.order_items.create(product: @product, quantity: quantity.to_i)
    end
  end

  def decrease
    @product = Product.find_by(id: params[:product_id])
    @current_order_item = @order.order_items.find_by(product_id: @product.id)
    quantity = params[:quantity]

    if @current_order_item.present? && quantity.to_i.positive?
      @current_quantity = @current_order_item.quantity - quantity.to_i
      if @current_quantity.to_i <= 0
        @current_order_item.destroy
      else
        @current_order_item.update(quantity: @current_quantity)
      end
    else
      @current_quantity = quantity
      @order.order_items.create(product: @product, quantity: quantity.to_i)
    end
  end

  def add_from_input
    @product = Product.find_by(id: params[:product_id])
    @current_order_item = @order.order_items.find_by(product_id: @product.id)
    quantity = params[:quantity]

    if @current_order_item.present? && quantity.to_i.positive?
      @current_quantity = quantity.to_i
      @current_order_item.update(quantity: @current_quantity)
    elsif quantity.to_i <= 0
      @current_order_item.destroy
    else
      @current_quantity = quantity
      @order.order_items.create(product: @product, quantity: quantity.to_i)
    end
  end

  def checkout
    @order.update(checked_out: true)

    # Redirigir o realizar otras acciones después de hacer checkout
    redirect_to root_url, notice: 'La orden ha sido completada exitosamente.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:checked_out)
  end
end
