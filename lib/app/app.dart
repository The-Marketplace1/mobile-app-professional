import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'app_router.dart';
import 'app_controller.dart';

class ProfessionalApp extends ConsumerStatefulWidget {
  const ProfessionalApp({super.key});

    @override
      ConsumerState<ProfessionalApp> createState() => _ProfessionalAppState();
      }

      class _ProfessionalAppState extends ConsumerState<ProfessionalApp> {
        late final AppController _controller;
	  late final router = createAppRouter(_controller);

	    @override
	      void initState() {
	          super.initState();
		      _controller = ref.read(appControllerProvider);
		          _controller.restoreSession(ref.read(authRepositoryProvider));
			    }

			      @override
			        Widget build(BuildContext context) => MaterialApp.router(
				    title: 'Professional App',
				        debugShowCheckedModeBanner: false,
					    theme: AppTheme.light(),
					        routerConfig: router,
						  );
						  }

