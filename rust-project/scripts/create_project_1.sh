#!/bin/bash
# setup.sh - Script to create and configure the Rust project

# Check if folder name is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a project name as argument"
    exit 1
fi

PROJECT_NAME=$1
PROJECT_DIR="project/$PROJECT_NAME"

# Check if folder already exists
if [ -d "$PROJECT_DIR" ]; then
    echo "Error: Folder $PROJECT_DIR already exists"
    exit 1
fi

# Create project structure
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# Initialize Cargo project
cargo init --bin

# Add required dependencies to Cargo.toml
cat >> Cargo.toml << 'EOL'
[dev-dependencies]
assert_cmd = "2.0"
predicates = "2.1"
EOL

# Create src/main.rs
cat > src/main.rs << 'EOL'
//! A simple program that converts input string to uppercase
//! 
//! # Usage
//! Run the program and enter a string when prompted. The program will
//! output the uppercase version of the string.

use std::collections::HashMap;
use std::io::{self, Write};

/// Main function that drives the program
/// 
/// # Returns
/// 
/// * `Result<(), io::Error>` - Returns Ok if successful, Err otherwise
fn main() -> io::Result<()> {
    // Create a HashMap to store input/output (though not really needed for this simple program)
    let mut input_map = HashMap::new();
    
    // Prompt user for input
    print!("Enter a string: ");
    io::stdout().flush()?;
    
    let mut input = String::new();
    io::stdin().read_line(&mut input)?;
    
    // Store original input in HashMap
    input_map.insert("original", input.trim());
    
    // Convert to uppercase and store in HashMap
    let uppercase = input_map["original"].to_uppercase();
    input_map.insert("uppercase", &uppercase);
    
    // Print the uppercase version
    println!("Uppercase: {}", uppercase);
    
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use assert_cmd::Command;
    use predicates::prelude::*;

    /// Test that the program runs and exits successfully
    #[test]
    fn test_program_runs() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        cmd.assert()
            .success();
        Ok(())
    }

    /// Test the uppercase conversion functionality
    #[test]
    fn test_uppercase_conversion() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        let input = "hello world";
        let expected = "HELLO WORLD";
        
        cmd.write_stdin(input)
            .assert()
            .stdout(predicate::str::contains(expected))
            .success();
            
        Ok(())
    }

    /// Test with empty input
    #[test]
    fn test_empty_input() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        cmd.write_stdin("")
            .assert()
            .stdout(predicate::str::contains("Uppercase: "))
            .success();
        Ok(())
    }

    /// Test with special characters
    #[test]
    fn test_special_chars() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        let input = "héllò wörld! 123";
        let expected = "HÉLLÒ WÖRLD! 123";
        
        cmd.write_stdin(input)
            .assert()
            .stdout(predicate::str::contains(expected))
            .success();
            
        Ok(())
    }
}
EOL

# Create project documentation files
cat > project_path.md << 'EOL'
# Project Information

- **Project Name**: $PROJECT_NAME
- **Start Date**: $(date '+%Y-%m-%d %H:%M:%S %Z')
- **OS**: $(uname -a)
- **Hardware**: $(lscpu | grep "Model name:" | cut -d':' -f2 | xargs)
- **Rust Version**: $(rustc --version)
EOL

cat > CHANGELOG.md << 'EOL'
# Changelog

## [0.1.0] - $(date '+%Y-%m-%d')
- Initial project setup
- Implemented basic uppercase conversion functionality
- Added comprehensive test cases
- Created project documentation
EOL
