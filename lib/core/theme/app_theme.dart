import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

    static const navy = Color(0xFF17313A);
      static const ink = Color(0xFF203038);
        static const paper = Color(0xFFF7F5EF);
	  static const card = Color(0xFFFFFEFA);
	    static const ochre = Color(0xFFE7AD4F);
	      static const teal = Color(0xFF2E887D);
	        static const coral = Color(0xFFCC6D58);
		  static const muted = Color(0xFF718086);

		    static ThemeData light() {
		        final scheme = ColorScheme.fromSeed(
			      seedColor: navy,
			            brightness: Brightness.light,
				          surface: paper,
					      );
					          return ThemeData(
						        useMaterial3: true,
							      colorScheme: scheme.copyWith(
							              primary: navy,
								              secondary: ochre,
									              surface: paper,
										              onSurface: ink,
											            ),
												          scaffoldBackgroundColor: paper,
													        appBarTheme: const AppBarTheme(
														        backgroundColor: paper,
															        foregroundColor: ink,
																        elevation: 0,
																	      ),
																	            cardTheme: CardThemeData(
																		            color: card,
																			            elevation: 0,
																				            margin: EdgeInsets.zero,
																					            shape: RoundedRectangleBorder(
																						              borderRadius: BorderRadius.circular(20),
																							                side: const BorderSide(color: Color(0xFFE5E3DA)),
																									        ),
																										      ),
																										            inputDecorationTheme: InputDecorationTheme(
																											            filled: true,
																												            fillColor: card,
																													            border: OutlineInputBorder(
																														              borderRadius: BorderRadius.circular(14),
																															                borderSide: const BorderSide(color: Color(0xFFDCDDD6)),
																																	        ),
																																		        enabledBorder: OutlineInputBorder(
																																			          borderRadius: BorderRadius.circular(14),
																																				            borderSide: const BorderSide(color: Color(0xFFDCDDD6)),
																																					            ),
																																						            focusedBorder: OutlineInputBorder(
																																							              borderRadius: BorderRadius.circular(14),
																																								                borderSide: const BorderSide(color: navy, width: 2),
																																										        ),
																																											      ),
																																											            navigationBarTheme: NavigationBarThemeData(
																																												            backgroundColor: card,
																																													            indicatorColor: ochre.withAlpha(70),
																																														            labelTextStyle: WidgetStatePropertyAll(
																																															              TextStyle(fontSize: 11, color: ink.withAlpha(190)),
																																																              ),
																																																	            ),
																																																		          chipTheme: ChipThemeData(
																																																			          backgroundColor: const Color(0xFFE9EFEC),
																																																				          selectedColor: ochre.withAlpha(70),
																																																					          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
																																																						        ),
																																																							    );
																																																							      }
																																																							      }

