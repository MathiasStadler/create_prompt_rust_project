# create prompt rust project

## prompt

Generate a rust project with follow properties:

## Environment Setup

- OS: Linux/Unix
- IDE: Visual Studio Code
- Language: Rust (latest stable version)
- Coverage Tools: LLVM Coverage, Coverage Gutters extension
- Make every thing inside a rust program files, not used any bash script
- Follow Rust standard formatting
- Include comprehensive test cases
- Implement error handling
- Add documentation comments
- Generate coverage reports
- - Create project documentation as markdown with:
  - Project name and creation date (with timezone)
  - Environment details
  - System configuration
  - Build status
  - Test results
  - Coverage metrics
- Write for each function , line, region ,block and branch a testcase
- All test should covert 100% of the program code
- Test the output from any line to stdout
- Use assert_cmd too
- Create a new project folder inside the /tmp local filesystem
- Test before the folder is not available
- Inside this new folder create a new markdown file with the name project_path.md
- And project_path.md follows these properties and fills in the current data with the hardware now in used
  - name of project
  - start date
  - used os
  - used hardware
  - used rust version
- Generate a changelog.md file
- Write for all function a documentation inside the code
- Use comments to make code more readable
- Use a hashmap to store data
- Build the project with cargo
- Create a demo example
- Generate an error message when folder exists
