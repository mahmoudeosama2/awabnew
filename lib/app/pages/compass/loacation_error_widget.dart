import 'package:flutter/material.dart';

class LocationErrorWidget extends StatelessWidget {
  final String? error;
  final Function? callback;

  const LocationErrorWidget({super.key, this.error, this.callback});

  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xffb00020);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.location_off, size: 150, color: errorColor),
            const SizedBox(height: 32),
            Text(
              error!,
              style: const TextStyle(
                fontSize: 22,
                color: errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: Text(
                "حاول مره أخري",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: "",
                  fontSize: 15,
                ),
              ),
              onPressed: () async {
                if (callback != null) callback!();
              },
            ),
          ],
        ),
      ),
    );
  }
}
