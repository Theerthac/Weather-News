import 'package:flutter/material.dart';
import 'package:weatherandnewsaggregatorapp/data/colors/colors.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: true,
            onChanged: (value) {},
            activeColor: primaryBlue,
            checkColor: colorWhite,
          ),
          SizedBox(width: 5),
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
