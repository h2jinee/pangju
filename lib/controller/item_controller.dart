import 'package:get/get.dart';
import 'package:pangju/service/api_service.dart';

class ItemController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var hasMoreItems = true.obs;
  var currentPage = 1;
  final int itemsPerPage = 15;

  void fetchItems() async {
    if (!hasMoreItems.value || isLoading.value) return;

    isLoading.value = true;

    try {
      List<Map<String, dynamic>> newItems =
          await ApiService.fetchItems(currentPage, itemsPerPage);
      if (newItems.isEmpty) {
        hasMoreItems.value = false;
      } else {
        items.addAll(newItems);
        currentPage++;
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void resetItems() {
    items.clear();
    isLoading.value = false;
    hasMoreItems.value = true;
    currentPage = 1;
    fetchItems();
  }
}
