#!/bin/bash
# Rust-Projekt Setup mit 100% Coverage
# Vollständige Projektinitialisierung

set -e  # Exit on error

PROJECT_NAME="rust_project_complete"
CURRENT_DIR=$(pwd)
PROJECT_DIR="$CURRENT_DIR/$PROJECT_NAME"

echo "🚀 Rust-Projekt Setup mit 100% Testabdeckung"
echo "================================================"

# Überprüfe Rust Installation
if ! command -v rustc &> /dev/null; then
    echo "❌ Rust ist nicht installiert. Installiere Rust von https://rustup.rs/"
    exit 1
fi

echo "✅ Rust Version: $(rustc --version)"

# Erstelle Projekt
echo "📁 Erstelle Projekt: $PROJECT_NAME"
cargo new $PROJECT_NAME --lib
cd $PROJECT_NAME

# Erstelle Projektstruktur
echo "🏗️  Erstelle Projektstruktur..."
mkdir -p src/modules src/bin tests/common benches examples docs .github/workflows

# Cargo.toml
cat > Cargo.toml << 'EOF'
[package]
name = "rust_project_complete"
version = "0.1.0"
edition = "2021"
authors = ["Your Name <your.email@example.com>"]
description = "Ein vollständiges Rust-Projekt mit 100% Testabdeckung"
license = "MIT OR Apache-2.0"
repository = "https://github.com/yourusername/rust_project_complete"
documentation = "https://docs.rs/rust_project_complete"
readme = "README.md"
keywords = ["rust", "testing", "coverage", "example"]
categories = ["development-tools"]

[dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }
anyhow = "1.0"
thiserror = "1.0"
log = "0.4"
env_logger = "0.10"
clap = { version = "4.0", features = ["derive"] }
uuid = { version = "1.0", features = ["v4"] }

[dev-dependencies]
proptest = "1.0"
criterion = "0.5"
mockall = "0.11"
rstest = "0.18"
test-case = "3.0"
serial_test = "3.0"
tempfile = "3.0"

[[bench]]
name = "benchmarks"
harness = false

[profile.release]
lto = true
codegen-units = 1
panic = "abort"

[profile.test]
opt-level = 0
debug = true
EOF

# src/lib.rs
cat > src/lib.rs << 'EOF'
//! # Rust Project Complete
//! 
//! Ein vollständiges Rust-Projekt mit 100% Testabdeckung.
//! 
//! ## Beispiel
//! 
//! ```rust
//! use rust_project_complete::Calculator;
//! 
//! let calc = Calculator::new();
//! let result = calc.add(2, 3);
//! assert_eq!(result, 5);
//! ```

pub mod modules;

use modules::error::ProjectError;
use serde::{Deserialize, Serialize};
use std::fmt;

/// Hauptstruktur für mathematische Operationen
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Calculator {
    history: Vec<Operation>,
}

/// Repräsentiert eine mathematische Operation
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Operation {
    pub operation_type: OperationType,
    pub operands: Vec<f64>,
    pub result: f64,
    pub timestamp: u64,
}

/// Arten von mathematischen Operationen
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum OperationType {
    Add,
    Subtract,
    Multiply,
    Divide,
}

impl fmt::Display for OperationType {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            OperationType::Add => write!(f, "Addition"),
            OperationType::Subtract => write!(f, "Subtraktion"),
            OperationType::Multiply => write!(f, "Multiplikation"),
            OperationType::Divide => write!(f, "Division"),
        }
    }
}

impl Calculator {
    /// Erstellt einen neuen Calculator
    /// 
    /// # Beispiel
    /// 
    /// ```rust
    /// use rust_project_complete::Calculator;
    /// 
    /// let calc = Calculator::new();
    /// assert_eq!(calc.history_count(), 0);
    /// ```
    pub fn new() -> Self {
        Self {
            history: Vec::new(),
        }
    }

    /// Addiert zwei Zahlen
    /// 
    /// # Beispiel
    /// 
    /// ```rust
    /// use rust_project_complete::Calculator;
    /// 
    /// let mut calc = Calculator::new();
    /// let result = calc.add(2.0, 3.0);
    /// assert_eq!(result, 5.0);
    /// ```
    pub fn add(&mut self, a: f64, b: f64) -> f64 {
        let result = a + b;
        self.add_to_history(OperationType::Add, vec![a, b], result);
        result
    }

    /// Subtrahiert zwei Zahlen
    pub fn subtract(&mut self, a: f64, b: f64) -> f64 {
        let result = a - b;
        self.add_to_history(OperationType::Subtract, vec![a, b], result);
        result
    }

    /// Multipliziert zwei Zahlen
    pub fn multiply(&mut self, a: f64, b: f64) -> f64 {
        let result = a * b;
        self.add_to_history(OperationType::Multiply, vec![a, b], result);
        result
    }

    /// Dividiert zwei Zahlen
    /// 
    /// # Errors
    /// 
    /// Gibt einen Fehler zurück, wenn durch Null geteilt wird.
    pub fn divide(&mut self, a: f64, b: f64) -> Result<f64, ProjectError> {
        if b == 0.0 {
            return Err(ProjectError::DivisionByZero);
        }
        let result = a / b;
        self.add_to_history(OperationType::Divide, vec![a, b], result);
        Ok(result)
    }

    /// Berechnet die Fakultät einer Zahl
    /// 
    /// # Errors
    /// 
    /// Gibt einen Fehler zurück, wenn die Zahl negativ ist.
    pub fn factorial(&self, n: u64) -> Result<u64, ProjectError> {
        if n > 20 {
            return Err(ProjectError::OverflowError("Factorial too large".to_string()));
        }
        
        let mut result = 1;
        for i in 1..=n {
            result *= i;
        }
        Ok(result)
    }

    /// Gibt die Anzahl der Operationen im Verlauf zurück
    pub fn history_count(&self) -> usize {
        self.history.len()
    }

    /// Gibt den Verlauf der Operationen zurück
    pub fn get_history(&self) -> &[Operation] {
        &self.history
    }

    /// Löscht den Verlauf
    pub fn clear_history(&mut self) {
        self.history.clear();
    }

    /// Fügt eine Operation zum Verlauf hinzu
    fn add_to_history(&mut self, op_type: OperationType, operands: Vec<f64>, result: f64) {
        let timestamp = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .unwrap()
            .as_secs();
        
        let operation = Operation {
            operation_type: op_type,
            operands,
            result,
            timestamp,
        };
        
        self.history.push(operation);
    }
}

impl Default for Calculator {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::*;

    #[test]
    fn test_new_calculator() {
        let calc = Calculator::new();
        assert_eq!(calc.history_count(), 0);
    }

    #[test]
    fn test_add() {
        let mut calc = Calculator::new();
        let result = calc.add(2.0, 3.0);
        assert_eq!(result, 5.0);
        assert_eq!(calc.history_count(), 1);
    }

    #[test]
    fn test_subtract() {
        let mut calc = Calculator::new();
        let result = calc.subtract(5.0, 3.0);
        assert_eq!(result, 2.0);
        assert_eq!(calc.history_count(), 1);
    }

    #[test]
    fn test_multiply() {
        let mut calc = Calculator::new();
        let result = calc.multiply(4.0, 3.0);
        assert_eq!(result, 12.0);
        assert_eq!(calc.history_count(), 1);
    }

    #[test]
    fn test_divide() {
        let mut calc = Calculator::new();
        let result = calc.divide(10.0, 2.0).unwrap();
        assert_eq!(result, 5.0);
        assert_eq!(calc.history_count(), 1);
    }

    #[test]
    fn test_divide_by_zero() {
        let mut calc = Calculator::new();
        let result = calc.divide(10.0, 0.0);
        assert!(result.is_err());
        assert_eq!(calc.history_count(), 0);
    }

    #[test]
    fn test_factorial() {
        let calc = Calculator::new();
        assert_eq!(calc.factorial(0).unwrap(), 1);
        assert_eq!(calc.factorial(1).unwrap(), 1);
        assert_eq!(calc.factorial(5).unwrap(), 120);
    }

    #[test]
    fn test_factorial_overflow() {
        let calc = Calculator::new();
        let result = calc.factorial(25);
        assert!(result.is_err());
    }

    #[test]
    fn test_clear_history() {
        let mut calc = Calculator::new();
        calc.add(1.0, 2.0);
        calc.add(3.0, 4.0);
        assert_eq!(calc.history_count(), 2);
        
        calc.clear_history();
        assert_eq!(calc.history_count(), 0);
    }

    #[test]
    fn test_default() {
        let calc = Calculator::default();
        assert_eq!(calc.history_count(), 0);
    }

    // Property-based Tests
    proptest! {
        #[test]
        fn test_add_commutative(a in -1000.0..1000.0, b in -1000.0..1000.0) {
            let mut calc1 = Calculator::new();
            let mut calc2 = Calculator::new();
            
            let result1 = calc1.add(a, b);
            let result2 = calc2.add(b, a);
            
            assert!((result1 - result2).abs() < f64::EPSILON);
        }

        #[test]
        fn test_multiply_commutative(a in -100.0..100.0, b in -100.0..100.0) {
            let mut calc1 = Calculator::new();
            let mut calc2 = Calculator::new();
            
            let result1 = calc1.multiply(a, b);
            let result2 = calc2.multiply(b, a);
            
            assert!((result1 - result2).abs() < f64::EPSILON);
        }
    }
}
EOF

# src/modules/mod.rs
cat > src/modules/mod.rs << 'EOF'
//! Module für das Rust-Projekt

pub mod core;
pub mod error;
pub mod utils;
EOF

# src/modules/error.rs
cat > src/modules/error.rs << 'EOF'
//! Fehlerbehandlung für das Projekt

use thiserror::Error;

/// Projektspezifische Fehler
#[derive(Error, Debug, Clone, PartialEq)]
pub enum ProjectError {
    #[error("Division durch Null ist nicht erlaubt")]
    DivisionByZero,
    
    #[error("Overflow-Fehler: {0}")]
    OverflowError(String),
    
    #[error("Ungültige Eingabe: {0}")]
    InvalidInput(String),
    
    #[error("IO-Fehler: {0}")]
    IoError(String),
    
    #[error("Parsing-Fehler: {0}")]
    ParseError(String),
}

impl From<std::io::Error> for ProjectError {
    fn from(error: std::io::Error) -> Self {
        ProjectError::IoError(error.to_string())
    }
}

impl From<std::num::ParseIntError> for ProjectError {
    fn from(error: std::num::ParseIntError) -> Self {
        ProjectError::ParseError(error.to_string())
    }
}

impl From<std::num::ParseFloatError> for ProjectError {
    fn from(error: std::num::ParseFloatError) -> Self {
        ProjectError::ParseError(error.to_string())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_error_display() {
        let error = ProjectError::DivisionByZero;
        assert_eq!(error.to_string(), "Division durch Null ist nicht erlaubt");
    }

    #[test]
    fn test_overflow_error() {
        let error = ProjectError::OverflowError("Test overflow".to_string());
        assert_eq!(error.to_string(), "Overflow-Fehler: Test overflow");
    }

    #[test]
    fn test_invalid_input_error() {
        let error = ProjectError::InvalidInput("Invalid number".to_string());
        assert_eq!(error.to_string(), "Ungültige Eingabe: Invalid number");
    }

    #[test]
    fn test_io_error_conversion() {
        let io_error = std::io::Error::new(std::io::ErrorKind::NotFound, "File not found");
        let project_error = ProjectError::from(io_error);
        
        match project_error {
            ProjectError::IoError(msg) => assert!(msg.contains("File not found")),
            _ => panic!("Expected IoError"),
        }
    }

    #[test]
    fn test_parse_int_error_conversion() {
        let parse_error = "abc".parse::<i32>().unwrap_err();
        let project_error = ProjectError::from(parse_error);
        
        match project_error {
            ProjectError::ParseError(_) => (),
            _ => panic!("Expected ParseError"),
        }
    }

    #[test]
    fn test_parse_float_error_conversion() {
        let parse_error = "xyz".parse::<f64>().unwrap_err();
        let project_error = ProjectError::from(parse_error);
        
        match project_error {
            ProjectError::ParseError(_) => (),
            _ => panic!("Expected ParseError"),
        }
    }

    #[test]
    fn test_error_equality() {
        let error1 = ProjectError::DivisionByZero;
        let error2 = ProjectError::DivisionByZero;
        assert_eq!(error1, error2);
    }

    #[test]
    fn test_error_clone() {
        let error = ProjectError::DivisionByZero;
        let cloned = error.clone();
        assert_eq!(error, cloned);
    }
}
EOF

# src/modules/core.rs
cat > src/modules/core.rs << 'EOF'
//! Kernfunktionalität des Projekts

use crate::modules::error::ProjectError;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// Konfiguration für das Projekt
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Config {
    pub max_history_size: usize,
    pub precision: u32,
    pub debug_mode: bool,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            max_history_size: 1000,
            precision: 2,
            debug_mode: false,
        }
    }
}

/// Statistiken für Operationen
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Statistics {
    pub total_operations: u64,
    pub operation_counts: HashMap<String, u64>,
    pub average_result: f64,
    pub min_result: f64,
    pub max_result: f64,
}

impl Default for Statistics {
    fn default() -> Self {
        Self {
            total_operations: 0,
            operation_counts: HashMap::new(),
            average_result: 0.0,
            min_result: f64::MAX,
            max_result: f64::MIN,
        }
    }
}

impl Statistics {
    /// Erstellt neue Statistiken
    pub fn new() -> Self {
        Self::default()
    }

    /// Fügt eine Operation zu den Statistiken hinzu
    pub fn add_operation(&mut self, operation_type: &str, result: f64) {
        self.total_operations += 1;
        
        *self.operation_counts.entry(operation_type.to_string()).or_insert(0) += 1;
        
        if self.total_operations == 1 {
            self.average_result = result;
            self.min_result = result;
            self.max_result = result;
        } else {
            // Berechne neuen Durchschnitt
            let old_sum = self.average_result * (self.total_operations - 1) as f64;
            self.average_result = (old_sum + result) / self.total_operations as f64;
            
            // Aktualisiere Min/Max
            if result < self.min_result {
                self.min_result = result;
            }
            if result > self.max_result {
                self.max_result = result;
            }
        }
    }

    /// Gibt die Anzahl der Operationen eines bestimmten Typs zurück
    pub fn get_operation_count(&self, operation_type: &str) -> u64 {
        self.operation_counts.get(operation_type).copied().unwrap_or(0)
    }

    /// Prüft, ob Statistiken leer sind
    pub fn is_empty(&self) -> bool {
        self.total_operations == 0
    }

    /// Löscht alle Statistiken
    pub fn clear(&mut self) {
        *self = Self::default();
    }
}

/// Mathematische Hilfsfunktionen
pub struct MathUtils;

impl MathUtils {
    /// Berechnet den größten gemeinsamen Teiler
    pub fn gcd(a: u64, b: u64) -> u64 {
        if b == 0 {
            a
        } else {
            Self::gcd(b, a % b)
        }
    }

    /// Berechnet das kleinste gemeinsame Vielfache
    pub fn lcm(a: u64, b: u64) -> Result<u64, ProjectError> {
        if a == 0 || b == 0 {
            return Err(ProjectError::InvalidInput("LCM von Null ist nicht definiert".to_string()));
        }
        
        let gcd = Self::gcd(a, b);
        let result = (a / gcd).checked_mul(b)
            .ok_or_else(|| ProjectError::OverflowError("LCM Overflow".to_string()))?;
        
        Ok(result)
    }

    /// Prüft, ob eine Zahl eine Primzahl ist
    pub fn is_prime(n: u64) -> bool {
        if n < 2 {
            return false;
        }
        if n == 2 {
            return true;
        }
        if n % 2 == 0 {
            return false;
        }
        
        let sqrt_n = (n as f64).sqrt() as u64;
        for i in (3..=sqrt_n).step_by(2) {
            if n % i == 0 {
                return false;
            }
        }
        true
    }

    /// Berechnet die n-te Fibonacci-Zahl
    pub fn fibonacci(n: u64) -> Result<u64, ProjectError> {
        if n > 93 {
            return Err(ProjectError::OverflowError("Fibonacci Overflow".to_string()));
        }
        
        if n <= 1 {
            return Ok(n);
        }
        
        let mut a = 0;
        let mut b = 1;
        
        for _ in 2..=n {
            let temp = a.checked_add(b)
                .ok_or_else(|| ProjectError::OverflowError("Fibonacci Overflow".to_string()))?;
            a = b;
            b = temp;
        }
        
        Ok(b)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use rstest::rstest;

    #[test]
    fn test_config_default() {
        let config = Config::default();
        assert_eq!(config.max_history_size, 1000);
        assert_eq!(config.precision, 2);
        assert!(!config.debug_mode);
    }

    #[test]
    fn test_statistics_new() {
        let stats = Statistics::new();
        assert_eq!(stats.total_operations, 0);
        assert!(stats.is_empty());
    }

    #[test]
    fn test_statistics_add_operation() {
        let mut stats = Statistics::new();
        stats.add_operation("add", 5.0);
        
        assert_eq!(stats.total_operations, 1);
        assert_eq!(stats.get_operation_count("add"), 1);
        assert_eq!(stats.average_result, 5.0);
        assert_eq!(stats.min_result, 5.0);
        assert_eq!(stats.max_result, 5.0);
    }

    #[test]
    fn test_statistics_multiple_operations() {
        let mut stats = Statistics::new();
        stats.add_operation("add", 2.0);
        stats.add_operation("add", 8.0);
        stats.add_operation("multiply", 10.0);
        
        assert_eq!(stats.total_operations, 3);
        assert_eq!(stats.get_operation_count("add"), 2);
        assert_eq!(stats.get_operation_count("multiply"), 1);
        assert_eq!(stats.average_result, (2.0 + 8.0 + 10.0) / 3.0);
        assert_eq!(stats.min_result, 2.0);
        assert_eq!(stats.max_result, 10.0);
    }

    #[test]
    fn test_statistics_clear() {
        let mut stats = Statistics::new();
        stats.add_operation("add", 5.0);
        stats.clear();
        
        assert!(stats.is_empty());
        assert_eq!(stats.total_operations, 0);
    }

    #[rstest]
    #[case(12, 8, 4)]
    #[case(54, 24, 6)]
    #[case(17, 13, 1)]
    #[case(0, 5, 5)]
    fn test_gcd(#[case] a: u64, #[case] b: u64, #[case] expected: u64) {
        assert_eq!(MathUtils::gcd(a, b), expected);
    }

    #[rstest]
    #[case(12, 8, 24)]
    #[case(4, 6, 12)]
    #[case(7, 13, 91)]
    fn test_lcm(#[case] a: u64, #[case] b: u64, #[case] expected: u64) {
        assert_eq!(MathUtils::lcm(a, b).unwrap(), expected);
    }

    #[test]
    fn test_lcm_with_zero() {
        assert!(MathUtils::lcm(0, 5).is_err());
        assert!(MathUtils::lcm(5, 0).is_err());
    }

    #[rstest]
    #[case(2, true)]
    #[case(3, true)]
    #[case(17, true)]
    #[case(97, true)]
    #[case(1, false)]
    #[case(4, false)]
    #[case(15, false)]
    #[case(100, false)]
    fn test_is_prime(#[case] n: u64, #[case] expected: bool) {
        assert_eq!(MathUtils::is_prime(n), expected);
    }

    #[rstest]
    #[case(0, 0)]
    #[case(1, 1)]
    #[case(2, 1)]
    #[case(3, 2)]
    #[case(10, 55)]
    #[case(20, 6765)]
    fn test_fibonacci(#[case] n: u64, #[case] expected: u64) {
        assert_eq!(MathUtils::fibonacci(n).unwrap(), expected);
    }

    #[test]
    fn test_fibonacci_overflow() {
        assert!(MathUtils::fibonacci(100).is_err());
    }
}
EOF

# src/modules/utils.rs
cat > src/modules/utils.rs << 'EOF'
//! Hilfsfunktionen für das Projekt

use crate::modules::error::ProjectError;
use std::fs;
use std::path::Path;
use uuid::Uuid;

/// Formatiert eine Zahl mit einer bestimmten Genauigkeit
pub fn format_number(number: f64, precision: usize) -> String {
    format!("{:.precision$}", number, precision = precision)
}

/// Generiert eine eindeutige ID
pub fn generate_id() -> String {
    Uuid::new_v4().to_string()
}

/// Liest eine Datei und gibt den Inhalt zurück
pub fn read_file_content(file_path: &str) -> Result<String, ProjectError> {
    fs::read_to_string(file_path).map_err(ProjectError::from)
}

/// Schreibt Inhalt in eine Datei
pub fn write_file_content(file_path: &str, content: &str) -> Result<(), ProjectError> {
    fs::write(file_path, content).map_err(ProjectError::from)
}

/// Prüft, ob eine Datei existiert
pub fn file_exists(file_path: &str) -> bool {
    Path::new(file_path).exists()
}

/// Erstellt ein Verzeichnis, falls es nicht existiert
pub fn create_directory(dir_path: &str) -> Result<(), ProjectError> {
    if !Path::new(dir_path).exists() {
        fs::create_dir_all(dir_path).map_err(ProjectError::from)?;
    }
    Ok(())
}

/// Validiert eine Email-Adresse (einfache Überprüfung)
pub fn validate_email(email: &str) -> bool {
    email.contains('@') && email.contains('.') && email.len() > 5
}

/// Berechnet den Durchschnitt einer Liste von Zahlen
pub fn calculate_average(numbers: &[f64]) -> Result<f64, ProjectError> {
    if numbers.is_empty() {
        return Err(ProjectError::InvalidInput("Liste ist leer".to_string()));
    }
    
    let sum: f64 = numbers.iter().sum();
    Ok(sum / numbers.len() as f64)
}

/// Findet das Minimum in einer Liste von Zahlen
pub fn find_minimum(numbers: &[f64]) -> Result<f64, ProjectError> {
    if numbers.is_empty() {
        return Err(ProjectError::InvalidInput("Liste ist leer".to_string()));
    }
    
    Ok(numbers.iter().fold(f64::INFINITY, |a, &b| a.min(b)))
}

/// Findet das Maximum in einer Liste von Zahlen
pub fn find_maximum(numbers: &[f64]) -> Result<f64, ProjectError> {
    if numbers.is_empty() {
        return Err(ProjectError::InvalidInput("Liste ist leer".to_string()));
    }
    
    Ok(numbers.iter().fold(f64::NEG_INFINITY, |a, &b| a.max(b)))
}

/// Sortiert eine Liste von Zahlen
pub fn sort_numbers(numbers: &mut [f64]) {
    numbers.sort_by(|a, b| a.partial_cmp(b).unwrap());
}

/// Berechnet die Standardabweichung
pub fn calculate_standard_deviation(numbers: &[f64]) -> Result<f64, ProjectError> {
    if numbers.is_empty() {
        return Err(ProjectError::InvalidInput("Liste ist leer".to_string()));
    }
    
    let mean = calculate_average(numbers)?;
    let variance = numbers.iter()
        .map(|x| (x - mean).powi(2))
        .sum::<f64>() / numbers.len() as f64;
    
    Ok(variance.sqrt())
}

/// Konvertiert Celsius zu Fahrenheit
pub fn celsius_to_fahrenheit(celsius: f64) -> f64 {
    celsius * 9.0 / 5.0 + 32.0
}

/// Konvertiert Fahrenheit zu Celsius
pub fn fahrenheit_to_celsius(fahrenheit: f64) -> f64 {
    (fahrenheit - 32.0) * 5.0 / 9.0
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::NamedTempFile;
    use std::io::Write;

    #[test]
    fn test_format_number() {
        assert_eq!(format_number(3.14159, 2), "3.14");
        assert_eq!(format_number(10.0, 0), "10");
        assert_eq!(format_number(1.23456, 4), "1.2346");
    }

    #[test]
    fn test_generate_id() {
        let id1 = generate_id();
        let id2 = generate_id();
        
        assert_ne!(id1, id2);