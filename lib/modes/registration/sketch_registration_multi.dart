// import 'package:tuple/tuple.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/eventnyk_canvas.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// class RegistrationModel with ChangeNotifier {
// 	final CollectionReference _edusCollectionRef = FirebaseFirestore.instance.collection('EDUs');

// 	late Iterable<String> _edus;
// 	Future<bool> awaitEDUs() async {
// 		try {
// 			QuerySnapshot collection = await _edusCollectionRef.get();
// 			this._edus = collection.docs.map( (document) => document.id );
// 			_addPageWithContent(EDUPageContent());
// 			return true;
// 		}
// 		catch (_) {
// 			return false;
// 		}
// 	}

// 	final List<EventnykCanvas> _pages = [];
// 	List<EventnykCanvas> get pages => _pages;
// 	final bool Function() _keepPageAlive = () => true;  // todo: change to return false after registration is over

// 	final PageController _pageController = PageController();
// 	PageController get controller => _pageController;

// 	RegistrationModel() {
// 		_addPageWithContent(IntroPageContent());
// 	}

// 	void _addPageWithContent(Widget content) {
// 		_pages.add(EventnykCanvas(content, keepAlive: _keepPageAlive));
// 		print('list of pages changed: ${_pages.map( (page) => page.child.runtimeType )}, calling notifyListeners');
// 		notifyListeners();
// 	}
// }


// class Registration extends StatelessWidget {  // todo: save info from every page to the db
// 	@override
// 	Widget build(BuildContext context) {
// 		return ChangeNotifierProvider<RegistrationModel>(
// 			create: (_) => RegistrationModel(),
// 			child: Selector<RegistrationModel, Tuple2<PageController, List<EventnykCanvas>>>(
// 				selector: (_, model) {
// 					print('Selector is seeing ${model.pages.length} page(s)');
// 					return Tuple2(model.controller, model.pages);
// 				},
// 				builder: (_, data, __) {
// 					print('rebuilding PageView');
// 					return PageView(
// 						controller: data.item1,
// 						children: data.item2
// 					);
// 				},
// 				shouldRebuild: (previous, current) {
// 					print('there was (were) ${previous.item2.length} page(s) the previous time');
// 					return current.item2.length > previous.item2.length;
// 				}
// 			)
// 		);
// 	}
// }


// class IntroPageContent extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column(
// 			mainAxisAlignment: MainAxisAlignment.center,
// 			crossAxisAlignment: CrossAxisAlignment.start,
// 			children: [
// 				Text(
// 					'Цей застосунок створено з надією допомогти вашій групі слідкувати за реченцями. '
// 					'Можливо, не тільки реченцями. Можливо, не тільки слідкувати.',
// 					style: Theme.of(context).textTheme.bodyText1
// 				),
// 				SizedBox(height: 25),
// 				FutureBuilder<bool>(
// 					future: context.read<RegistrationModel>().awaitEDUs(),
// 					builder: _awaitingEDUsStatusBuilder
// 				)
// 			]
// 		);
// 	}

// 	Widget _awaitingEDUsStatusBuilder (BuildContext context, AsyncSnapshot<bool> snapshot) {
// 		Widget? child;
// 		double opacity = 0;

// 		if (snapshot.connectionState == ConnectionState.done) {
// 			if (snapshot.data!) {
// 				child = Text(
// 					'Розкажу потім) Університети завантажено, нам праворуч.',
// 					style: Theme.of(context).textTheme.bodyText1
// 				);
// 			}
// 			else {
// 				child = Text(snapshot.error.toString());
// 			}
// 			opacity = 1;
// 		}

// 		return AnimatedOpacity(
// 			duration: Duration(milliseconds: 500),
// 			opacity: opacity,
// 			child: child
// 		);
// 	}
// }


// class EDUPageContent extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column();
// 	}
// }


// class DepartmentPageContent extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column();
// 	}
// }


// class GroupPageContent extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column();
// 	}
// }


// class GroupInfoPageContent extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column();
// 	}
// }


// class LCPageContent extends StatelessWidget {
// 	@override
// 	Widget build(BuildContext context) {
// 		return Column();
// 	}
// }
