#!/bin/bash
# uppercase-converter.sh - Script to create, test, and package a Rust uppercase converter project

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Display usage information
usage() {
    cat <<EOF
${GREEN}Uppercase Converter Project Manager${NC}

${YELLOW}Usage:${NC}
  $0 [command] [options]

${YELLOW}Commands:${NC}
  create <project_name>    Create a new project
  test <project_dir>      Run tests on existing project
  run <project_dir>       Execute the program
  package <project_dir>   Create zip package of project
  clean <project_dir>     Remove build artifacts
  help                    Show this help message

${YELLOW}Examples:${NC}
  $0 create my_converter
  $0 test project/my_converter
  $0 run project/my_converter
  $0 package project/my_converter
EOF
    exit 1
}

# Create a new project
create_project() {
    local project_name=$1
    local project_dir="project/$project_name"

    if [[ -d "$project_dir" ]]; then
        echo -e "${RED}Error: Project directory '$project_dir' already exists${NC}"
        exit 1
    fi

    echo -e "${GREEN}Creating new project '$project_name'...${NC}"
    mkdir -p "$project_dir"
    cd "$project_dir" || exit 1

    # Initialize Cargo project
    cargo init --bin

    # Add dependencies
    cat >> Cargo.toml << 'EOL'
[dev-dependencies]
assert_cmd = "2.0"
predicates = "2.1"
EOL

    # Create main.rs with the program code
    cat > src/main.rs << 'EOL'
//! Uppercase String Converter
//! Converts input strings to uppercase

use std::collections::HashMap;
use std::io::{self, Write};

fn main() -> io::Result<()> {
    let mut input_map = HashMap::new();
    
    print!("Enter a string: ");
    io::stdout().flush()?;
    
    let mut input = String::new();
    io::stdin().read_line(&mut input)?;
    
    input_map.insert("original", input.trim());
    let uppercase = input_map["original"].to_uppercase();
    input_map.insert("uppercase", &uppercase);
    
    println!("Uppercase: {}", uppercase);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use assert_cmd::Command;
    use predicates::prelude::*;

    #[test]
    fn test_program_runs() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        cmd.assert().success();
        Ok(())
    }

    #[test]
    fn test_uppercase_conversion() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        cmd.write_stdin("hello world")
            .assert()
            .stdout(predicate::str::contains("HELLO WORLD"))
            .success();
        Ok(())
    }
}
EOL

    # Create documentation files
    create_documentation "$project_name"

    echo -e "${GREEN}Project created successfully in $project_dir${NC}"
}

# Create project documentation
create_documentation() {
    local project_name=$1

    cat > project_path.md << EOL
# Project Information

- **Project Name**: $project_name
- **Created**: $(date '+%Y-%m-%d %H:%M:%S %Z')
- **OS**: $(uname -a)
- **CPU**: $(lscpu | grep "Model name" | cut -d: -f2 | sed 's/^[ \t]*//')
- **Memory**: $(grep MemTotal /proc/meminfo | awk '{print $2/1024 " MB"}')
- **Rust Version**: $(rustc --version)
EOL

    cat > CHANGELOG.md << 'EOL'
# Changelog

## [Unreleased]
### Added
- Initial project setup
- Uppercase conversion functionality
- Comprehensive test cases
EOL

    cat > README.md << EOL
# $project_name

String to Uppercase Converter

## Building
\`\`\`sh
cargo build
\`\`\`

## Running
\`\`\`sh
cargo run
\`\`\`

## Testing
\`\`\`sh
cargo test
\`\`\`

## Coverage
\`\`\`sh
rustup component add llvm-tools-preview
cargo install cargo-llvm-cov
cargo llvm-cov --html
\`\`\`
EOL

    echo "" >> README.md
}

# Run tests on project
test_project() {
    local project_dir=$1
    cd "$project_dir" || exit 1
    
    echo -e "${GREEN}Running tests...${NC}"
    cargo test -- --nocapture
    
    if command -v cargo-llvm-cov &>/dev/null; then
        echo -e "${GREEN}Generating coverage report...${NC}"
        cargo llvm-cov --html
        echo "Coverage report available in target/llvm-cov/html"
    else
        echo -e "${YELLOW}Warning: cargo-llvm-cov not installed. Skipping coverage report.${NC}"
    fi
}

# Run the program
run_project() {
    local project_dir=$1
    cd "$project_dir" || exit 1
    
    echo -e "${GREEN}Running program (type input and press Enter):${NC}"
    cargo run
}

# Package the project
package_project() {
    local project_dir=$1
    local project_name=$(basename "$project_dir")
    local zip_file="${project_name}_$(date +%Y%m%d).zip"
    
    echo -e "${GREEN}Packaging project...${NC}"
    
    # Ensure we're in the project directory
    cd "$project_dir/.." || exit 1
    
    # Create zip with maximum compression
    if command -v 7z &>/dev/null; then
        7z a -mx=9 "$zip_file" "$project_name"
    else
        zip -9 -r "$zip_file" "$project_name"
    fi
    
    echo -e "${GREEN}Created package: $zip_file${NC}"
}

# Clean build artifacts
clean_project() {
    local project_dir=$1
    cd "$project_dir" || exit 1
    
    echo -e "${GREEN}Cleaning project...${NC}"
    cargo clean
}

# Main script execution
main() {
    if [[ $# -lt 1 ]]; then
        usage
    fi

    case $1 in
        create)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project name required${NC}"
                usage
            fi
            create_project "$2"
            ;;
        test)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project directory required${NC}"
                usage
            fi
            test_project "$2"
            ;;
        run)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project directory required${NC}"
                usage
            fi
            run_project "$2"
            ;;
        package)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project directory required${NC}"
                usage
            fi
            package_project "$2"
            ;;
        clean)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project directory required${NC}"
                usage
            fi
            clean_project "$2"
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown command '$1'${NC}"
            usage
            ;;
    esac
}

main "$@"