import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';

import '../controllers/redeem_points_controller.dart';

class RedeemPointsView extends GetView<RedeemPointsController> {
  const RedeemPointsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final redeemController = Get.put(RedeemPointsController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black,Colors.black54 ,Color(0xFF002A20),],
            begin: Alignment.topLeft,
         end: Alignment.bottomRight

          ),
        ),
        child: Padding(
          padding: ResponsiveSize.padding(vertical: 16,horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
SizedBox(height: 30,),
              Container(

                width: double.infinity,
                height: ResponsiveSize.height(80),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(22)),
                ),
                child: Center(
                  child: Text(
                    'Redeem points',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.fontSize(18),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30,),
              Container(
                padding: ResponsiveSize.padding(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(ResponsiveSize.radius(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Card Number ${redeemController.cardNumber}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveSize.fontSize(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: redeemController.goToProfile,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(20),
                          ),
                        ),
                        minimumSize: Size(
                          ResponsiveSize.width(100),
                          ResponsiveSize.height(36),
                        ),
                      ),
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: ResponsiveSize.fontSize(13),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveSize.height(16)),


              Row(
                children: [
                  Text(
                    'Redeem Minimum ${redeemController.minimumPoints} points at a time:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveSize.fontSize(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(8)),
                  Obx(
                    () => Text(
                      '${redeemController.availablePoints.value}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: ResponsiveSize.fontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(16)),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: redeemController.dealerEntries.length,
                    itemBuilder: (context, index) {
                      final entry = redeemController.dealerEntries[index];
                      return Container(
                        margin: ResponsiveSize.margin(bottom: 12),
                        padding: ResponsiveSize.padding(all: 12),
                        decoration: BoxDecoration(
                          color:  Color(0xFF121212),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.radius(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildEntryField(
                                    label: 'Dealer Number:',
                                    value: entry.dealerNumber,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              dealerNumber: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'Date:',
                                    value: entry.date,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              date: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'Item Code:',
                                    value: entry.itemCode,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              itemCode: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'Total:',
                                    value: entry.total,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              total: value,
                                            ),
                                  ),
                                  _buildEntryField(
                                    label: 'Point Receive:',
                                    value: entry.pointsReceive,
                                    onChanged:
                                        (value) =>
                                            redeemController.updateDealerEntry(
                                              index,
                                              pointsReceive: value,
                                            ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Redeemed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveSize.fontSize(12),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: ResponsiveSize.height(4)),
                                GestureDetector(
                                  onTap:
                                      () => redeemController.toggleRedeemed(
                                        index,
                                      ),
                                  child: Container(
                                    width: ResponsiveSize.width(24),
                                    height: ResponsiveSize.height(24),
                                    decoration: BoxDecoration(
                                      color: entry.isRedeemed
                                              ? Colors.green
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: entry.isRedeemed
                                                ? Colors.green
                                                : Colors.grey,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveSize.radius(4),
                                      ),
                                    ),
                                    child:
                                        entry.isRedeemed
                                            ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildEntryField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: ResponsiveSize.padding(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: ResponsiveSize.width(90),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveSize.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveSize.fontSize(13),
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: ResponsiveSize.padding(
                  vertical: 6,
                  horizontal: 8,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
