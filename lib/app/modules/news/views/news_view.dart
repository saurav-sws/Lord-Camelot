import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/storage_service.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/news_controller.dart';
import '../../../models/news_model.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsController = Get.put(NewsController());
    final storageService = Get.find<StorageService>();
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
        child: Padding(
          padding: ResponsiveSize.padding(vertical: 16, horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: ResponsiveSize.height(30)),
              Container(
                height: ResponsiveSize.height(80),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(
                    ResponsiveSize.radius(15),
                  ),
                ),
                child: Center(
                  child: Transform(
                    transform: Matrix4.identity()..scale(1.1),
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
              ),
              SizedBox(height: ResponsiveSize.height(30)),
              Container(
                padding: ResponsiveSize.padding(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(() {
                        String cardNumber = storageService.cardNumber;

                        return Transform(
                          transform: Matrix4.identity()..scale(1.1),
                          child: Text(
                            'card_number'.tr + ' $cardNumber',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }),
                    ),
                    SizedBox(width: ResponsiveSize.width(8)),
                    OutlinedButton(
                      onPressed: () => Get.toNamed('/profile'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF288c25)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(20),
                          ),
                        ),
                        minimumSize: Size(
                          ResponsiveSize.width(90),
                          ResponsiveSize.height(50),
                        ),
                      ),
                      child: Transform(
                        transform: Matrix4.identity()..scale(1.1),
                        child: Text(
                          'my_profile'.tr,
                          style: TextStyle(
                            color: Color(0xFF227522),
                            fontSize: ResponsiveSize.fontSize(14),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          vertical: 20,
                        ),
                        itemCount: newsController.newsList.length,
                        itemBuilder: (context, index) {
                          final news = newsController.newsList[index];
                          return Column(
                            children: [
                              _buildNewsCard(news, newsController),
                              if (index < newsController.newsList.length - 1)
                                Container(
                                  margin: ResponsiveSize.margin(vertical: 8),
                                  height: 10,

                                ),
                            ],
                          );
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
        margin: ResponsiveSize.margin(vertical: 16),
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
              padding: ResponsiveSize.padding(horizontal: 20, vertical: 20),
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
                  SizedBox(height: ResponsiveSize.height(14)),
                  Text(
                    _getPlainText(news.description),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: ResponsiveSize.fontSize(14),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveSize.height(20)),
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
