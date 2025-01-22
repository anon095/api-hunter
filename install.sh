#!/bin/bash

# Go to the home directory to ensure correct paths
cd ~

# Define the base directory
BASE_DIR=$(pwd)

# Check if requirements.txt exists and install dependencies
if [ ! -f "$BASE_DIR/requirements.txt" ]; then
    echo "[ERROR] requirements.txt not found at $BASE_DIR"
    echo "Creating requirements.txt..."
    
    # Create requirements.txt with all necessary dependencies
    cat > "$BASE_DIR/requirements.txt" <<EOL
builtwith==1.3.4
requests==2.32.3
argparse==1.4.0
EOL
    echo "requirements.txt has been created."
else
    echo "Found requirements.txt. Proceeding to install dependencies."
fi

# Install Python dependencies from requirements.txt
echo "Installing Python dependencies from $BASE_DIR/requirements.txt..."
python3 -m venv apihunter-env  # Create a virtual environment (if not already created)
source apihunter-env/bin/activate  # Activate the virtual environment
pip install --upgrade pip  # Upgrade pip to the latest version
pip install -r "$BASE_DIR/requirements.txt"  # Install dependencies

# Clone necessary repositories (APIHunter, JSFinder, Katana)
# Clone APIHunter if it doesn't exist
if [ ! -d "$BASE_DIR/tools/APIHunter" ]; then
    echo "Cloning APIHunter repository..."
    git clone https://github.com/APIHunter/APIHunter "$BASE_DIR/tools/APIHunter"
else
    echo "APIHunter already exists. Skipping clone."
fi

# Clone JSFinder if it doesn't exist
if [ ! -d "$BASE_DIR/tools/JSFinder" ]; then
    echo "Cloning JSFinder repository..."
    git clone https://github.com/ignis-sec/JSFinder "$BASE_DIR/tools/JSFinder"
else
    echo "JSFinder already exists. Skipping clone."
fi

# Clone Katana if it doesn't exist
if [ ! -d "$BASE_DIR/tools/Katana" ]; then
    echo "Cloning Katana repository..."
    git clone https://github.com/PowerScript/Katana "$BASE_DIR/tools/Katana"
else
    echo "Katana already exists. Skipping clone."
fi

# Ensure Katana is executable
if [ -f "$BASE_DIR/tools/Katana/katana" ]; then
    chmod +x "$BASE_DIR/tools/Katana/katana"
    echo "Katana is now executable."
else
    echo "[ERROR] Katana binary not found. Please check the Katana directory."
fi

# Finish installation
echo "Tools installation and setup completed!"

# Run the APIHunter tool using api-hunter.sh (if available)
if [ -f "$BASE_DIR/tools/APIHunter/api-hunter.sh" ]; then
    echo "Running the api-hunter.sh tool..."
    source apihunter-env/bin/activate  # Ensure the virtual environment is activated
    bash "$BASE_DIR/tools/APIHunter/api-hunter.sh"  # Run the tool
else
    echo "[ERROR] api-hunter.sh not found. Please check the APIHunter directory."
fi

# Deactivate virtual environment after installation and execution
deactivate
