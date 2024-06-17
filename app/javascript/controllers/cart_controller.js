import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cart"
export default class extends Controller {
  static values = {
    productId: Number,
    action: String,
    orderId: Number
  }

  connect() { }

  async add(event) {
    event.preventDefault()

    const productId = this.productIdValue
    const action = this.actionValue
    const orderId = this.orderIdValue

    let quantity = 1
    if (action) {
      quantity = event.target.value
    }

    if (quantity <= 0) {
      let response = confirm("¿Estas seguro de que deseas borrar este producto?")
      if (!response) {
        return
      }
    }

    try {
      const response = await fetch(`/orders/${orderId}/${action ? action : "add"}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content') // si usas Rails con CSRF
        },
        body: JSON.stringify({
          product_id: productId,
          quantity: quantity
        })
      })

      if (quantity <= 0) {
        window.location.reload()
        return
      }

      if (response.ok) {
        const html = await response.text();

        Turbo.renderStreamMessage(html); // Renderizar el mensaje Turbo
      } else {
        throw new Error('Network response was not ok');
      }
    } catch (error) {
      console.error('Error:', error)
    }
  }

  async decrease(event) {
    event.preventDefault();

    const productId = this.productIdValue;
    const orderId = this.orderIdValue;
    const action = "decrease"; // Puedes usar esta acción para diferenciar entre sumar y restar en el controlador del servidor

    let quantity = 1; // Decrementa en 1
    const inputElement = document.getElementById(`input_product_${productId}`);
    if (inputElement && inputElement.value <= 1) {
      let response = confirm("¿Estas seguro de que deseas borrar este producto?")
      if (!response) {
        return
      }
    }

    try {
      const response = await fetch(`/orders/${orderId}/${action}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content') // si usas Rails con CSRF
        },
        body: JSON.stringify({
          product_id: productId,
          quantity: quantity
        })
      });

      if (inputElement && inputElement.value <= 1) {
        window.location.reload()
        return
      }

      if (response.ok) {
        const html = await response.text();

        Turbo.renderStreamMessage(html); // Renderizar el mensaje Turbo
      } else {
        throw new Error('Network response was not ok');
      }
    } catch (error) {
      console.error('Error:', error);
    }
  }


  updateCartCount(productId) {
    const cart = JSON.parse(localStorage.getItem("cart")) || []
    const product = cart.find(item => item.id === productId)
    const count = product ? product.quantity : 0
    const counterElement = document.getElementById(`counter-${productId}`)
    if (counterElement) {
      counterElement.textContent = count
      counterElement.classList.toggle("hidden", count === 0)
    }
  }

  updateAllCounters() {
    const cart = JSON.parse(localStorage.getItem("cart")) || []
    cart.forEach(item => {
      const counterElement = document.getElementById(`counter-${item.id}`)
      if (counterElement) {
        counterElement.textContent = item.quantity
        counterElement.classList.toggle("hidden", item.quantity === 0)
      }
    })
  }
}
