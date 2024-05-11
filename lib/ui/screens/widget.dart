import 'package:flutter/material.dart';

class InteractiveRatingWidget extends StatefulWidget {
  final int maxRating;
  final IconData filledStar;
  final IconData unfilledStar;
  final ValueChanged<int> onChanged;

  InteractiveRatingWidget({
    this.maxRating = 5,
    this.filledStar = Icons.star,
    this.unfilledStar = Icons.star_border,
    required this.onChanged,
  });

  @override
  _InteractiveRatingWidgetState createState() =>
      _InteractiveRatingWidgetState();
}

class _InteractiveRatingWidgetState extends State<InteractiveRatingWidget> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxRating, (index) {
        return IconButton(
          icon: index < _rating
              ? Icon(widget.filledStar)
              : Icon(widget.unfilledStar),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
            if (widget.onChanged != null) {
              widget.onChanged(_rating);
            }
          },
        );
      }),
    );
  }
}