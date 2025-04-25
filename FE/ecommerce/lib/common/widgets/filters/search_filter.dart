import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget{
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          width: 200,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide()
              )
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: IconButton(
            onPressed: (){},
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            icon: Icon(Icons.search),
          ),
        ),
      ],
    );
  }
  
}