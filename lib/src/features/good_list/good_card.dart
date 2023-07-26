import 'package:recleatapp/src/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recleatapp/src/model/dio_client.dart';
import 'package:recleatapp/src/constants/app_constants.dart';
import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:recleatapp/src/features/good_list/good.dart';
import 'package:go_router/go_router.dart';
import 'package:recleatapp/src/widgets/defalut_button.dart';
import 'package:recleatapp/src/model/dio_client.dart';
import 'package:recleatapp/src/features/good_list/admin_good_controller.dart';
import 'package:recleatapp/src/features/good_list/good_screen.dart';
import 'package:recleatapp/src/widgets/dialogs.dart';

class GoodCard extends StatelessWidget {
  const GoodCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  final Good info;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.w);
    const textColor = Color(0xFF333333);
    String avatar = info.good_pic;
    if (avatar == "http://www.recleate.com/uploads/image/") {
      avatar = "http://www.recleate.com/uploads/image/good1.png";
    }

    Widget image = info.good_pic == "null.png"
        ? Image.network("http://www.recleate.com/uploads/image/good1.png")
        : Image.network(
            "http://www.recleate.com/uploads/image/" + avatar ?? "",
            width: 10,
            height: 10,
          );

    Future<void> DialogModal(listId, email) async {
      Widget cancelButton = TextButton(
        child: Text("Return"),
        onPressed: () {
          dynamic data = DioClient.returnBuyer(listId);
          Navigator.pop(context);
          showToastMessage("Successfully");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGoodScreen()),
          );
        },
      );
      Widget continueButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Notice"),
        content: Text(
            "Would you like to change ${email} permissions for this product?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future<void> DeleteDialog(good_id) async {
      Widget cancelButton = TextButton(
        child: Text("Delete"),
        onPressed: () {
          dynamic data = DioClient.deleteGoodData(good_id);
          Navigator.pop(context);
          showToastMessage("Successfully");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGoodScreen()),
          );
        },
      );
      Widget continueButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Notice"),
        content: Text("Are you sure you want to delete this product?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future<void> UpdateDialog(good_id) async {
      Widget cancelButton = TextButton(
        child: Text("Return"),
        onPressed: () {
          dynamic data = DioClient.updateGoodData(good_id);
          Navigator.pop(context);
          showToastMessage("Successfully");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGoodScreen()),
          );
        },
      );
      Widget continueButton = TextButton(
        child: Text("Close"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Notice"),
        content: Text(
            "All existing products will be returned.\nWould you still like to return it?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    String dataFromDatabase = info.email;
    String dataFromListId = info.list_id;

    List<String> separatedValues = dataFromDatabase.split(",");

    Map<String, String> emailListIdMap = {};

    List<String> separatedListIds = dataFromListId.split(",");
    for (int i = 0; i < separatedValues.length; i++) {
      String email = separatedValues[i];
      String listId = separatedListIds[i];
      emailListIdMap[email] = listId;
    }

    List<Widget> buttons = [];

    for (String value in separatedValues) {
      String listId = emailListIdMap[value] ?? "Emp";

      buttons.add(
        ElevatedButton(
          onPressed: () {
            DialogModal(listId, value);
          },
          child: Text(value),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 226, 240, 217),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black),
              ),
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              Colors.black,
            ),
          ),
        ),
      );
    }

    Widget buyer = info.name == "null"
        ? Text(
            'Buyer : Empty',
            style: goodNameLabelStyle,
          )
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Buyer : ",
                    style: goodNameLabelStyle,
                  ),
                ),
                ...buttons,
              ],
            ),
          );
    Widget avaliableButton = info.total_count == "0" || info.email == null
        ? ElevatedButton(
            onPressed: () {
              // Code to be executed when the button is pressed
            },
            // child: Text(
            //   'Unavailable',
            //   style: TextStyle(
            //     color: Colors.black,
            //   ),
            // ),
            child: Text(
              '${info.email}',
              style: TextStyle(
                color: Color.fromARGB(255, 146, 16, 249),
                fontSize: 14
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 239, 219, 254),
              // side: BorderSide(
              //   color: Colors.black,
              //   width: 1,
              // ),
              minimumSize: Size(200, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        : ElevatedButton(
            onPressed: () {
              // Code to be executed when the button is pressed
            },
            child: Text('Available', style: TextStyle(fontSize: 14),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 146, 16, 249),
              // side: BorderSide(
              //   color: Colors.black,
              //   width: 1,
              // ),
              minimumSize: Size(200, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

    Widget returnButton = info.total_count == "0"
        ? ElevatedButton(
            onPressed: () {
              UpdateDialog(info.id);
            },
            child: Text(
              'Return',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 249, 155, 16)), // Adjust background color
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust border radius
                ),
              ),
              minimumSize: MaterialStateProperty.all<Size>(Size(100.0, 35.0)), // Adjust button size
            ),
          )
        : ElevatedButton(
            onPressed: () {},
            child: Text(
              'Borrow',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 230, 228, 232)), // Adjust background color
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust border radius
                ),
              ),
              minimumSize: MaterialStateProperty.all<Size>(Size(100.0, 35.0)), // Adjust button size
            ),
          );

    return Container(
      child: Column(
        children: [
          Container(
            child: Padding(
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
                          width: 130.0,
                          height: 150.0,
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
                        SizedBox(height: 20.0),
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
                        Padding(
                          padding: EdgeInsets.only(
                            left: 0.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [returnButton],
                              ),
                              SizedBox(width: 10,),
                              ElevatedButton(
                                onPressed: () {
                                  DeleteDialog(info.id);
                                },
                                child: Text('Delete', style: TextStyle(
                                  fontSize: 12
                                ),),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Color(0XFFF91055)), // Adjust background color
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Adjust border radius
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all<Size>(Size(90.0, 35.0)), // Adjust button size
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 0.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  avaliableButton,
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
