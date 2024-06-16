import 'package:get/get.dart';
import 'package:pangju/service/api_service.dart';
import 'package:flutter/material.dart';

class MyPageController extends GetxController {
  int selectedIndex = 0;
  int currentPage = 1;
  bool hasMoreItems = true;
  bool isLoading = false;
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> comments = [];
  List<Map<String, dynamic>> likedPosts = [];
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchMoreData();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void changeTab(int index) {
    selectedIndex = index;
    resetPagination();
    fetchInitialData();
    scrollController.jumpTo(0); // Scroll to the top
    update();
  }

  void resetPagination() {
    currentPage = 1;
    hasMoreItems = true;
    isLoading = false;
    posts.clear();
    comments.clear();
    likedPosts.clear();
  }

  void fetchInitialData() {
    switch (selectedIndex) {
      case 0:
        fetchPosts();
        break;
      case 1:
        fetchComments();
        break;
      case 2:
        fetchLikedPosts();
        break;
    }
  }

  Future<void> fetchMoreData() async {
    switch (selectedIndex) {
      case 0:
        await fetchPosts();
        break;
      case 1:
        await fetchComments();
        break;
      case 2:
        await fetchLikedPosts();
        break;
    }
  }

  Future<void> fetchPosts() async {
    isLoading = true;
    update();
    try {
      List<Map<String, dynamic>> newItems =
          await ApiService.fetchItems(currentPage, 10);
      posts.addAll(newItems);
      isLoading = false;
      currentPage++;
      if (newItems.length < 10) {
        hasMoreItems = false;
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchComments() async {
    isLoading = true;
    update();
    try {
      List<Map<String, dynamic>> newItems =
          await ApiService.fetchItems(currentPage, 10);
      comments.addAll(newItems);
      isLoading = false;
      currentPage++;
      if (newItems.length < 10) {
        hasMoreItems = false;
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchLikedPosts() async {
    isLoading = true;
    update();
    try {
      List<Map<String, dynamic>> newItems =
          await ApiService.fetchItems(currentPage, 10);
      likedPosts.addAll(newItems);
      isLoading = false;
      currentPage++;
      if (newItems.length < 10) {
        hasMoreItems = false;
      }
      update();
    } catch (e) {
      isLoading = false;
      update();
    }
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating network delay
    return {
      'profileImage': '',
      'nickname': '룰루랄라',
      'location': '서울',
      'age': 23,
      'gender': '남자',
    };
  }
}
