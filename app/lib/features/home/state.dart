import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'section.dart';
import 'sections/events/events.dart';


final homeStateProvider = StateProvider<HomeSection>((ref) => const EventsSection());
