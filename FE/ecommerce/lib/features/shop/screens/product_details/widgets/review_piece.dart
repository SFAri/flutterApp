import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class WReviewPiece extends StatelessWidget {
  const WReviewPiece({
    super.key,
    required this.userName,
    required this.time,
    required this.review,
    required this.rating
  });

  final String userName;
  final String time;
  final String review;
  final double rating;

  @override
  Widget build(BuildContext context) {
    List<String> letter = userName.split(' ');
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Row(
                spacing: 20,
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
                      Text(userName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      
                      Row(
                        children: [
                          Icon(Icons.history, color: Colors.grey.shade500),
                          Text(time, style: TextStyle(color: Colors.grey.shade500)),
                        ],
                      ),
                      
                    ],
                  )
                ],
              ),
              RatingBarIndicator(
                itemCount: 5,
                itemSize: 16,
                rating: rating,
                itemBuilder: (context, index) => Icon(Icons.star),
              ),
              Text(
                review,
                softWrap: true,
                maxLines: 100000,
                overflow: TextOverflow.ellipsis,
              )
            ],
          )
        ],
      ),
    );
  }
}