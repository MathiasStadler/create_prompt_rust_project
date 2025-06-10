# create prompt rust project

## prompt

Generate a rust project with follow properties:

## Environment Setup

Create a program with the following function and observe the following conditions

- Function
  
  The program should be started on the command line and request a character string as input and output this again in capital letters on the command line. The program should then be terminated. The return value of the program should then be output

- Condition

  - OS: Linux/Unix
  - IDE: Visual Studio Code
  - Language: Rust (latest stable version)
  - Follow Rust standard formatting
  - Coverage Tools: LLVM Coverage, Coverage Gutters extension
  - Make every thing inside a rust program files, not used any bash script
  - Create a new project folder inside a subfolder of project inside local filesystem
  - The test of the program should cover 100% of the rust code
  - Write for each function , line, region ,blo- All test should covert 100% of the program code and branch a testcase
  - Include comprehensive test cases
  - Implement error handling and it
  - Add documentation comments
  - Generate coverage reports
  - - Create project documentation as markdown with:
    - Project name and creation date (with timezone)
    - Environment details
    - System configuration
    - Build status
    - Test results
    - Coverage metrics
  - Test the output from any line to stdout
  - Use assert_cmd too
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
  - Add the readme.md a blank line
