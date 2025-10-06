import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final onchange;
  const CustomTextField({super.key, this.onchange});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 50,
        child: TextFormField(
          onChanged: onchange,
          style: TextStyle(color: Theme.of(context).hintColor),
          onSaved: (newValue) {},
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            focusColor: Theme.of(context).primaryColor,
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
                borderRadius: BorderRadius.circular(5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5)),
            hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: ""),
            hintText: "ابحث عن السوره",
          ),
        ),
      ),
    );
  }
}
