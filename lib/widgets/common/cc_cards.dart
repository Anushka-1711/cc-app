import 'package:flutter/material.dart';
import '../../core/design/design_system.dart';

/// Reusable card components following the College Confessions design system
/// 
/// These components provide consistent card styling and behavior across the app.

/// Base card component with consistent styling
class CCCard extends StatelessWidget {
  const CCCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.color,
    this.borderRadius,
    this.border = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final bool border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(CCDesignSystem.space8),
      child: Material(
        color: color ?? CCDesignSystem.backgroundWhite,
        elevation: elevation,
        borderRadius: borderRadius ?? CCDesignSystem.borderRadiusLarge,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? CCDesignSystem.borderRadiusLarge,
          child: Container(
            padding: padding ?? CCDesignSystem.paddingMedium,
            decoration: border
                ? BoxDecoration(
                    borderRadius: borderRadius ?? CCDesignSystem.borderRadiusLarge,
                    border: Border.all(
                      color: CCDesignSystem.divider,
                      width: 1,
                    ),
                  )
                : null,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Card component specifically for confession posts
class CCConfessionCard extends StatelessWidget {
  const CCConfessionCard({
    super.key,
    required this.content,
    required this.isAnonymous,
    required this.community,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onTap,
  });

  final String content;
  final bool isAnonymous;
  final String community;
  final String timeAgo;
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CCCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with privacy badge and community
          Row(
            children: [
              _buildPrivacyBadge(),
              const SizedBox(width: CCDesignSystem.space8),
              Expanded(
                child: Text(
                  community,
                  style: CCDesignSystem.bodySmall,
                ),
              ),
              Text(
                timeAgo,
                style: CCDesignSystem.caption,
              ),
            ],
          ),
          
          const SizedBox(height: CCDesignSystem.space12),
          
          // Content
          Text(
            content,
            style: CCDesignSystem.bodyMedium,
          ),
          
          const SizedBox(height: CCDesignSystem.space12),
          
          // Actions
          Row(
            children: [
              _CCActionButton(
                icon: Icons.favorite_border,
                label: likes.toString(),
                onPressed: onLike,
              ),
              const SizedBox(width: CCDesignSystem.space20),
              _CCActionButton(
                icon: Icons.chat_bubble_outline,
                label: comments.toString(),
                onPressed: onComment,
              ),
              const SizedBox(width: CCDesignSystem.space20),
              _CCActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onPressed: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CCDesignSystem.space8,
        vertical: CCDesignSystem.space4,
      ),
      decoration: BoxDecoration(
        color: isAnonymous ? CCDesignSystem.anonymous : CCDesignSystem.publicPost,
        borderRadius: CCDesignSystem.borderRadiusLarge,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAnonymous ? Icons.lock : Icons.public,
            color: CCDesignSystem.textWhite,
            size: 12,
          ),
          const SizedBox(width: CCDesignSystem.space4),
          Text(
            isAnonymous ? 'Anonymous' : 'Public',
            style: CCDesignSystem.label.copyWith(
              color: CCDesignSystem.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button used within cards
class _CCActionButton extends StatelessWidget {
  const _CCActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: CCDesignSystem.borderRadiusSmall,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CCDesignSystem.space8,
          vertical: CCDesignSystem.space4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: CCDesignSystem.iconSizeSmall,
              color: CCDesignSystem.textSecondary,
            ),
            const SizedBox(width: CCDesignSystem.space4),
            Text(
              label,
              style: CCDesignSystem.caption,
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading card skeleton
class CCLoadingCard extends StatelessWidget {
  const CCLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CCCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CCShimmer(
                width: 80,
                height: 20,
                borderRadius: CCDesignSystem.borderRadiusLarge,
              ),
              const Spacer(),
              const _CCShimmer(width: 60, height: 12),
            ],
          ),
          const SizedBox(height: CCDesignSystem.space12),
          const _CCShimmer(width: double.infinity, height: 16),
          const SizedBox(height: CCDesignSystem.space4),
          const _CCShimmer(width: double.infinity, height: 16),
          const SizedBox(height: CCDesignSystem.space4),
          const _CCShimmer(width: 200, height: 16),
          const SizedBox(height: CCDesignSystem.space12),
          const Row(
            children: [
              _CCShimmer(width: 60, height: 20),
              SizedBox(width: CCDesignSystem.space20),
              _CCShimmer(width: 60, height: 20),
              SizedBox(width: CCDesignSystem.space20),
              _CCShimmer(width: 50, height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer effect for loading states
class _CCShimmer extends StatefulWidget {
  const _CCShimmer({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<_CCShimmer> createState() => _CCShimmerState();
}

class _CCShimmerState extends State<_CCShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? CCDesignSystem.borderRadiusSmall,
            gradient: LinearGradient(
              colors: [
                CCDesignSystem.backgroundCard,
                CCDesignSystem.divider,
                CCDesignSystem.backgroundCard,
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1.0 + _controller.value * 2, 0),
              end: Alignment(1.0 + _controller.value * 2, 0),
            ),
          ),
        );
      },
    );
  }
}