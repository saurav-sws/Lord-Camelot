import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../models/news_model.dart';
import '../../../../services/api_service.dart';
import '../../../utils/dialog_helper.dart';
import '../../../routes/app_pages.dart';

class NewsController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<News> newsList = <News>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final response = await _apiService.getNews();

      if (response['success'] == true && response['news'] != null) {
        final List<dynamic> newsData = response['news'];
        newsList.value = newsData.map((item) => News.fromJson(item)).toList();

        if (newsList.isEmpty) {
          hasError.value = true;
          errorMessage.value = 'no_news'.tr;
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'news_error'.tr;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value =
          '${'news_error'.tr}: ${e.toString().replaceAll('Exception: ', '')}';
      print('Error fetching news: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showNewsDetail(News news) {
    Get.toNamed(Routes.NEWS_DETAIL, arguments: news);
  }

  Widget _buildHtmlContent(String htmlContent) {
    return Html(
      data: htmlContent,
      style: {
        "body": Style(
          color: Colors.white,
          fontSize: FontSize(16),
          fontFamily: 'Roboto',
        ),
        "p": Style(margin: Margins.only(bottom: 16)),
        "a": Style(
          color: Colors.green,
          textDecoration: TextDecoration.underline,
        ),
      },
    );
  }
}
