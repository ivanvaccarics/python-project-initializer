# Python Project Setup Script

This shell script helps you quickly create a professional Python project structure with customizable features. It automates the creation of directories, configuration files, and sets up a development environment, saving you time when starting new Python projects.

## Features

- **Customizable project structure** with flexible module directories
- **Dynamic Python package detection** to use the right Python version
- **Cross-platform compatibility** (macOS, Linux, Windows)
- **Interactive package selection** for requirements.txt
- **Project metadata** customization (author, description, etc.)
- **Development tooling setup** (pytest, black, isort, mypy)
- **Virtual environment creation** and dependency installation

## Usage

```bash
./setup_project.sh project_name [python_package_name]
```

### Arguments:

- `project_name`: The name of your project (required)
- `python_package_name`: The name of the Python package (optional, defaults to project_name converted to snake_case)

### Example:

```bash
# Basic usage
./setup_project.sh my-awesome-project

# With custom package name
./setup_project.sh "My Awesome Project" awesome_pkg
```

## Interactive Features

The script will prompt you for:

1. **Module structure**: Whether to create additional module directories like agents, models, etc.
2. **Project details**: Description, author name, email, GitHub username
3. **Dependencies**: Select which packages to include in requirements.txt 
4. **Python version**: Choose from available Python 3.x installations
5. **Virtual environment**: Option to create and activate a virtual environment

## Project Structure

The script creates the following structure:

```
my-project/
├── .env                   # Environment variables
├── .gitignore             # Git ignore file
├── README.md              # Project documentation
├── pyproject.toml         # Project metadata and build configuration
├── requirements.txt       # Project dependencies
├── setup.py               # Setup script for pip install
├── src/
│   ├── my_project/        # Main package
│   │   ├── __init__.py
│   │   ├── utils/         # Utility functions
│   │   │   └── __init__.py
│   │   ├── agents/        # Optional: agent modules
│   │   │   └── __init__.py
│   │   ├── models/        # Optional: data models
│   │   │   └── __init__.py
│   │   └── tools/         # Optional: tools
│   │       └── __init__.py
│   └── main.py            # Main entry point
├── tests/                 # Test directory
│   └── test_basic.py      # Basic tests
└── logs/                  # Log files
```

## Dependencies Management

The script allows you to interactively select common packages:

- **Data processing**: numpy, pandas, matplotlib
- **Web & API**: requests, FastAPI (with uvicorn)
- **Machine learning**: scikit-learn, OpenAI
- **Custom packages**: Add your own packages via comma-separated input

## Virtual Environment

For macOS/Linux, the script will:
```bash
source .venv/bin/activate
```

For Windows (Git Bash, Cygwin):
```bash
source .venv/Scripts/activate
```

For Windows (Command Prompt, PowerShell), the script will provide instructions.

## Requirements

- Zsh shell (can be modified for bash)
- Python 3.8 or later
- Internet connection (for installing dependencies)

## License

MIT
