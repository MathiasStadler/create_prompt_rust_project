# Uppercase Converter Project Manager

A comprehensive tool for creating, testing, and packaging a Rust-based uppercase string converter project.

## Key Features

1. **Project Creation**:
   - Automatically generates a complete Rust project structure
   - Sets up all necessary files (source code, tests, documentation)
   - Configures Cargo.toml with required dependencies

2. **Testing Framework**:
   - Built-in test cases covering 100% of the code
   - Support for LLVM coverage reports
   - Includes tests for normal cases, empty input, and special characters

3. **Execution Management**:
   - Run the program with interactive input
   - Capture and display program output

4. **Packaging**:
   - Creates compressed archives (ZIP format)
   - Uses maximum compression level
   - Includes all project files and documentation

5. **Documentation**:
   - Auto-generates:
     - README.md with usage instructions
     - CHANGELOG.md with version history
     - project_path.md with system information
   - Includes code documentation in Rust files

6. **Cross-Platform Support**:
   - Works on Linux/Unix systems
   - Compatible with Visual Studio Code
   - Follows Rust standards and best practices

7. **Error Handling**:
   - Comprehensive input validation
   - Clear error messages
   - Prevents overwriting existing projects

## Usage Examples

### Basic Commands

1. **Create a new project**:
   ```bash
   ./uppercase-converter.sh create my_project