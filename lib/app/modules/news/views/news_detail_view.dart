import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

import '../../../utils/responsive_size.dart';
import '../../../models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final News news = Get.arguments as News;

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
                    SizedBox(width: ResponsiveSize.width(48)),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ResponsiveSize.padding(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: ResponsiveSize.margin(left: 10),
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
                        Container(
                          margin: ResponsiveSize.margin(left: 10),
                          child: SelectableText(
                            news.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveSize.fontSize(20),
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            contextMenuBuilder: (context, editableTextState) {
                              return _buildContextMenu(
                                context,
                                editableTextState,
                                news.title,
                              );
                            },
                          ),
                        ),

                        SizedBox(height: ResponsiveSize.height(20)),
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

                        Container(
                          padding: ResponsiveSize.padding(all: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF0f0f0f),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.radius(12),
                            ),
                          ),
                          child: _buildSelectableHtmlContent(news.description),
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

  Widget _buildSelectableHtmlContent(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    final textSpans = <TextSpan>[];

    _parseNode(document.body!, textSpans);

    return SelectableText.rich(
      TextSpan(children: textSpans),
      style: TextStyle(
        color: Colors.white70,
        fontSize: ResponsiveSize.fontSize(16),
        height: 1.5,
      ),
      contextMenuBuilder: (context, editableTextState) {
        return _buildContextMenu(context, editableTextState, htmlContent);
      },
      onTap: () {},
    );
  }

  void _parseNode(html_dom.Node node, List<TextSpan> textSpans) {
    if (node.nodeType == html_dom.Node.TEXT_NODE) {
      final text = node.text?.trim();
      if (text != null && text.isNotEmpty) {
        textSpans.add(
          TextSpan(text: text, style: TextStyle(color: Colors.white70)),
        );
      }
    } else if (node.nodeType == html_dom.Node.ELEMENT_NODE) {
      final element = node as html_dom.Element;

      switch (element.localName) {
        case 'h1':
          textSpans.add(TextSpan(text: '\n\n'));
          for (var child in element.nodes) {
            _parseNodeWithStyle(
              child,
              textSpans,
              TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          textSpans.add(TextSpan(text: '\n'));
          break;
        case 'h2':
          textSpans.add(TextSpan(text: '\n\n'));
          for (var child in element.nodes) {
            _parseNodeWithStyle(
              child,
              textSpans,
              TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          textSpans.add(TextSpan(text: '\n'));
          break;
        case 'h3':
          textSpans.add(TextSpan(text: '\n\n'));
          for (var child in element.nodes) {
            _parseNodeWithStyle(
              child,
              textSpans,
              TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            );
          }
          textSpans.add(TextSpan(text: '\n'));
          break;
        case 'p':
          textSpans.add(TextSpan(text: '\n\n'));
          for (var child in element.nodes) {
            _parseNode(child, textSpans);
          }
          break;
        case 'br':
          textSpans.add(TextSpan(text: '\n'));
          break;
        case 'strong':
        case 'b':
          for (var child in element.nodes) {
            _parseNodeWithStyle(
              child,
              textSpans,
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          }
          break;
        case 'em':
        case 'i':
          for (var child in element.nodes) {
            _parseNodeWithStyle(
              child,
              textSpans,
              TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
            );
          }
          break;
        case 'a':
          final href = element.attributes['href'];
          for (var child in element.nodes) {
            _parseNodeWithStyle(
              child,
              textSpans,
              TextStyle(
                color: Color(0xFF288c25),
                decoration: TextDecoration.none,
              ),
              onTap: href != null ? () => _launchUrl(href) : null,
            );
          }
          break;
        case 'ul':
        case 'ol':
          textSpans.add(TextSpan(text: '\n'));
          for (var child in element.children) {
            if (child.localName == 'li') {
              textSpans.add(TextSpan(text: '\n• '));
              for (var liChild in child.nodes) {
                _parseNode(liChild, textSpans);
              }
            }
          }
          textSpans.add(TextSpan(text: '\n'));
          break;
        default:
          for (var child in element.nodes) {
            _parseNode(child, textSpans);
          }
      }
    }
  }

  void _parseNodeWithStyle(
    html_dom.Node node,
    List<TextSpan> textSpans,
    TextStyle style, {
    VoidCallback? onTap,
  }) {
    if (node.nodeType == html_dom.Node.TEXT_NODE) {
      final text = node.text?.trim();
      if (text != null && text.isNotEmpty) {
        textSpans.add(
          TextSpan(
            text: text,
            style: style,
            recognizer:
                onTap != null ? (TapGestureRecognizer()..onTap = onTap) : null,
          ),
        );
      }
    } else if (node.nodeType == html_dom.Node.ELEMENT_NODE) {
      for (var child in node.nodes) {
        _parseNodeWithStyle(child, textSpans, style, onTap: onTap);
      }
    }
  }

  Widget _buildContextMenu(
    BuildContext context,
    EditableTextState editableTextState,
    String fullText,
  ) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: [
        ContextMenuButtonItem(
          label: 'Copy',
          onPressed: () {
            final selectedText = editableTextState.textEditingValue.selection
                .textInside(editableTextState.textEditingValue.text);
            if (selectedText.isNotEmpty) {
              Clipboard.setData(ClipboardData(text: selectedText));
              // Clear the selection after copying
              editableTextState.userUpdateTextEditingValue(
                editableTextState.textEditingValue.copyWith(
                  selection: TextSelection.collapsed(
                    offset: editableTextState.textEditingValue.selection.end,
                  ),
                ),
                SelectionChangedCause.toolbar,
              );
            }
            ContextMenuController.removeAny();
          },
        ),
        ContextMenuButtonItem(
          label: 'Copy All',
          onPressed: () {
            // Convert HTML to plain text for copying
            final document = html_parser.parse(fullText);
            final plainText = document.body?.text ?? fullText;
            Clipboard.setData(ClipboardData(text: plainText));
            // Clear the selection after copying
            editableTextState.userUpdateTextEditingValue(
              editableTextState.textEditingValue.copyWith(
                selection: TextSelection.collapsed(
                  offset: editableTextState.textEditingValue.selection.end,
                ),
              ),
              SelectionChangedCause.toolbar,
            );
            ContextMenuController.removeAny();
          },
        ),
        ContextMenuButtonItem(
          label: 'Select All',
          onPressed: () {
            editableTextState.selectAll(SelectionChangedCause.toolbar);
            ContextMenuController.removeAny();
          },
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
        Get.snackbar(
          'Error',
          'Could not open link: $url',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      Get.snackbar(
        'Error',
        'Invalid link format',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
