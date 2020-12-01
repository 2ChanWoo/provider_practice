import 'package:get/get.dart';
import '../controllers/auth.dart';
import '../controllers/cartController.dart';
import '../controllers/orderController.dart';
import '../controllers/productController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Auth>(Auth());
    Get.put<CartController>(CartController());
    Get.put<OrderController>(OrderController());
    Get.put<ProductController>(ProductController());
  }
}
