#!/bin/zsh
# Script to set up a standard Python project structure and install dependencies

# Default project name if no argument is provided
if [ -z "$1" ]; then
  echo "No project name specified. Please provide a project name as an argument."
  echo "Usage: $0 project_name [python_package_name]"
  exit 1
fi

PROJECT_NAME="$1"
# If second argument is provided, use it as the Python package name
# Otherwise convert project name to lowercase and replace hyphens with underscores
if [ -z "$2" ]; then
  # Convert to lowercase and replace hyphens with underscores for Python package name
  PACKAGE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
else
  PACKAGE_NAME="$2"
fi

echo "Setting up $PROJECT_NAME project structure..."
echo "Using package name: $PACKAGE_NAME"

# Create project directories
mkdir -p "src/$PACKAGE_NAME" tests data "src/$PACKAGE_NAME/utils" "logs"

# You can customize directory structure based on project type
read -p "Create additional module directories? (agents, models, parsers, utils) [Y/n]: " CREATE_MODULES
if [[ "$CREATE_MODULES" != "n" && "$CREATE_MODULES" != "N" ]]; then
  mkdir -p "src/$PACKAGE_NAME/agents" "src/$PACKAGE_NAME/models" "src/$PACKAGE_NAME/tools"
fi

# Create essential files if they don't exist
touch README.md .gitignore pyproject.toml .env

# Add initialization files for Python packages
find "src/$PACKAGE_NAME" -type d -not -path "*/\.*" | while read -r dir; do
  if [ ! -s "$dir/__init__.py" ]; then
    echo "\"\"\"
$(basename "$dir") module for $PROJECT_NAME.
\"\"\"" > "$dir/__init__.py"
    echo "Created $dir/__init__.py"
  fi
done

# Add a professional main.py if it doesn't exist
if [ ! -s src/main.py ]; then
  cat <<EOL > src/main.py
#!/usr/bin/env python3
"""
$PROJECT_NAME - Main entry point

This script serves as the main entry point for the $PROJECT_NAME tool.
It handles command line arguments and orchestrates the process.
"""
import argparse
import logging
import os
import sys
from pathlib import Path

from dotenv import load_dotenv

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="$PROJECT_NAME - Python application"
    )
    parser.add_argument(
        "-f", "--file", 
        help="Path to input file to process",
        type=str
    )
    parser.add_argument(
        "-o", "--output", 
        help="Output directory for results",
        default="./data/output",
        type=str
    )
    parser.add_argument(
        "--verbose", 
        help="Enable verbose output",
        action="store_true"
    )
    return parser.parse_args()

def main():
    """Main entry point for the $PROJECT_NAME tool."""
    # Load environment variables
    load_dotenv()
    
    # Parse command line arguments
    args = parse_arguments()
    
    # Set log level based on verbosity
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
        logger.debug("Verbose logging enabled")
    
    logger.info("Starting $PROJECT_NAME")
    
    # Check if an input file was specified
    if args.file:
        input_file = Path(args.file)
        if not input_file.exists():
            logger.error(f"Input file not found: {args.file}")
            sys.exit(1)
        logger.info(f"Processing input file: {input_file}")
    else:
        logger.info("No input file specified. Use --file to specify a file to process.")
    
    # Create output directory if it doesn't exist
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # TODO: Implement $PROJECT_NAME logic here
    logger.info("Process complete")

if __name__ == "__main__":
    main()
EOL
  echo "Created professional main.py"
fi

# Add basic .gitignore for Python
cat <<EOL > .gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.venv/
venv/
ENV/

# VS Code
.vscode/
EOL

# Ask for project details
read -p "Project description: " PROJECT_DESCRIPTION
if [ -z "$PROJECT_DESCRIPTION" ]; then
  PROJECT_DESCRIPTION="A Python project"
fi

read -p "Author name [Your Name]: " AUTHOR_NAME
if [ -z "$AUTHOR_NAME" ]; then
  AUTHOR_NAME="Your Name"
fi

read -p "Author email [your.email@example.com]: " AUTHOR_EMAIL
if [ -z "$AUTHOR_EMAIL" ]; then
  AUTHOR_EMAIL="your.email@example.com"
fi

read -p "GitHub username [yourusername]: " GITHUB_USERNAME
if [ -z "$GITHUB_USERNAME" ]; then
  GITHUB_USERNAME="yourusername"
fi

# Add professional pyproject.toml if empty
if [ ! -s pyproject.toml ]; then
  cat <<EOL > pyproject.toml
[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
version = "0.1.0"
description = "$PROJECT_DESCRIPTION"
authors = [
    {name = "$AUTHOR_NAME", email = "$AUTHOR_EMAIL"}
]
readme = "README.md"
requires-python = ">=3.8"
license = {text = "MIT"}
classifiers = [
    "Programming Language :: Python :: 3",
    "License :: OSI Approved :: MIT License",
    "Operating System :: OS Independent",
]
dependencies = [
    "python-dotenv",
    # Add common dependencies below, uncomment as needed
    # "numpy",
    # "pandas",
    # "matplotlib",
    # "requests",
    # "openai",
]

[project.urls]
"Homepage" = "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME"
"Bug Tracker" = "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/issues"

[tool.setuptools.packages.find]
where = ["src"]
exclude = ["tests*"]

[tool.black]
line-length = 88

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
EOL
fi

# Add setup.py if it doesn't exist
if [ ! -s setup.py ]; then
  cat <<EOL > setup.py
"""
$PROJECT_NAME - Setup configuration
"""

from setuptools import setup

if __name__ == "__main__":
    setup(
        name="$PROJECT_NAME",
        package_dir={"": "src"},
        extras_require={
            "dev": [
                "pytest>=7.0.0",
                "pytest-cov>=4.0.0",
                "black>=23.0.0",
                "isort>=5.12.0",
                "mypy>=1.0.0",
                "pylint>=2.17.0",
            ]
        },
    )
EOL
fi

# Prepare for requirements.txt
echo "Setting up project dependencies..."
REQUIREMENTS=("python-dotenv>=1.0.0")  # Always include dotenv

# Data processing packages
echo "Do you want to include data processing packages?"
read -p "Include numpy? (y/N): " INCLUDE_NUMPY
if [[ "$INCLUDE_NUMPY" == "y" || "$INCLUDE_NUMPY" == "Y" ]]; then
  REQUIREMENTS+=("numpy>=1.24.0")
fi

read -p "Include pandas? (y/N): " INCLUDE_PANDAS
if [[ "$INCLUDE_PANDAS" == "y" || "$INCLUDE_PANDAS" == "Y" ]]; then
  REQUIREMENTS+=("pandas>=2.0.0")
fi

read -p "Include matplotlib? (y/N): " INCLUDE_MATPLOTLIB
if [[ "$INCLUDE_MATPLOTLIB" == "y" || "$INCLUDE_MATPLOTLIB" == "Y" ]]; then
  REQUIREMENTS+=("matplotlib>=3.7.0")
fi

# Web and API packages
echo "Do you want to include web/API packages?"
read -p "Include requests? (y/N): " INCLUDE_REQUESTS
if [[ "$INCLUDE_REQUESTS" == "y" || "$INCLUDE_REQUESTS" == "Y" ]]; then
  REQUIREMENTS+=("requests>=2.31.0")
fi

read -p "Include FastAPI? (y/N): " INCLUDE_FASTAPI
if [[ "$INCLUDE_FASTAPI" == "y" || "$INCLUDE_FASTAPI" == "Y" ]]; then
  REQUIREMENTS+=("fastapi>=0.104.0")
  REQUIREMENTS+=("uvicorn>=0.23.0")
fi

# Machine learning packages
echo "Do you want to include ML/AI packages?"
read -p "Include scikit-learn? (y/N): " INCLUDE_SKLEARN
if [[ "$INCLUDE_SKLEARN" == "y" || "$INCLUDE_SKLEARN" == "Y" ]]; then
  REQUIREMENTS+=("scikit-learn>=1.3.0")
fi

read -p "Include OpenAI? (y/N): " INCLUDE_OPENAI
if [[ "$INCLUDE_OPENAI" == "y" || "$INCLUDE_OPENAI" == "Y" ]]; then
  REQUIREMENTS+=("openai>=1.0.0")
fi

# Ask for additional custom packages
read -p "Add any other packages (comma-separated, leave empty to skip): " CUSTOM_PACKAGES
if [ -n "$CUSTOM_PACKAGES" ]; then
  IFS=',' read -ra CUSTOM_ARRAY <<< "$CUSTOM_PACKAGES"
  for pkg in "${CUSTOM_ARRAY[@]}"; do
    # Trim whitespace
    pkg=$(echo "$pkg" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    if [ -n "$pkg" ]; then
      REQUIREMENTS+=("$pkg")
    fi
  done
fi

# Generate requirements.txt from the array
if [ ! -s requirements.txt ]; then
  echo "# Requirements for $PROJECT_NAME" > requirements.txt
  for req in "${REQUIREMENTS[@]}"; do
    echo "$req" >> requirements.txt
  done
  
  # Add commented sections for reference
  cat <<EOL >> requirements.txt

# Other useful packages you might need later:

# Web and API
# flask>=2.2.0
# django>=4.2.0
# pydantic>=2.0.0

# Data processing
# scipy>=1.10.0
# seaborn>=0.12.0

# Machine learning and AI
# langchain>=0.0.335
# tensorflow>=2.12.0
# torch>=2.0.0
EOL

  echo "Created requirements.txt with selected packages"
fi

# Create sample test file
mkdir -p tests
if [ ! -s tests/test_basic.py ]; then
  cat <<EOL > tests/test_basic.py
"""
Basic tests for $PROJECT_NAME functionality.
"""
import pytest


def test_import():
    """Test that the package can be imported."""
    import $PACKAGE_NAME
    assert True  # Replace with actual version check once implemented


def test_placeholder():
    """Placeholder test."""
    assert True
EOL
fi

# Ask if user wants to create a virtual environment
read -p "Create and activate virtual environment? [Y/n]: " CREATE_VENV
if [[ "$CREATE_VENV" != "n" && "$CREATE_VENV" != "N" ]]; then
  # Check for available Python versions
  PYTHON_VERSIONS=()
  
  # Check for python3 command
  if command -v python3 &>/dev/null; then
    PY3_VERSION=$(python3 --version 2>&1)
    PYTHON_VERSIONS+=("python3 ($PY3_VERSION)")
  fi
  
  # Check for specific python versions
  for ver in 3.8 3.9 3.10 3.11 3.12; do
    if command -v python$ver &>/dev/null; then
      PY_VER_VERSION=$(python$ver --version 2>&1)
      PYTHON_VERSIONS+=("python$ver ($PY_VER_VERSION)")
    fi
  done
  
  # Choose Python version if multiple are available
  PYTHON_CMD="python3"  # Default
  if [ ${#PYTHON_VERSIONS[@]} -gt 1 ]; then
    echo "Multiple Python versions detected:"
    for i in "${!PYTHON_VERSIONS[@]}"; do
      echo "  $((i+1)). ${PYTHON_VERSIONS[$i]}"
    done
    read -p "Select Python version to use (1-${#PYTHON_VERSIONS[@]}): " PYTHON_CHOICE
    
    # Validate selection and extract command
    if [[ "$PYTHON_CHOICE" =~ ^[0-9]+$ ]] && [ "$PYTHON_CHOICE" -ge 1 ] && [ "$PYTHON_CHOICE" -le "${#PYTHON_VERSIONS[@]}" ]; then
      SELECTED_VERSION="${PYTHON_VERSIONS[$((PYTHON_CHOICE-1))]}"
      PYTHON_CMD="${SELECTED_VERSION%% *}"  # Extract just the command part before the space
    else
      echo "Invalid selection, using default (python3)"
    fi
  elif [ ${#PYTHON_VERSIONS[@]} -eq 1 ]; then
    PYTHON_CMD="${PYTHON_VERSIONS[0]%% *}"  # Extract just the command part
    echo "Using $PYTHON_CMD"
  else
    echo "No Python installations found. Please install Python 3.x before continuing."
    exit 1
  fi
  
  # Create virtual environment
  echo "Creating virtual environment with $PYTHON_CMD..."
  $PYTHON_CMD -m venv .venv
  
  # Determine OS for activation command
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
    # Windows
    echo "Activating virtual environment (Windows)..."
    # Use cmd.exe to run the batch file
    ACTIVATE_CMD=".venv\\Scripts\\activate"
    
    if [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
      # Git Bash or Cygwin
      source .venv/Scripts/activate
    else
      # Direct Windows Command Prompt or PowerShell
      echo "To activate the environment, run: $ACTIVATE_CMD"
      echo "After activation, run: pip install --upgrade pip && pip install -e \".[dev]\""
      VENV_CREATED=true
      return
    fi
  else
    # Unix-like OS (macOS, Linux)
    echo "Activating virtual environment (Unix)..."
    source .venv/bin/activate
  fi
  
  # Install dependencies
  pip install --upgrade pip
  pip install -e ".[dev]"
  
  VENV_CREATED=true
else
  VENV_CREATED=false
fi

# Create a basic README.md if it doesn't exist or is empty
if [ ! -s README.md ]; then
  cat <<EOL > README.md
# $PROJECT_NAME

$PROJECT_DESCRIPTION

## Installation

\`\`\`bash
# Clone the repository
git clone https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git
cd $PROJECT_NAME

# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -e ".[dev]"
\`\`\`

## Usage

\`\`\`bash
python src/main.py --help
\`\`\`

## Development

This project uses:
- [pytest](https://docs.pytest.org/) for testing
- [black](https://black.readthedocs.io/) for code formatting
- [isort](https://pycqa.github.io/isort/) for import sorting
- [mypy](https://mypy.readthedocs.io/) for static type checking

## License

MIT
EOL
fi

echo "\n✅ Professional project structure created for $PROJECT_NAME!"
if [ "$VENV_CREATED" = true ]; then
  echo "✅ Virtual environment set up in .venv/"
  echo "✅ Dependencies installed"
fi

echo "\n📋 Next steps:"
echo "  1. Review project metadata in pyproject.toml"
echo "  2. Update the README.md with your project details"
echo "  3. Start implementing your code in src/$PACKAGE_NAME/"

if [ "$VENV_CREATED" = true ]; then
  echo "\n🚀 Virtual environment is already activated. Happy coding!"
else
  echo "\n🚀 To create a virtual environment, run:"
  echo "   python3 -m venv .venv && source .venv/bin/activate && pip install -e \".[dev]\""
fi
