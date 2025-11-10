enum SyncTrigger {
  manual, // Solo cuando el usuario lo solicita
  onConnection, // Automático al detectar conexión
  periodic, // Periódico (cada X minutos)
  onDataChange, // Al cambiar datos locales
  combined, // Combinación de estrategias
}

class SyncStrategy {
  final SyncTrigger trigger;
  final Duration? periodicInterval;
  final bool syncOnAppStart;
  final bool syncOnAppResume;
  final int maxRetries;
  final Duration retryDelay;

  const SyncStrategy({
    required this.trigger,
    this.periodicInterval,
    this.syncOnAppStart = true,
    this.syncOnAppResume = true,
    this.maxRetries = 3,
    this.retryDelay = const Duration(minutes: 5),
  });

  factory SyncStrategy.aggressive() => const SyncStrategy(
        trigger: SyncTrigger.combined,
        periodicInterval: Duration(minutes: 5),
        syncOnAppStart: true,
        syncOnAppResume: true,
        maxRetries: 5,
        retryDelay: Duration(minutes: 1),
      );

  factory SyncStrategy.balanced() => const SyncStrategy(
        trigger: SyncTrigger.combined,
        periodicInterval: Duration(minutes: 15),
        syncOnAppStart: true,
        syncOnAppResume: true,
        maxRetries: 3,
        retryDelay: Duration(minutes: 5),
      );

  factory SyncStrategy.conservative() => const SyncStrategy(
        trigger: SyncTrigger.onConnection,
        periodicInterval: Duration(hours: 1),
        syncOnAppStart: false,
        syncOnAppResume: false,
        maxRetries: 2,
        retryDelay: Duration(minutes: 15),
      );

  factory SyncStrategy.manual() => const SyncStrategy(
        trigger: SyncTrigger.manual,
        syncOnAppStart: false,
        syncOnAppResume: false,
        maxRetries: 1,
      );
}
