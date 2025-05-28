import 'package:get/get.dart';

class AboutPointsController extends GetxController {
  // List of FAQ items about points
  final List<Map<String, String>> faqItems = [
    {
      'question': 'What are Lord Camelot points?',
      'answer':
          'Lord Camelot points are loyalty rewards you earn with every purchase. These points can be redeemed for exclusive products and services.',
    },
    {
      'question': 'How do I earn points?',
      'answer':
          'You earn points by making purchases at authorized Lord Camelot dealers. Each purchase earns points based on the value of your transaction.',
    },
    {
      'question': 'How do I redeem my points?',
      'answer':
          'You can redeem your points through the "Redeem Points" section in the app. Browse available rewards and select the ones you wish to redeem.',
    },
    {
      'question': 'Do points expire?',
      'answer':
          'Yes, points expire 12 months after they are earned. Make sure to check your points balance regularly and redeem before expiration.',
    },
    {
      'question': 'Can I transfer my points?',
      'answer':
          'No, points are non-transferable and linked to your specific account.',
    },
  ];
}
