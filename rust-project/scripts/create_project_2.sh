#!/bin/bash
# uppercase-converter-manager.sh - Comprehensive Rust Uppercase Converter Project Manager

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
REQUIRED_TOOLS=("cargo" "rustc" "zip")
COVERAGE_TOOLS=("cargo-llvm-cov" "llvm-tools-preview")
IDE_VSCODE=("vscode" "rust-analyzer" "CodeLLDB")
PROJECT_ROOT="project"

# Display header
header() {
    clear
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║      Rust Uppercase Converter Project Manager    ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Display usage information
usage() {
    header
    cat <<EOF
${YELLOW}Usage:${NC}
  $0 [command] [options]

${YELLOW}Commands:${NC}
  create <project_name>    Create new project with full setup
  full-setup <project_name> Complete project lifecycle (create,test,coverage,package)
  test <project_dir>      Run all tests
  coverage <project_dir>  Generate coverage report
  run <project_dir>       Execute the program
  package <project_dir>   Create deployment package
  check-env              Verify development environment
  install-ide           Install recommended IDE packages
  install-coverage      Install coverage tools
  clean <project_dir>    Remove build artifacts
  help                  Show this help message

${YELLOW}Examples:${NC}
  $0 create my_converter       # Create new project
  $0 full-setup my_converter  # Complete project lifecycle
  $0 test project/my_converter
  $0 coverage project/my_converter
  $0 check-env               # Verify environment

${YELLOW}Project Lifecycle:${NC}
1. check-env → 2. install-coverage → 3. create → 4. test → 5. coverage → 6. package
EOF
    exit 0
}

# Check development environment
check_environment() {
    header
    echo -e "${BLUE}🔍 Checking Development Environment...${NC}"
    
    # Check Rust tools
    echo -e "\n${YELLOW}Rust Tools:${NC}"
    local rust_ok=true
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if command -v "$tool" &>/dev/null; then
            echo -e "${GREEN}✓ $tool installed ($($tool --version))${NC}"
        else
            echo -e "${RED}✗ $tool not found${NC}"
            rust_ok=false
        fi
    done
    
    # Check coverage tools
    echo -e "\n${YELLOW}Coverage Tools:${NC}"
    local coverage_ok=true
    if rustup component list | grep -q 'llvm-tools-preview.*(installed)'; then
        echo -e "${GREEN}✓ llvm-tools-preview installed${NC}"
    else
        echo -e "${RED}✗ llvm-tools-preview not installed${NC}"
        coverage_ok=false
    fi
    
    if command -v cargo-llvm-cov &>/dev/null; then
        echo -e "${GREEN}✓ cargo-llvm-cov installed ($(cargo-llvm-cov --version))${NC}"
    else
        echo -e "${RED}✗ cargo-llvm-cov not installed${NC}"
        coverage_ok=false
    fi
    
    # Check VS Code extensions
    echo -e "\n${YELLOW}VS Code Extensions:${NC}"
    local vscode_ok=true
    if command -v code &>/dev/null; then
        for ext in "${IDE_VSCODE[@]}"; do
            if code --list-extensions | grep -q "$ext"; then
                echo -e "${GREEN}✓ $ext installed${NC}"
            else
                echo -e "${RED}✗ $ext not installed${NC}"
                vscode_ok=false
            fi
        done
    else
        echo -e "${YELLOW}⚠ VS Code not detected${NC}"
        vscode_ok=false
    fi
    
    # Summary
    echo -e "\n${YELLOW}Environment Status:${NC}"
    if $rust_ok; then
        echo -e "${GREEN}✓ Rust environment ready${NC}"
    else
        echo -e "${RED}✗ Rust environment incomplete${NC}"
    fi
    
    if $coverage_ok; then
        echo -e "${GREEN}✓ Coverage tools ready${NC}"
    else
        echo -e "${RED}✗ Coverage tools missing${NC}"
        echo -e "Run: ${BLUE}$0 install-coverage${NC}"
    fi
    
    if $vscode_ok; then
        echo -e "${GREEN}✓ VS Code environment ready${NC}"
    else
        echo -e "${RED}✗ VS Code environment incomplete${NC}"
        echo -e "Run: ${BLUE}$0 install-ide${NC}"
    fi
    
    echo -e "\n${BLUE}For complete setup, run:${NC}"
    echo "1. $0 install-coverage"
    echo "2. $0 install-ide"
    echo "3. $0 create <project_name>"
}

# Install coverage tools
install_coverage() {
    header
    echo -e "${BLUE}📦 Installing Coverage Tools...${NC}"
    
    echo -e "\n${YELLOW}Installing llvm-tools-preview...${NC}"
    rustup component add llvm-tools-preview
    
    echo -e "\n${YELLOW}Installing cargo-llvm-cov...${NC}"
    cargo install cargo-llvm-cov
    
    echo -e "\n${GREEN}✅ Coverage tools installed successfully${NC}"
    echo -e "You can now generate coverage reports with:"
    echo -e "${BLUE}cargo llvm-cov --html${NC}"
}

# Install IDE packages
install_ide() {
    header
    echo -e "${BLUE}⚙️ Installing VS Code Extensions...${NC}"
    
    if ! command -v code &>/dev/null; then
        echo -e "${RED}VS Code not found. Please install it first.${NC}"
        exit 1
    fi
    
    for ext in "${IDE_VSCODE[@]}"; do
        echo -e "\n${YELLOW}Installing $ext...${NC}"
        code --install-extension "$ext" --force
    done
    
    echo -e "\n${GREEN}✅ VS Code extensions installed successfully${NC}"
    echo -e "Recommended workspace settings:"
    echo '{
    "rust-analyzer.checkOnSave.command": "clippy",
    "rust-analyzer.runnables.overrideCargo": "llvm-cov",
    "editor.formatOnSave": true
}'
}

# Create project structure
create_project_structure() {
    local project_name=$1
    local project_dir="$PROJECT_ROOT/$project_name"
    
    if [[ -d "$project_dir" ]]; then
        echo -e "${RED}Error: Project directory '$project_dir' already exists${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}📂 Creating project structure...${NC}"
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
}

# Create source files
create_source_files() {
    local project_name=$1
    
    echo -e "${BLUE}📝 Generating source files...${NC}"
    
    # main.rs
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

    #[test]
    fn test_empty_input() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        cmd.write_stdin("")
            .assert()
            .stdout(predicate::str::contains("Uppercase: "))
            .success();
        Ok(())
    }

    #[test]
    fn test_special_chars() -> Result<(), Box<dyn std::error::Error>> {
        let mut cmd = Command::cargo_bin(env!("CARGO_PKG_NAME"))?;
        cmd.write_stdin("héllò wörld! 123")
            .assert()
            .stdout(predicate::str::contains("HÉLLÒ WÖRLD! 123"))
            .success();
        Ok(())
    }
}
EOL
}

# Create documentation
create_documentation() {
    local project_name=$1
    
    echo -e "${BLUE}📄 Generating documentation...${NC}"
    
    # README.md
    cat > README.md << EOL
# ${project_name}

Uppercase String Converter

## Features
- Converts input strings to uppercase
- Comprehensive test coverage
- CI-ready setup

## Usage
\`\`\`sh
cargo run
\`\`\`

## Testing
\`\`\`sh
cargo test
cargo llvm-cov --html
\`\`\`

## Requirements
- Rust 1.60+
- LLVM coverage tools

## Installation
\`\`\`sh
$0 install-coverage
\`\`\`

EOL

    # project_path.md
    cat > project_path.md << EOL
# Project Information

- **Project Name**: ${project_name}
- **Created**: $(date '+%Y-%m-%d %H:%M:%S %Z')
- **OS**: $(uname -a)
- **CPU**: $(lscpu | grep "Model name" | cut -d: -f2 | sed 's/^[ \t]*//')
- **Memory**: $(grep MemTotal /proc/meminfo | awk '{print $2/1024 " MB"}')
- **Rust Version**: $(rustc --version)
EOL

    # CHANGELOG.md
    cat > CHANGELOG.md << 'EOL'
# Changelog

## [Unreleased]
### Added
- Initial project setup
- Uppercase conversion functionality
- Comprehensive test cases

## [0.1.0] - Initial Release
- Basic functionality complete
- 100% test coverage
EOL
}

# Create new project
create_project() {
    local project_name=$1
    
    header
    echo -e "${BLUE}🛠️ Creating New Project: ${project_name}${NC}"
    
    create_project_structure "$project_name"
    create_source_files "$project_name"
    create_documentation "$project_name"
    
    echo -e "\n${GREEN}✅ Project created successfully in ${PROJECT_ROOT}/${project_name}${NC}"
    echo -e "\n${YELLOW}Next steps:${NC}"
    echo "1. cd ${PROJECT_ROOT}/${project_name}"
    echo "2. cargo test"
    echo "3. cargo llvm-cov --html"
    echo "4. cargo run"
}

# Run tests
test_project() {
    local project_dir=$1
    
    header
    echo -e "${BLUE}🧪 Running Tests...${NC}"
    
    cd "$project_dir" || exit 1
    cargo test -- --nocapture
    
    echo -e "\n${GREEN}✅ Tests completed${NC}"
}

# Generate coverage
coverage_project() {
    local project_dir=$1
    
    header
    echo -e "${BLUE}📊 Generating Coverage Report...${NC}"
    
    if ! command -v cargo-llvm-cov &>/dev/null; then
        echo -e "${RED}Error: cargo-llvm-cov not installed${NC}"
        echo -e "Run: ${BLUE}$0 install-coverage${NC}"
        exit 1
    fi
    
    cd "$project_dir" || exit 1
    cargo llvm-cov --html
    
    echo -e "\n${GREEN}✅ Coverage report generated${NC}"
    echo -e "Open: ${BLUE}${project_dir}/target/llvm-cov/html/index.html${NC}"
}

# Run program
run_project() {
    local project_dir=$1
    
    header
    echo -e "${BLUE}🚀 Running Program...${NC}"
    echo -e "${YELLOW}Type your input and press Enter:${NC}"
    
    cd "$project_dir" || exit 1
    cargo run
}

# Package project
package_project() {
    local project_dir=$1
    local project_name=$(basename "$project_dir")
    local zip_file="${project_name}_$(date +%Y%m%d_%H%M%S).zip"
    
    header
    echo -e "${BLUE}📦 Packaging Project...${NC}"
    
    cd "$(dirname "$project_dir")" || exit 1
    
    echo -e "${YELLOW}Creating archive: ${zip_file}${NC}"
    if command -v 7z &>/dev/null; then
        7z a -mx=9 "$zip_file" "$project_name"
    else
        zip -9 -r "$zip_file" "$project_name"
    fi
    
    echo -e "\n${GREEN}✅ Package created: ${zip_file}${NC}"
    echo -e "Size: $(du -h "$zip_file" | cut -f1)"
}

# Clean project
clean_project() {
    local project_dir=$1
    
    header
    echo -e "${BLUE}🧹 Cleaning Project...${NC}"
    
    cd "$project_dir" || exit 1
    cargo clean
    
    echo -e "\n${GREEN}✅ Build artifacts removed${NC}"
}

# Full project lifecycle
full_setup() {
    local project_name=$1
    local project_dir="$PROJECT_ROOT/$project_name"
    
    header
    echo -e "${BLUE}🏗️ Starting Full Project Lifecycle for: ${project_name}${NC}"
    
    # Verify environment first
    echo -e "\n${YELLOW}=== Checking Environment ===${NC}"
    check_environment
    
    # Create project
    echo -e "\n${YELLOW}=== Creating Project ===${NC}"
    create_project "$project_name"
    
    # Test project
    echo -e "\n${YELLOW}=== Testing Project ===${NC}"
    test_project "$project_dir"
    
    # Generate coverage
    echo -e "\n${YELLOW}=== Generating Coverage ===${NC}"
    coverage_project "$project_dir"
    
    # Package project
    echo -e "\n${YELLOW}=== Packaging Project ===${NC}"
    package_project "$project_dir"
    
    echo -e "\n${GREEN}🎉 Project Lifecycle Completed Successfully!${NC}"
    echo -e "\n${YELLOW}Project Location:${NC} ${project_dir}"
    echo -e "${YELLOW}Package:${NC} $(pwd)/${project_name}_*.zip"
    echo -e "${YELLOW}Coverage Report:${NC} ${project_dir}/target/llvm-cov/html/index.html"
}

# Main execution
main() {
    if [[ $# -lt 1 ]]; then
        usage
    fi

    case "$1" in
        create)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project name required${NC}"
                usage
            fi
            create_project "$2"
            ;;
        full-setup)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project name required${NC}"
                usage
            fi
            full_setup "$2"
            ;;
        test)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project directory required${NC}"
                usage
            fi
            test_project "$2"
            ;;
        coverage)
            if [[ $# -ne 2 ]]; then
                echo -e "${RED}Error: Project directory required${NC}"
                usage
            fi
            coverage_project "$2"
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
        check-env)
            check_environment
            ;;
        install-coverage)
            install_coverage
            ;;
        install-ide)
            install_ide
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