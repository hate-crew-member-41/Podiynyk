import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.grey[900],
			body: Center(
				child: Text(
					'прокидаюся',
					style: TextStyle(fontSize: 20, color: Colors.white)
				)
			)
		);
	}
}
