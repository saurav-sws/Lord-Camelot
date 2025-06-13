import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../models/news_model.dart';
import '../../../../services/api_service.dart';
import '../../../utils/dialog_helper.dart';

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
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        news.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade800),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (news.image.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              news.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey.shade800,
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 200,
                                  color: Colors.grey.shade800,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF288c25),
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 16),
                        Text(
                          '${'posted_on'.tr}: ${news.createdAt}',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        _buildHtmlContent(news.description),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
