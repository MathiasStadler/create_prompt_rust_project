# Rust-Projekt mit 100% Testabdeckung - Vollständiger Prompt

## Projektanforderungen

Erstelle ein vollständiges Rust-Projekt mit den folgenden Eigenschaften:

### 1. Grundlegende Projektstruktur
- **Programmiersprache**: Rust (neueste stabile Version)
- **Projekttyp**: Vollständige Anwendung mit Bibliotheks- und Binary-Komponenten
- **Architektur**: Modularer Aufbau mit klarer Trennung der Verantwortlichkeiten

### 2. Testabdeckung
- **100% Code-Coverage**: Alle Funktionen, Methoden und Code-Pfade müssen getestet werden
- **Unit Tests**: Für jede einzelne Funktion
- **Integration Tests**: Für die Interaktion zwischen Modulen
- **Property-based Tests**: Für komplexe Logik
- **Benchmark Tests**: Für Performance-kritische Funktionen

### 3. Abhängigkeiten und Tools
Füge alle notwendigen Dependencies in `Cargo.toml` hinzu:

```toml
[dependencies]
# Grundlegende Abhängigkeiten
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }
anyhow = "1.0"
thiserror = "1.0"
log = "0.4"
env_logger = "0.10"

[dev-dependencies]
# Test-Abhängigkeiten
proptest = "1.0"
criterion = "0.5"
mockall = "0.11"
rstest = "0.18"
test-case = "3.0"

[build-dependencies]
# Build-Tools wenn nötig
```

### 4. Code-Coverage Tools
- **Installation**: `cargo install cargo-tarpaulin`
- **Konfiguration**: Einrichtung für detaillierte Coverage-Berichte
- **CI/CD Integration**: Automatische Coverage-Überprüfung

### 5. Entwicklungstools
Installiere und konfiguriere folgende Tools:
- `cargo-watch` für automatisches Rebuilding
- `cargo-edit` für Dependency-Management
- `cargo-audit` für Sicherheitsüberprüfungen
- `cargo-deny` für Lizenz- und Dependency-Checks
- `rustfmt` für Code-Formatierung
- `clippy` für Linting

### 6. Projektstruktur
```
project_name/
├── src/
│   ├── main.rs
│   ├── lib.rs
│   ├── modules/
│   │   ├── mod.rs
│   │   ├── core.rs
│   │   ├── utils.rs
│   │   └── error.rs
│   └── bin/
├── tests/
│   ├── integration_tests.rs
│   └── common/
├── benches/
│   └── benchmarks.rs
├── examples/
├── docs/
├── Cargo.toml
├── Cargo.lock
├── README.md
└── .github/
    └── workflows/
        └── ci.yml
```

### 7. Teststrategien
- **Arrange-Act-Assert Pattern**: Für alle Unit Tests
- **Given-When-Then**: Für Behavior-driven Tests
- **Mock-Objekte**: Für externe Abhängigkeiten
- **Snapshot Tests**: Für komplexe Ausgaben
- **Fuzz Testing**: Für Robustheit

### 8. Fehlerbehandlung
- Verwende `Result<T, E>` für alle fallbaren Operationen
- Implementiere custom Error-Types mit `thiserror`
- Nutze `anyhow` für Error-Propagation in Anwendungscode

### 9. Dokumentation
- **Rust-Doc**: Vollständige API-Dokumentation
- **Beispiele**: Code-Beispiele in der Dokumentation
- **README**: Installationsanweisungen und Nutzung
- **CHANGELOG**: Versionsverlauf

### 10. CI/CD Pipeline
GitHub Actions Workflow für:
- Kompilierung auf mehreren Rust-Versionen
- Ausführung aller Tests
- Code-Coverage-Messung
- Linting und Formatierung
- Sicherheitsaudit
- Automatische Releases

## Spezifische Implementierungsanweisungen

### Testabdeckung sicherstellen:
```bash
# Coverage-Bericht generieren
cargo tarpaulin --out Html --output-dir coverage/

# Alle Tests ausführen
cargo test --all-features

# Benchmarks ausführen
cargo bench

# Linting
cargo clippy -- -D warnings

# Formatierung prüfen
cargo fmt --check
```

### Makefile/Justfile für häufige Aufgaben:
```makefile
test:
    cargo test --all-features

coverage:
    cargo tarpaulin --out Html --output-dir coverage/

lint:
    cargo clippy -- -D warnings

format:
    cargo fmt

audit:
    cargo audit

all: format lint test coverage audit
```

### Konfigurationsdateien:
- `.rustfmt.toml` für Code-Formatierung
- `clippy.toml` für Linting-Regeln
- `tarpaulin.toml` für Coverage-Konfiguration

## Qualitätssicherung

### Code-Metriken:
- **Coverage**: Mindestens 95% Zeilencoverage
- **Cyclomatic Complexity**: Maximal 10 pro Funktion
- **Dokumentation**: Alle public APIs dokumentiert

### Performance:
- Benchmark-Tests für kritische Pfade
- Memory-Leak-Tests
- Profiling-Integration

### Sicherheit:
- Regelmäßige Dependency-Audits
- Keine `unsafe` Code-Blöcke ohne Begründung
- Input-Validation für alle externen Eingaben

## Automatisierung

Das Projekt soll vollständig automatisiert sein:
- **Pre-commit Hooks**: Automatische Formatierung und Linting
- **CI Pipeline**: Vollständige Test-Suite bei jedem Push
- **Release Automation**: Automatische Versionierung und Releases
- **Dependency Updates**: Automatische Dependency-Updates mit Tests

## Ausführungsscript

Erstelle ein `setup.sh` Script, das alles automatisch einrichtet:
```bash
#!/bin/bash
# Rust-Projekt Setup mit 100% Coverage
# Alle Tools installieren, Projekt initialisieren, Tests ausführen
```

Dieses Projekt soll als **Best Practice Beispiel** für Rust-Entwicklung dienen und zeigen, wie man professionelle, vollständig getestete Rust-Anwendungen erstellt.