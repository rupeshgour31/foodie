import 'package:flutter/material.dart';
import 'package:foodie_bell/Config/common_widgets.dart';

Widget orderHistoryDetails(context, ordersDetail) {
  return ordersDetail.length == 0
      ? Center(
          child: Text('No orders.'),
        )
      : Container(
          alignment: Alignment.topLeft,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: ordersDetail.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  margin: EdgeInsets.only(bottom: 25.0),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(2.0),
                    border: Border.all(color: Colors.grey[200]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 0.7,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60.0,
                        width: 60.0,
                        child: Image.asset(
                          'assets/images/Rectangle 18758.png',
                          fit: BoxFit.fill,
                        ),
                        // child: Image.network(
                        //   ordersDetail[index]['image'],
                        // ),
                      ),
                      // widthSizedBox(12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ordersDetail[index]['name'] ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'Nunito',
                            ),
                            maxLines: 2,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              ordersDetail[index]['order_date'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily: 'Nunito',
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${ordersDetail[index]['final_price']}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 35.0,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: themeColor,)
                        ),
                        child: Text(
                          'Successful',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Nunito',
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
}
