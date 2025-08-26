import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final Widget? icon;
  final ButtonStyle? style;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ??
            ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? const Color(0xFF667eea),
              foregroundColor: foregroundColor ?? Colors.white,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
        child: buttonChild,
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget? icon;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = borderColor ?? const Color(0xFF667eea);
    
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? color,
          side: BorderSide(color: color, width: 1.5),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor ?? color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool isLoading;

  const IconTextButton({
    super.key,
    required this.text,
    required this.iconData,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      width: width,
      height: height,
      padding: padding,
      borderRadius: borderRadius,
      isLoading: isLoading,
      icon: Icon(iconData, size: 20),
    );
  }
}

class FloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;

  const FloatingActionButton({
    super.key,
    required this.onPressed,
    required this.iconData,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 56.0;
    
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor ?? const Color(0xFF667eea),
            (backgroundColor ?? const Color(0xFF667eea)).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(buttonSize / 2),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? const Color(0xFF667eea)).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Center(
            child: Icon(
              iconData,
              color: foregroundColor ?? Colors.white,
              size: buttonSize * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class StatusButton extends StatelessWidget {
  final String text;
  final String status; // 'success', 'warning', 'error', 'info'
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const StatusButton({
    super.key,
    required this.text,
    required this.status,
    this.onPressed,
    this.width,
    this.height,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'success':
        return const Color(0xFF10B981);
      case 'warning':
        return const Color(0xFFF59E0B);
      case 'error':
        return const Color(0xFFEF4444);
      case 'info':
      default:
        return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: color,
      width: width,
      height: height,
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color? selectedColor;
  final Color? unselectedColor;

  const ToggleButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedColor ?? const Color(0xFF667eea);
    final unselected = unselectedColor ?? Colors.grey[300]!;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: CustomButton(
        text: text,
        onPressed: onPressed,
        backgroundColor: isSelected ? selected : unselected,
        foregroundColor: isSelected ? Colors.white : Colors.grey[700],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final double? width;
  final double? height;
  final Widget? icon;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradientColors = const [Color(0xFF667eea), Color(0xFF764ba2)],
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
