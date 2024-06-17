require 'application_system_test_case'

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test 'visiting the index' do
    visit products_url
    assert_selector 'h1', text: 'Productos'

    # Encuentra todos los elementos con la clase 'card-product'
    card_products = all('.card-product')

    # Verifica la cantidad de elementos 'card-product'
    assert_equal 4, card_products.count

    # Para depuración, imprimir la cantidad de elementos encontrados
    puts "Number of card products: #{card_products.count}"
  end

  test 'should create product' do
    visit products_url
    click_on 'Nuevo producto'

    fill_in 'Nombre', with: @product.name
    fill_in 'Precio', with: @product.price
    click_on 'Create Product'

    assert_text 'Product was successfully created'
    click_on 'Ir a productos'
  end

  test 'should update Product' do
    visit product_url(@product)
    click_on 'Editar este producto', match: :first

    fill_in 'Nombre', with: @product.name
    fill_in 'Precio', with: @product.price
    click_on 'Update Producto'

    assert_text 'Product was successfully updated'
    click_on 'Ir a productos'
  end

  test 'should destroy Product' do
    visit product_url(products(:four))
    click_on 'Eliminar este producto', match: :first

    assert_text 'Product was successfully destroyed'
  end

  test 'should add product to cart' do
    visit products_url
    find("button#add-to-cart-button-#{@product.id}").click
  end
end
