class PaymentApi {
  static const String baseUrl = 'https://accept.paymob.com/api';
  static const String paymentApiKey = "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TnpZM05ETXlMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkucGpQWXdEd05fbkQ5MUVvZndFSEN3WUJMekpzdGkyOW8zUjk1US1PQ1NPVm1IUWdJamtZU1NiZXhIRkROWmpDeTFxczBPajJrU0lvdzQ0SE5LZEN1aGc=";

  static const getAuthToken = '$baseUrl/auth/tokens';
  static const getOrderId = '$baseUrl/ecommerce/orders';
  static const getPaymentRequest = '$baseUrl/acceptance/payment_keys';

  static const getRefCode = '$baseUrl/acceptance/payments/pay';
  static String visaUrl = '$baseUrl/acceptance/iframes/756520?payment_token=$finalToken';

  static String paymentFirstToken = '';
  static String paymentOrderId = '';
  static String finalToken = '';
  static String refCode = '';

  static const String integrationIdCard = '3768166';
  static const String integrationIdKiosk = '3768196';
}


class PaymentImages {
  static const String refCodeImage =
      "https://cdn-icons-png.flaticon.com/128/4090/4090458.png";
  static const String visaImage =
      "https://cdn-icons-png.flaticon.com/128/349/349221.png";
}