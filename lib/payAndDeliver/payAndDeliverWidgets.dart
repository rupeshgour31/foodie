import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/toast.dart';

Widget deliveryPerson(context, userName, imageUrl, image) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 60,
        width: 70,
        child: image != ''
            ? Image.asset(
                '${imageUrl}${image}',
                fit: BoxFit.fill,
              )
            : Image.asset(
                'assets/images/user.png',
                fit: BoxFit.fill,
              ),
      ),
      widthSizedBox(15.0),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizedBox(15.0),
          Text(
            userName ?? '',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Food delivery',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
        ],
      )
    ],
  );
}

bool walletTap = false;
bool cashTap = false;
bool creditCardTap = false;
Widget paymentTypeSelecet(context) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           walletTap = true;
          //           cashTap = false;
          //           creditCardTap = false;
          //         });
          //       },
          //       child: Container(
          //         height: MediaQuery.of(context).size.height * 0.12,
          //         width: MediaQuery.of(context).size.width * 0.25,
          //         padding: EdgeInsets.all(25.0),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           gradient: walletTap
          //               ? LinearGradient(
          //                   colors: [
          //                     Color(0xffDF6E3D),
          //                     Color(0xffFA8B01),
          //                   ],
          //                   end: Alignment.centerRight,
          //                   begin: Alignment.centerLeft,
          //                   // tileMode: TileMode.repeated,
          //                 )
          //               : LinearGradient(
          //                   colors: [
          //                     whiteColor,
          //                     whiteColor,
          //                   ],
          //                   end: Alignment.centerRight,
          //                   begin: Alignment.centerLeft,
          //                 ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey,
          //               blurRadius: 10.0,
          //               // offset: Offset(0.0, 2.0),
          //             ),
          //           ],
          //         ),
          //         child: Image.asset(
          //           'assets/images/Vector(1).png',
          //           fit: BoxFit.contain,
          //           color: walletTap ? whiteColor : Colors.black,
          //         ),
          //       ),
          //     ),
          //     heightSizedBox(10.0),
          //     Text(
          //       'Wallet',
          //     ),
          //   ],
          // ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    walletTap = false;
                    cashTap = true;
                    creditCardTap = false;
                  });
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: cashTap
                        ? LinearGradient(
                            colors: [
                              Color(0xffDF6E3D),
                              Color(0xffFA8B01),
                            ],
                            end: Alignment.centerRight,
                            begin: Alignment.centerLeft,
                            // tileMode: TileMode.repeated,
                          )
                        : LinearGradient(
                            colors: [
                              whiteColor,
                              whiteColor,
                            ],
                            end: Alignment.centerRight,
                            begin: Alignment.centerLeft,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        // offset: Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/money 1.png',
                    fit: BoxFit.contain,
                    color: cashTap ? whiteColor : Colors.black,
                  ),
                ),
              ),
              heightSizedBox(10.0),
              Text(
                'Cash',
              ),
            ],
          ),
          // Column(
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           walletTap = false;
          //           cashTap = false;
          //           creditCardTap = true;
          //         });
          //       },
          //       child: Container(
          //         height: MediaQuery.of(context).size.height * 0.12,
          //         width: MediaQuery.of(context).size.width * 0.25,
          //         padding: EdgeInsets.all(25.0),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           gradient: creditCardTap
          //               ? LinearGradient(
          //                   colors: [
          //                     Color(0xffDF6E3D),
          //                     Color(0xffFA8B01),
          //                   ],
          //                   end: Alignment.centerRight,
          //                   begin: Alignment.centerLeft,
          //                   // tileMode: TileMode.repeated,
          //                 )
          //               : LinearGradient(
          //                   colors: [
          //                     whiteColor,
          //                     whiteColor,
          //                   ],
          //                   end: Alignment.centerRight,
          //                   begin: Alignment.centerLeft,
          //                 ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.grey,
          //               blurRadius: 10.5,
          //               // offset: Offset(10.0, 10.0),
          //             ),
          //           ],
          //         ),
          //         child: Image.asset(
          //           'assets/images/freepik credit card inject 31.png',
          //           fit: BoxFit.contain,
          //           // color: creditCardTap ? whiteColor : Colors.black,
          //           // color: Colors.black,
          //         ),
          //       ),
          //     ),
          //     heightSizedBox(10.0),
          //     Text(
          //       'Credit Card',
          //     ),
          //   ],
          // ),
        ],
      );
    },
  );
}

Widget paymentDetails(context, payment) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Late NIght Surcharge',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${payment['service_charge'] ?? 0}',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      heightSizedBox(10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Moving Cart',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${payment['delivery_fee'] ?? 0}',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      Text(
        'Additional Services',
      ),
      heightSizedBox(10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Discount',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$0',
            style: TextStyle(
              fontSize: 15.0,
              color: themeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      Text(
        'Promo Code: 554dffd',
      ),
      heightSizedBox(10.0),
      dividerCommon(
        height: 1.0,
        thickness: 1.0,
      ),
      heightSizedBox(10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$250',
            style: TextStyle(
              fontSize: 15.0,
              color: themeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget successDeliveryBtn(context, updateOrderDetails) {
  return GestureDetector(
    onTap: () {
      if (walletTap == false && cashTap == false && creditCardTap == false) {
        Constants.showToast('Please Select Payment Type.');
      } else {
        updateOrderDetails();
      }
    },
    child: Container(
      alignment: Alignment.center,
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        gradient: LinearGradient(
          colors: [
            Color(0xffDF6E3D),
            Color(0xffFA8B01),
          ],
          end: Alignment.centerRight,
          begin: Alignment.centerLeft,
          // tileMode: TileMode.repeated,
        ),
      ),
      child: Text(
        'Delivery Successful',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: whiteColor,
        ),
      ),
    ),
  );
}
