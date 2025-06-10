// integration_tests.rs

use assert_cmd::Command;
use predicates::prelude::*;

#[test]
fn test_cli_valid_input() {
    let mut cmd = Command::cargo_bin("rust-project").unwrap();
    cmd.write_stdin("hello\n")
        .assert()
        .success()
        .stdout(predicate::str::contains("HELLO"));
}

#[test]
fn test_cli_empty_input() {
    let mut cmd = Command::cargo_bin("rust-project").unwrap();
    cmd.write_stdin("\n")
        .assert()
        .failure();
}