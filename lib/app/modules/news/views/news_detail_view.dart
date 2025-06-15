import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../utils/responsive_size.dart';
import '../../../models/news_model.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final News news = Get.arguments as News;

    // Format the date
    String formattedDate = '';
    try {
      final DateTime date = DateTime.parse(news.createdAt);
      formattedDate =
          '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      formattedDate = news.createdAt;
    }

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
              // Custom App Bar
              Container(
                padding: ResponsiveSize.padding(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white70,
                        size: ResponsiveSize.width(24),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'news'.tr,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: ResponsiveSize.fontSize(18),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveSize.width(48),
                    ), // Balance the back button
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ResponsiveSize.padding(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date
                        Container(
                          padding: ResponsiveSize.padding(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[600]?.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.radius(8),
                            ),
                            border: Border.all(
                              color: Colors.amber[600]!,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${'posted_on'.tr}: $formattedDate',
                            style: TextStyle(
                              color: Colors.amber[600],
                              fontSize: ResponsiveSize.fontSize(14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: ResponsiveSize.height(20)),

                        // Title
                        Text(
                          news.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveSize.fontSize(22),
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),

                        SizedBox(height: ResponsiveSize.height(20)),

                        // Image
                        if (news.image.isNotEmpty)
                          Container(
                            margin: ResponsiveSize.margin(bottom: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.radius(12),
                              ),
                              child: Image.network(
                                news.image,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: ResponsiveSize.height(200),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveSize.radius(12),
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported,
                                            color: Colors.white54,
                                            size: ResponsiveSize.width(50),
                                          ),
                                          SizedBox(
                                            height: ResponsiveSize.height(8),
                                          ),
                                          Text(
                                            'Image not available',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: ResponsiveSize.fontSize(
                                                14,
                                              ),
                                            ),
                                          ),
                                        ],
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
                                    height: ResponsiveSize.height(200),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveSize.radius(12),
                                      ),
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF288c25),
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
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
                          ),

                        // Content
                        Container(
                          padding: ResponsiveSize.padding(all: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF0f0f0f),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.radius(12),
                            ),
                          ),
                          child: _buildHtmlContent(news.description),
                        ),

                        SizedBox(height: ResponsiveSize.height(30)),
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
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "p": Style(
          margin: Margins.only(bottom: 16),
          color: Colors.white70,
          fontSize: FontSize(16),
          lineHeight: LineHeight(1.5),
        ),
        "h1": Style(
          color: Colors.white,
          fontSize: FontSize(24),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 16, top: 16),
        ),
        "h2": Style(
          color: Colors.white,
          fontSize: FontSize(20),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 12, top: 16),
        ),
        "h3": Style(
          color: Colors.white,
          fontSize: FontSize(18),
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 8, top: 12),
        ),
        "a": Style(
          color: Color(0xFF288c25),
          textDecoration: TextDecoration.underline,
        ),
        "ul": Style(
          margin: Margins.only(bottom: 16),
          padding: HtmlPaddings.only(left: 20),
        ),
        "ol": Style(
          margin: Margins.only(bottom: 16),
          padding: HtmlPaddings.only(left: 20),
        ),
        "li": Style(
          color: Colors.white70,
          fontSize: FontSize(16),
          margin: Margins.only(bottom: 8),
        ),
        "strong": Style(color: Colors.white, fontWeight: FontWeight.bold),
        "b": Style(color: Colors.white, fontWeight: FontWeight.bold),
        "em": Style(color: Colors.white70, fontStyle: FontStyle.italic),
        "i": Style(color: Colors.white70, fontStyle: FontStyle.italic),
      },
    );
  }
}
