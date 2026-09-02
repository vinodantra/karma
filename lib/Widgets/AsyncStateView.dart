// ignore_for_file: file_names

import 'package:karma/Constants/Library.dart';

/// Renders one of four mutually-exclusive states for any list/detail screen
/// backed by an async data source: loading, error (with retry), empty, or
/// the supplied content. Standardizes what was previously implemented
/// inconsistently across modules.
///
/// Usage:
/// ```dart
/// Obx(() => AsyncStateView(
///   isLoading: controller.isLoading.value,
///   hasError: controller.hasError.value,
///   isEmpty: controller.list.isEmpty,
///   onRetry: controller.getData,
///   child: ListView.builder(...),
/// ))
/// ```
class AsyncStateView extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final String? errorMessage;
  final String emptyMessage;
  final VoidCallback? onRetry;
  final Widget child;
  final Widget? loadingWidget;

  const AsyncStateView({
    super.key,
    required this.isLoading,
    required this.child,
    this.hasError = false,
    this.isEmpty = false,
    this.errorMessage,
    this.emptyMessage = 'No data found.',
    this.onRetry,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const LoadingScreen();
    }
    if (hasError) {
      return _ErrorState(
        message: errorMessage ?? "Couldn't load data. Check your connection.",
        onRetry: onRetry,
      );
    }
    if (isEmpty) {
      return _EmptyState(message: emptyMessage, onRetry: onRetry);
    }
    return child;
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _ErrorState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 56, color: Colors.grey[500]),
            const SizedBox(height: 12),
            TextWidget(
              message,
              fontSize: 16,
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              CustomButton(
                text: 'Retry',
                onPressed: onRetry,
                width: 140,
                height: 40,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const _EmptyState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: Colors.grey[500]),
            const SizedBox(height: 12),
            TextWidget(message, fontSize: 18, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: TextWidget('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
