# Task: Create a Command-Line String Uppercase Converter in Rust

## Project Requirements

### Core Functionality

1. Create a command-line application in Rust that:
   - Accepts string input from users
   - Converts the input to uppercase
   - Displays the result

### Technical Requirements

1. Project Structure:
   - Proper Rust project layout with Cargo
   - Separate library and binary crates
   - Organized test directory

2. Dependencies:
   - Use `clap` for CLI argument parsing
   - Implement error handling with `anyhow` and `thiserror`
   - Set up testing with `assert_cmd` and `predicates`

3. Testing:
   - Unit tests for core functionality
   - Integration tests for CLI behavior
   - 100% test coverage requirement
   - Coverage reporting setup

### Documentation Requirements

1. Code Documentation:
   - Rustdoc comments for public APIs
   - Examples in documentation
   - Clear error messages

2. Project Documentation:
   - README.md with usage instructions
   - CHANGELOG.md following Keep a Changelog format
   - License file (MIT)

### Quality Standards

1. Code must:
   - Pass `cargo clippy` without warnings
   - Be formatted with `cargo fmt`
   - Have no unsafe code
   - Include error handling for all failure cases

### Deliverables

1. Source code
2. Documentation
3. Tests
4. Coverage reports
5. Build scripts
6. Example usage
