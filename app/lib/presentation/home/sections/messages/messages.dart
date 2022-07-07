import 'package:flutter/material.dart';

import '../../section.dart';


class MessagesSection extends HomeSection {
	const MessagesSection();

	@override
	final String name = "messages";
	@override
	final IconData icon = Icons.chat;
	@override
	final IconData inactiveIcon = Icons.chat_outlined;
}
