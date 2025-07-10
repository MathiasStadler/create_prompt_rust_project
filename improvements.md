# Key improvements in this version

1. **Zip File Creation**:
   - Added creation of a zip file with highest compression level (-9 flag)
   - The zip file is created in the parent directory of the project folder
   - Contains the entire project structure

2. **Output Capture**:
   - Captures test output and saves to test_output.txt
   - Captures program output with sample input and saves to program_output.txt
   - These files are included in the zip archive

3. **Coverage Report**:
   - Attempts to generate HTML coverage report if cargo-llvm-cov is installed
   - Includes coverage report in the zip file if generated

4. **Comprehensive Output**:
   - Provides clear feedback about what was created
   - Includes instructions for extracting the zip file
   - Lists all important generated files

To use this updated version:

1. Save the script as setup.sh
2. Make it executable: `chmod +x setup.sh`
3. Run it with your project name: `./setup.sh my_uppercase_converter`
4. The script will:
   - Create the project structure
   - Generate all files
   - Run tests and capture output
   - Execute the program with sample input
   - Create a zip file with highest compression containing everything
   - Provide a summary of what was created

The zip file will be named `[project_name]_project.zip` and will contain:
- Complete Rust project structure
- All documentation files
- Test output
- Program output
- Coverage report (if generated)