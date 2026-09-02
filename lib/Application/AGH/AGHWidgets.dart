// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'AGHTheme.dart';

/// Gradient app header used across AGH screens.
class AGHHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? trailing;
  final VoidCallback? onBack;
  final bool showInfo;

  const AGHHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.trailing,
    this.onBack,
    this.showInfo = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 14,
        left: 12,
        right: 12,
      ),
      decoration: const BoxDecoration(
        gradient: AGHColors.gradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                showBack ? Icons.chevron_left : Icons.menu,
                color: Colors.white,
                size: showBack ? 24 : 22,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null) trailing!,
              if (showInfo)
                GestureDetector(
                  onTap: () => showAGHSchedulingPlan(context),
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                )
              else
                const SizedBox(width: 40, height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shows the "AGH Scheduling Plan" reference dialog.
Future<void> showAGHSchedulingPlan(BuildContext context) {
  const rows = [
    ['< 3 Months', 'Every 10 Days'],
    ['< 6 Months', 'Every 20 Days'],
    ['< 30 Months', 'Every 30 Days'],
    ['< 90 Months', 'Every 45 Days'],
    ['> 90 Months', 'Every 60 Days'],
  ];

  Widget cell(String text, {required bool header, required bool left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        textAlign: left ? TextAlign.left : TextAlign.center,
        style: TextStyle(
          fontSize: 12.5,
          color: header ? Colors.white : AGHColors.text,
          fontWeight: header ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
            decoration: const BoxDecoration(
              gradient: AGHColors.gradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'AGH Scheduling Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AGHColors.line),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(1),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: AGHColors.line.withValues(alpha: 0.7),
                        ),
                        verticalInside: BorderSide(
                          color: AGHColors.line.withValues(alpha: 0.7),
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration:
                              const BoxDecoration(gradient: AGHColors.gradient),
                          children: [
                            cell('AP Age', header: true, left: true),
                            cell('Next AGH Deadline',
                                header: true, left: false),
                          ],
                        ),
                        for (var i = 0; i < rows.length; i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color: i.isEven
                                  ? Colors.white
                                  : AGHColors.line.withValues(alpha: 0.15),
                            ),
                            children: [
                              cell(rows[i][0], header: false, left: true),
                              cell(rows[i][1], header: false, left: false),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AGHColors.infoSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 16, color: AGHColors.info),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: AGHColors.text,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Note: ',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                  text:
                                      'The next AGH due date is automatically '
                                      'calculated when an AGH session is '
                                      'completed.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Full-width gradient button — primary CTA.
class AGHGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final double borderRadius;

  const AGHGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.padding,
    this.icon,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AGHColors.gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AGHColors.purple.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
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

/// Small inline gradient pill — used as a row-level action CTA in cards.
class AGHActionPill extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AGHActionPill({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          gradient: AGHColors.gradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AGHColors.purple.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: -3,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Outlined purple button used for secondary actions.
class AGHOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AGHOutlineButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AGHColors.purple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AGHColors.purple, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Small pill status chip with pre-defined color kinds.
class AGHStatusChip extends StatelessWidget {
  final AGHStatus kind;
  final String label;

  const AGHStatusChip({super.key, required this.kind, required this.label});

  @override
  Widget build(BuildContext context) {
    final palette = _palette(kind);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: palette.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (kind == AGHStatus.live) ...[
            _PulseDot(color: palette.fg),
            const SizedBox(width: 5),
          ],
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: palette.fg,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  _ChipPalette _palette(AGHStatus k) {
    switch (k) {
      case AGHStatus.due:
        return const _ChipPalette(AGHColors.warnSoft, AGHColors.warn);
      case AGHStatus.missed:
        return const _ChipPalette(AGHColors.dangerSoft, AGHColors.danger);
      case AGHStatus.upcoming:
        return const _ChipPalette(AGHColors.infoSoft, AGHColors.info);
      case AGHStatus.scheduled:
        return const _ChipPalette(AGHColors.scheduledSoft, AGHColors.scheduled);
      case AGHStatus.completed:
      case AGHStatus.submitted:
        return const _ChipPalette(AGHColors.successSoft, AGHColors.success);
      case AGHStatus.live:
        return const _ChipPalette(AGHColors.dangerSoft, AGHColors.danger);
    }
  }
}

class _ChipPalette {
  final Color bg;
  final Color fg;
  const _ChipPalette(this.bg, this.fg);
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 0.4).animate(_c),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

/// Round avatar displaying the person's initials on the gradient.
class AGHAvatar extends StatelessWidget {
  final String name;
  final double size;

  const AGHAvatar({super.key, required this.name, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join()
        .toUpperCase();
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AGHColors.gradient,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Underlined read-only field styled to match the design's form inputs.
class AGHUnderlined extends StatelessWidget {
  final String label;
  final String? value;
  final String placeholder;
  final String? helper;
  final bool multiline;
  final int rows;

  const AGHUnderlined({
    super.key,
    required this.label,
    this.value,
    this.placeholder = '',
    this.helper,
    this.multiline = false,
    this.rows = 3,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                color: AGHColors.textSoft,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 6),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AGHColors.line, width: 1),
              ),
            ),
            child: multiline
                ? SizedBox(
                    width: double.infinity,
                    height: rows * 20.0,
                    child: Text(
                      hasValue ? value! : placeholder,
                      style: TextStyle(
                        fontSize: 14,
                        color: hasValue ? AGHColors.text : AGHColors.textFaint,
                      ),
                    ),
                  )
                : Text(
                    hasValue ? value! : placeholder,
                    style: TextStyle(
                      fontSize: 14,
                      color: hasValue ? AGHColors.text : AGHColors.textFaint,
                    ),
                  ),
          ),
          if (helper != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                helper!,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AGHColors.textFaint,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal filter pill used in dashboards / notifications.
class AGHFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool showCaret;
  final VoidCallback? onTap;

  const AGHFilterChip({
    super.key,
    required this.label,
    this.selected = false,
    this.showCaret = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              selected ? AGHColors.pink.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AGHColors.pink : AGHColors.line,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: selected ? AGHColors.pink : AGHColors.textSoft,
              ),
            ),
            if (showCaret) ...[
              const SizedBox(width: 5),
              Icon(
                Icons.keyboard_arrow_down,
                size: 14,
                color: selected ? AGHColors.pink : AGHColors.textSoft,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Tabs used on the dashboard (Upcoming / Scheduled / Completed).
class AGHTabs extends StatelessWidget {
  final List<String> items;
  final String active;
  final ValueChanged<String>? onChanged;

  const AGHTabs({
    super.key,
    required this.items,
    required this.active,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AGHColors.line)),
      ),
      child: Row(
        children: items.map((t) {
          final isActive = t == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged?.call(t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive ? AGHColors.pink : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  t,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? AGHColors.pink : AGHColors.textSoft,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Simple selectable topic chip.
class AGHTopicChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const AGHTopicChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color:
              selected ? AGHColors.pink.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? AGHColors.pink : AGHColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check, size: 10, color: AGHColors.pink),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected ? AGHColors.pink : AGHColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
