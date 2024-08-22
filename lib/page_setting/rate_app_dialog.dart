import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class RateAppDialog extends StatefulWidget {
  @override
  _RateAppDialogState createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog> {
  int _selectedStars = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: screenWidth * 0.8,
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.thank_for_your_feedback,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                AppLocalizations.of(context)!.star_rating_for_app,
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(
                    index < _selectedStars ? Icons.star : Icons.star_border,
                    size: screenWidth * 0.08, // Adjust size to fit within the row
                  ),
                  color: Colors.amber,
                  onPressed: () {
                    setState(() {
                      _selectedStars = index + 1;
                    });
                  },
                )),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("${AppLocalizations.of(context)!.cancel}", style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${AppLocalizations.of(context)!.thank_you_for_rating} $_selectedStars ${AppLocalizations.of(context)!.star}!"),
                        ),
                      );
                    },
                    child: Text("${AppLocalizations.of(context)!.submit}", style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
