class LockState {
  final bool isLocked;
  final bool isAuthenticating;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final String? errorMessage;

  LockState({
    this.isLocked = false,
    this.isAuthenticating = false,
    this.failedAttempts = 0,
    this.lockedUntil,
    this.errorMessage,
  });

  LockState copyWith({
    bool? isLocked,
    bool? isAuthenticating,
    int? failedAttempts,
    DateTime? lockedUntil,
    String? errorMessage,
    bool clearLockedUntil = false,
  }) {
    return LockState(
      isLocked: isLocked ?? this.isLocked,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: clearLockedUntil ? null : (lockedUntil ?? this.lockedUntil),
      errorMessage: errorMessage,
    );
  }

  bool get isTemporarilyLocked {
    if (lockedUntil == null) return false;
    return DateTime.now().isBefore(lockedUntil!);
  }

  Duration? get remainingLockTime {
    if (lockedUntil == null) return null;
    final remaining = lockedUntil!.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }
}
