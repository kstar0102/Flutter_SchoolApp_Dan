import 'package:recleatapp/src/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recleatapp/src/model/dio_client.dart';
import 'package:recleatapp/src/constants/app_constants.dart';
import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:recleatapp/src/features/good_list/inventory.dart';
import 'package:go_router/go_router.dart';
import 'package:recleatapp/src/widgets/new_button.dart';

class InventoryCard extends StatelessWidget {
  const InventoryCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final Inventory info;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.w);
    const textColor = Color(0xFF333333);
    String avatar = info.good_pic;
    if (avatar == "http://www.recleate.com/uploads/image/") {
      avatar = "http://www.recleate.com/uploads/image/good1.png";
    }
    Widget button = info.total_count == '0'
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
                child: SizedBox(
                  width: kTextfieldW / 1.6,
                  height: kTextfieldH * 0.9,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 230,228,232),
                      // border: Border.all(
                      //   color: Colors.black,
                      //   width: 1,
                      // ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                    foregroundColor: Color.fromARGB(255, 2, 2, 2),
                    textStyle: TextStyle(
                      fontFamily: 'LeyendoDEMO',
                      fontWeight: FontWeight.w600,
                      fontSize: 50.sp,
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Unavailable"),
                ),
              ),
            ],
          )
        : Container(
            width: 220.0, // specify width
            height: 40.0, // specify height
            child: NewButton(
              btnType: NewButtonType.BorrowTitle,
              onPressed: () {
                context.pushNamed(
                  AppRoute.detailScreen.name,
                  params: {'good_id': info.id},
                );
              },
            ),
          );
        
    Widget image = info.good_pic == "null.png"
        ? Image.network("http://www.recleate.com/uploads/image/good1.png")
        : Image.network(
            "http://www.recleate.com/uploads/image/" + avatar ?? "",
            width: 150,
            height: 150,
          );

    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10.0),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(
                  left: 6.0,),
                    child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0XFFF4E7FE),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 120.0,
                        height: 110.0,
                        margin: EdgeInsets.zero,
                        child: image,
                      ),
                    ),
                  ),
                
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          'Brand : ${info.brand ?? ""}',
                          style: goodNameLabelStyle,
                        ),
                        SizedBox(width: 40,),
                        Text(
                          'Size : ${info.size ?? ""}',
                          style: goodNameLabelStyle,
                        ),
                      ],),
                      SizedBox(height: 15.0),
                      Text(
                        'Item Type : ${info.item_type ?? ""}',
                        style: goodNameLabelStyle,
                      ),
                      SizedBox(height: 10.0),
                      // Text(
                      //   'Total Count : ${info.total_count}',
                      //   style: goodNameLabelStyle,
                      // ),
                      button,
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
