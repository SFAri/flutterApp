import 'package:ecommerce/utils/device/device_utility.dart';
import 'package:flutter/material.dart';

class WCommentPiece extends StatelessWidget {
  const WCommentPiece({
    super.key,
    required this.userName,
    required this.time,
    required this.comment
  });

  final String userName;
  final String time;
  final String comment;

  @override
  Widget build(BuildContext context) {
    List<String> letter = userName.split(' ');
    return Column(
      spacing: 10,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Colors.grey
            )
          ),
          child: Column(
            children: [
              Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 23,
                        foregroundColor: Colors.white,
                        child: Text(letter[0]),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              Icon(Icons.history, color: Colors.grey.shade500),
                              Text(time, style: TextStyle(color: Colors.grey.shade500))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    comment,
                    softWrap: true,
                    maxLines: 100000,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
        ),
    
        // TextFormField and send comment button:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: CDeviceUtils.getScreenWidth(context) * 0.8,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide()
                  )
                ),
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    
              ),
              onPressed: (){}, 
              icon: Icon(Icons.send),
            )
          ]
        ),
      ],
    );
  }
}