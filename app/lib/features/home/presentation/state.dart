import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'sections/section.dart';
import 'sections/events/section.dart';


final homeStateProvider = StateProvider<HomeSection>((ref) => const EventsSection());
