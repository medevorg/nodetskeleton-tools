#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Error: project-name is required"
  exit 1
fi

# Print the current directory
echo "Working on directory: $PWD"

# Check if pnpm or npm is installed in the system
PNPM_VERSION=$(pnpm --version 2>/dev/null)
NPM_VERSION=$(npm --version 2>/dev/null)
if [ -z "$PNPM_VERSION" ] && [ -z "$NPM_VERSION" ]; then
  echo "Error: pnpm or npm is required to install the dependencies"
  exit 1
fi

# Clone the repository from https://github.com/medevorg/nodetskeleton.git
echo "Cloning the nodetskeleton from origin"
git clone https://github.com/medevorg/nodetskeleton.git

# Check if the repository was cloned in folder nodetskeleton
if [ ! -d "nodetskeleton" ]; then
  echo "Error: Failed to clone the repository"
  exit 1
fi

# Rename the current directory name nodetskeleton to project-name provided
echo "Preparing your project $1"
mv nodetskeleton $1
rm -rf nodetskeleton

# Install dependencies
echo "Installing dependencies"
cd $1
if [ ! -z "$PNPM_VERSION" ]; then
  echo "Using pnpm $PNPM_VERSION"
  pnpm install
else
  echo "Using npm $NPM_VERSION"
  npm install
fi

# Create resources
echo "NODE_ENV=dev
SERVICE_CONTEXT=
SERVER_ROOT=/api
SERVER_HOST=localhost
SERVER_PORT=3003
ORIGINS=http://localhost:3003
ENCRYPTION_KEY=JUS9192ZliRlDBWm0BmmJoZO1PbNkZt3kiXNlaGLkIT49uEdgGe79TPCbr0D
ENCRYPTION_ITERATIONS=4e4
ENCRYPTION_KEY_SIZE=128
JWT_SECRET_KEY=2NtC29d33z1AF1HdPSpn
JWT_EXPIRE_IN_SECONDS=3600" > .env

# Finalizing the installation
echo "Your project $1 is ready"
echo "Now go to the project directory typing 'cd $1'"
echo " And type 'npm run dev' to start the server"
echo " And then try typing 'run-tsk help' to see the available commands to support your development"
echo "Happy coding!"
