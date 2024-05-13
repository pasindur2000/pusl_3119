import 'package:flutter/material.dart';

class StarDisplayWidget extends StatelessWidget {
  final int value;
  final Widget filledStar;
  final Widget unfilledStar;

  const StarDisplayWidget({
    required Key key,
    this.value = 0,
    required this.filledStar,
    required this.unfilledStar,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return index < value ? filledStar : unfilledStar;
      }),
    );
  }
}

class StarDisplay extends StarDisplayWidget {
  const StarDisplay({required Key key, int value = 0})
      : super(
    key: key,
    value: value,
    filledStar: const Icon(Icons.star, color: Colors.orangeAccent), // Change the color here
    unfilledStar: const Icon(Icons.star_border, color: Colors.orangeAccent), // Change the color here
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show a popup box here
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // List of texts corresponding to each star rating
            List<String> stageDescriptions = [
              "Stage 1: Healthy",
              "Stage 2: Early Symptoms",
              "Stage 3: Moderate Infection",
              "Stage 4: Advanced Infection",
              "Stage 5: Critical Condition",
            ];

            return AlertDialog(
              title: Text('Rating Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  int starsToShow = index + 1; // Number of stars to show on this line
                  return ListTile(
                    title: Text(stageDescriptions[index]), // Text above each line of stars
                    subtitle: Row(
                      children: List.generate(starsToShow, (index) {
                        return Icon(Icons.star, color: Colors.orangeAccent);
                      }),
                    ),
                  );
                }),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },




        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0), // Adjust padding as needed
        child: super.build(context),
      ),
    );
  }
}
