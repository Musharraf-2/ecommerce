paypal.Buttons({
  env: 'sandbox',
  createOrder: async () => {
    const response = await fetch('order/new', {method: 'GET'});
    const responseData = await response.json();
    return responseData.token;
  },
  onApprove: async (data) => {
    const response = await fetch('/order', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({order_id: data.orderID})
     });
  const responseData = await response.json();
     if (responseData.status === 'COMPLETED') {
    alert('Thanks for payment. You can close this window now.');
  }
  }
}).render('#paypal-button-container');
