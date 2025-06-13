import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/news_controller.dart';
import '../../../models/news_model.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsController = Get.put(NewsController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 0.8,
            colors: [Color(0xFF001e16), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: ResponsiveSize.height(20)),
              Container(
                height: ResponsiveSize.height(70),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    'news'.tr,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(20)),
              Expanded(
                child: Obx(() {
                  if (newsController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF288c25),
                      ),
                    );
                  } else if (newsController.hasError.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: ResponsiveSize.width(60),
                          ),
                          SizedBox(height: ResponsiveSize.height(16)),
                          Text(
                            newsController.errorMessage.value,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(16),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveSize.height(24)),
                          ElevatedButton(
                            onPressed: () => newsController.fetchNews(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF227522),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.radius(10),
                                ),
                              ),
                            ),
                            child: Text(
                              'try_again'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveSize.fontSize(14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (newsController.newsList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.newspaper,
                            color: Colors.grey,
                            size: ResponsiveSize.width(60),
                          ),
                          SizedBox(height: ResponsiveSize.height(16)),
                          Text(
                            'no_news'.tr,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(16),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () => newsController.fetchNews(),
                      color: Color(0xFF288c25),
                      backgroundColor: Color(0xFF1E1E1E),
                      child: ListView.builder(
                        padding: ResponsiveSize.padding(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: newsController.newsList.length,
                        itemBuilder: (context, index) {
                          final news = newsController.newsList[index];
                          return _buildNewsCard(news, newsController);
                        },
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCard(News news, NewsController controller) {
    return GestureDetector(
      onTap: () => controller.showNewsDetail(news),
      child: Container(
        margin: ResponsiveSize.margin(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
          border: Border.all(color: Color(0xFF1E1E1E)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveSize.radius(12)),
                  topRight: Radius.circular(ResponsiveSize.radius(12)),
                ),
                child: Image.network(
                  news.image,
                  width: double.infinity,
                  height: ResponsiveSize.height(180),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: ResponsiveSize.height(180),
                      color: Colors.grey.shade800,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: ResponsiveSize.width(40),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: ResponsiveSize.padding(all: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveSize.height(8)),
                  Text(
                    _getPlainText(news.description),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(14),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveSize.height(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'posted_on'.tr}: ${news.createdAt}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ResponsiveSize.fontSize(12),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF288c25),
                        size: ResponsiveSize.width(20),
                      ),
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  String _getPlainText(String htmlString) {

    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
