import 'package:get/get.dart';
import 'package:udemy_provider/models/product.dart';
import '../controllers/auth.dart';
import '../controllers/cartController.dart';
import '../controllers/orderController.dart';
import '../controllers/productController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Auth>(Auth());
    Get.put<CartController>(CartController());
    Get.put<OrderController>(OrderController(Auth.to.token));
    Get.put<ProductController>(ProductController(Auth.to.token, Auth.to.userId));
    Get.put<Product>(Product());
  }
}
