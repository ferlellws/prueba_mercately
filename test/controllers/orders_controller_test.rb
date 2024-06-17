require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @product = products(:one)
    @order_item = order_items(:one)

    # Simula la subida de una imagen de prueba
    @image = fixture_file_upload('iphone.webp', 'image/webp')

    @product.images.attach(@image)
  end

  test 'should get index' do
    get orders_url
    assert_response :success
  end

  test 'should update order to checked_out' do
    put checkout_order_url(@order), params: { order: { checked_out: true } }
    assert_redirected_to root_url(@order)
    assert_equal 'La orden ha sido completada exitosamente.', flash[:notice]
  end

  test 'should destroy order' do
    assert_difference('Order.count', -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
    assert_equal 'Orden completamente eliminada', flash[:notice]
  end

  test 'should add product to order' do
    assert_difference("@order.order_items.count") do
      post add_order_url(@order), params: { product_id: Product.create(name: 'test', price: 10).id, quantity: 1 }
    end
  end

  test 'should add product that already exists to order' do
    assert_difference("@order.order_items.count", 0) do
      post add_order_url(@order), params: { product_id: @product.id, quantity: 2 }
    end
  end

  test 'should decrease product quantity in order' do
    assert_no_difference('@order.order_items.count') do
      post decrease_order_url(@order), params: { product_id: products(:three).id, quantity: 1 }
    end
  end

  test 'should decrease same quantity of product in order' do
    assert_difference('@order.order_items.count', -1) do
      post decrease_order_url(@order), params: { product_id: products(:three).id, quantity: 3 }
    end
  end

  test 'should add product to order from input' do
    assert_difference('@order.order_items.count', 0) do
      post add_from_input_order_url(@order), params: { product_id: @product.id, quantity: 5 }
    end

    assert_equal 5, @order.order_items.find_by(product_id: @product.id).quantity
  end

  test 'should destroy order item if quantity from input becomes zero or less' do
    assert_difference('@order.order_items.count', -1) do
      post add_from_input_order_url(@order), params: { product_id: @product.id, quantity: 0 }
    end
  end

  test 'should checkout order' do
    put checkout_order_url(@order)
    @order.reload
    assert @order.checked_out
    assert_redirected_to root_url
    assert_equal 'La orden ha sido completada exitosamente.', flash[:notice]
  end
end
