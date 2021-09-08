import 'package:flutter/material.dart';


class EventnykCanvas extends StatefulWidget {
	final Widget child;
  final bool Function() keepAlive;
	EventnykCanvas(this.child, { required this.keepAlive });

  @override
  _EventnykCanvasState createState() => _EventnykCanvasState();
}

class _EventnykCanvasState extends State<EventnykCanvas> with AutomaticKeepAliveClientMixin {
	@override
  bool get wantKeepAlive => widget.keepAlive();

	@override
	Widget build(BuildContext context) {
		super.build(context);
		print('${widget.child} built');
		return Scaffold(
			body: Padding(
				padding: EdgeInsets.all(30),
				child: widget.child
			)
		);
	}
}