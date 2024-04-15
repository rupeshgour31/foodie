import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';

SizedBox heightSizedBox(height) {
  return SizedBox(
    height: height,
  );
}

SizedBox widthSizedBox(width) {
  return SizedBox(
    width: width,
  );
}

TextStyle labelHintFontStyle = TextStyle(
  color: Colors.black87,
  fontSize: 14.5,
  fontWeight: FontWeight.w600,
  // fontFamily: pCommonRegularFont,
);

Divider dividerCommon({
  double height,
  double thickness,
  double indent,
  double endIndent,
  Color color,
}) {
  return Divider(
    height: height,
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
    color: color,
  );
}

mediaText(context) {
  return MediaQuery.of(context).copyWith(textScaleFactor: 0.9);
}

Widget verticalDivider(bool isCurrentOrder, double height) {
  return Container(
    height: height,
    child: VerticalDivider(
      color: Colors.black,
      // width: 5.0,
      thickness: 1.0,
    ),
  );
}

Color whiteColor = Colors.white;
Color redColor = Color(0xffE01C23);
Color themeColor = Color(0xFFFA8B01);

void showPopup(BuildContext context, messageWidget) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.65),
    transitionDuration: Duration(milliseconds: 400),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(15.0),
          // height: 300,
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          decoration: BoxDecoration(
            color: whiteColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
          ),
          child: messageWidget ??
              SizedBox.expand(
                child: FlutterLogo(),
              ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(
          begin: Offset(0, 1),
          end: Offset(0, 0),
        ).animate(anim),
        child: child,
      );
    },
  );
}

Widget checkOut(bool isActive, int page) {
  return Container(
    height: 45,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 13, top: 15),
              width: double.infinity,
              height: 4,
              color: whiteColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                statusWidget(
                  Icon(
                    Icons.attach_money,
                    size: 18.0,
                    color: true ? whiteColor : Colors.black,
                  ),
                  "Confirmed",
                  true,
                ),
                statusWidget(
                  Icon(
                    Icons.storefront,
                    size: 18.0,
                    color: page == 2 || page == 3 ? whiteColor : Colors.black,
                  ),
                  "Picked Up",
                  page == 2 || page == 3 ? true : false,
                ),
                statusWidget(
                  Icon(
                    Icons.check,
                    size: 18.0,
                    color: page == 3 ? whiteColor : Colors.black,
                  ),
                  "In Prices",
                  page == 3 ? true : false,
                ),
              ],
            )
          ],
        ),
      ],
    ),
  );
}

Container statusWidget(Widget icon, String status, bool isActive) {
  return Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: (isActive) ? Color(0xff00b940) : whiteColor,
    ),
    child: Center(child: icon),
  );
}

Widget topContainerAndImage(context, imageShow) {
  return Stack(
    children: [],
  );
}

Widget chooseQnantity(context, model) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Sheet Quantites',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: null,
                ),
              ],
            ),
            model.sheetQnt(context),
          ],
        ),
      );
    },
  );
}

List paperSize = [
  'Option 1',
  'Option 2',
  'Option 3',
  'Option 4',
  'Option 5',
  'Option 6',
  'Option 7',
  'Option 8',
  'Option 9',
  'Option 10',
  'Option 11',
  'Option 12',
  'Option 13',
  'Option 14',
  'Option 15',
];

Widget selectPaperTypeBottomSheet(context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: EdgeInsets.only(top: 10.0),
        height: 200,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: new ListWheelScrollView.useDelegate(
          itemExtent: 25,
          magnification: 1.5,
          useMagnifier: true,
          physics: FixedExtentScrollPhysics(),
          perspective: 0.01,
          diameterRatio: 1.5,
          squeeze: 0.8,
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (BuildContext context, int index) {
              if (index < 0 || index > 10) {
                return null;
              }
              return GestureDetector(
                onTap: () {
                  print('rupesh');
                  Navigator.pop(
                    context,
                    paperSize[index],
                  );
                },
                child: Text(
                  paperSize[index],
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

Widget chooseQnt(context, model) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Sheet Quantites',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            model.sheetQnt(context),
          ],
        ),
      );
    },
  );
}

Widget commonTypesShow(
  BuildContext context,
  model,
  String imageView,
  List listData,
) {
  return Column(
    children: [
      topContainerAndImage(context, imageView),
      heightSizedBox(20.0),
      pageDetailView(listData, context, model),
    ],
  );
}

Widget pageDetailView(drawerItems, context, model) {
  return Container(
    width: 550,
    child: drawerItems.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: drawerItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // String goPage = drawerItems[index]['title'];
                      // switch (goPage) {
                      //   case 'Design':
                      //     return Navigator.pushNamed(
                      //       context,
                      //       '/designPage',
                      //     );
                      //     break;
                      //   case 'Width':
                      //     return selectPaperType(context);
                      //     break;
                      //   case 'Paper Type':
                      //     return selectPaperType(context);
                      //     break;
                      //   case 'Number of Copies':
                      //     return chooseQnt(context, model);
                      //     break;
                      //   case 'Printing Sides':
                      //     return chooseQnt(context, model);
                      //     break;
                      //   case 'Rollup Size':
                      //     return selectPaperType(context);
                      //     break;
                      //   case 'Paper Size':
                      //     return selectPaperType(context);
                      //     break;
                      // }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          padding: EdgeInsets.all(10.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                              drawerItems[index]['icon'],
                              color: Colors.black,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        widthSizedBox(10.0),
                        Text(
                          drawerItems[index]['title'],
                          style: TextStyle(
                            fontSize: 18,
                            color: whiteColor,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
  );
}

ProgressHUD progressHUD = ProgressHUD(
  // loading: false,
  // backgroundColor: Colors.black12,
  // color: Colors.white,
  // containerColor: Color(0xFF23485A),
  // borderRadius: 5.0,
  // text: 'Loading...',
  loading: false,
  backgroundColor: Colors.black12,
  color: Colors.white,
  containerColor: Color(0xff001b29),
  borderRadius: 5.0,
  text: 'Loading...',
);

dataSplit(str, splitWith) {
  return str.toString().split(splitWith);
}

latLongMaps(dataStr) {
  var mapDataStr = dataSplit(dataStr, ', ');
  var latitude = dataSplit(mapDataStr[0], ': ');
  var longitude = dataSplit(mapDataStr[1], ': ');

  var latLongMap = {
    'latitude': latitude[1],
    'longitude': longitude[1],
  };
  return latLongMap;
}

progressLoading() {
  return Container(
    margin: EdgeInsets.only(top: 300.0),
    decoration: new BoxDecoration(
      color: Colors.blue[200],
      borderRadius: new BorderRadius.circular(10.0),
    ),
    width: 300.0,
    height: 80.0,
    alignment: Alignment.center,
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: new SizedBox(
            height: 50.0,
            width: 50.0,
            child: new CircularProgressIndicator(
              value: null,
              strokeWidth: 7.0,
            ),
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(top: 25.0),
          child: new Center(
            child: new Text(
              "loading.. wait...",
              style: new TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget rating(count) {
  return Row(
    children: [
      Icon(
        Icons.star,
        color: int.parse(count) >= 1 ? Colors.orange : Colors.grey,
        size: 12,
      ),
      Icon(
        Icons.star,
        color: int.parse(count) >= 2 ? Colors.orange : Colors.grey,
        size: 12,
      ),
      Icon(
        Icons.star,
        color: int.parse(count) >= 3 ? Colors.orange : Colors.grey,
        size: 12,
      ),
      Icon(
        Icons.star,
        color: int.parse(count) >= 4 ? Colors.orange : Colors.grey,
        size: 12,
      ),
      Icon(
        Icons.star,
        color: int.parse(count) == 5 ? Colors.orange : Colors.grey,
        size: 12,
      ),
    ],
  );
}
