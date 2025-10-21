import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:expenso/services/routing_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showHomeButton;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showHomeButton = true,
    this.height = kToolbarHeight + 10,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    const double sideMargin = 22.0; 
    const double iconSize = 22.0;

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: height - MediaQuery.of(context).padding.top,
                child: Row(
                  mainAxisAlignment: showHomeButton
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showBackButton)
                      Container(
                        margin: EdgeInsets.only(
                          left: sideMargin,
                          right: sideMargin,
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: iconSize,
                          ),
                        ),
                      ),

                    Container(
                      margin: EdgeInsets.only(
                        left: sideMargin,
                        right: sideMargin,
                      ),
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: iconSize,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    if (showHomeButton)
                      Container(
                        margin: EdgeInsets.only(right: sideMargin),
                        child: GestureDetector(
                          onTap: () =>
                              RoutingService().navigateWithoutAnimationTo(RoutingService.home),
                          child: const Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                            size: iconSize + 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
