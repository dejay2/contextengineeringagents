#!/bin/bash

# Docker helper script for Claude Code development container

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Container name (project-specific to avoid conflicts)
CONTAINER_NAME="context-claude-code-dev"
PROJECT_NAME="context-claude-dev"

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running. Please start Docker."
        exit 1
    fi
}

# Function to build the container
build() {
    print_info "Building Docker image for project: $PROJECT_NAME..."
    docker compose -p $PROJECT_NAME build
    print_success "Docker image built successfully!"
}

# Function to start the container
start() {
    print_info "Starting container..."
    docker compose -p $PROJECT_NAME up -d
    print_success "Container started successfully!"
    print_info "Container '$CONTAINER_NAME' is now running."
}

# Function to stop the container
stop() {
    print_info "Stopping container..."
    docker compose -p $PROJECT_NAME down
    print_success "Container stopped successfully!"
}

# Function to restart the container
restart() {
    stop
    start
}

# Function to enter the container shell
shell() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_warning "Container is not running. Starting it now..."
        start
    fi
    
    print_info "Entering container shell..."
    docker exec -it $CONTAINER_NAME bash
}

# Function to run a command in the container
run() {
    if [ $# -eq 0 ]; then
        print_error "No command specified. Usage: ./docker-helper.sh run <command>"
        exit 1
    fi
    
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_warning "Container is not running. Starting it now..."
        start
    fi
    
    print_info "Running command in container: $@"
    docker exec $CONTAINER_NAME bash -c "$@"
}

# Function to view container logs
logs() {
    print_info "Showing container logs..."
    docker compose -p $PROJECT_NAME logs -f
}

# Function to clean up containers and images
clean() {
    print_warning "This will remove the container and its volumes for project: $PROJECT_NAME. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        print_info "Cleaning up project: $PROJECT_NAME..."
        docker compose -p $PROJECT_NAME down -v
        print_success "Cleanup completed!"
    else
        print_info "Cleanup cancelled."
    fi
}

# Function to show container status
status() {
    if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_success "Container '$CONTAINER_NAME' is running"
        echo ""
        docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.ID}}\t{{.Status}}\t{{.Ports}}"
    else
        print_warning "Container '$CONTAINER_NAME' is not running"
    fi
}

# Function to rebuild the container
rebuild() {
    print_info "Rebuilding container for project: $PROJECT_NAME..."
    docker compose -p $PROJECT_NAME down
    docker compose -p $PROJECT_NAME build --no-cache
    docker compose -p $PROJECT_NAME up -d
    print_success "Container rebuilt successfully!"
}

# Function to install project dependencies in container
install() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_warning "Container is not running. Starting it now..."
        start
    fi
    
    print_info "Installing project dependencies in container..."
    
    # Check for package.json
    if [ -f "package.json" ]; then
        print_info "Installing Node.js dependencies..."
        docker exec -it $CONTAINER_NAME bash -c "cd /workspace && npm install"
    fi
    
    # Check for requirements.txt
    if [ -f "requirements.txt" ]; then
        print_info "Installing Python dependencies..."
        docker exec -it $CONTAINER_NAME bash -c "cd /workspace && pip3 install -r requirements.txt"
    fi
    
    # Check for Pipfile
    if [ -f "Pipfile" ]; then
        print_info "Installing Python dependencies with pipenv..."
        docker exec -it $CONTAINER_NAME bash -c "cd /workspace && pip3 install pipenv && pipenv install"
    fi
    
    print_success "Dependencies installed successfully!"
}

# Function to run tests in container
test() {
    if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_warning "Container is not running. Starting it now..."
        start
    fi
    
    print_info "Running tests in container..."
    
    # Try to detect and run appropriate test command
    if [ -f "package.json" ]; then
        if grep -q '"test"' package.json; then
            docker exec -it $CONTAINER_NAME bash -c "cd /workspace && npm test"
        fi
    elif [ -d "tests" ] || [ -d "test" ]; then
        docker exec -it $CONTAINER_NAME bash -c "cd /workspace && python -m pytest"
    else
        print_warning "No test configuration detected. You can run custom tests with: ./docker-helper.sh run '<test-command>'"
    fi
}

# Function to show help
show_help() {
    echo "Docker Helper Script for Claude Code Development Container"
    echo ""
    echo "Usage: ./docker-helper.sh <command> [arguments]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  start       Start the container"
    echo "  stop        Stop the container"
    echo "  restart     Restart the container"
    echo "  shell       Enter the container shell"
    echo "  run <cmd>   Run a command in the container"
    echo "  logs        Show container logs"
    echo "  status      Show container status"
    echo "  install     Install project dependencies"
    echo "  test        Run tests in container"
    echo "  rebuild     Rebuild container from scratch"
    echo "  clean       Remove container and volumes"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./docker-helper.sh build"
    echo "  ./docker-helper.sh shell"
    echo "  ./docker-helper.sh run 'npm test'"
    echo "  ./docker-helper.sh run 'python script.py'"
}

# Main script logic
check_docker

case "$1" in
    build)
        build
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    shell)
        shell
        ;;
    run)
        shift
        run "$@"
        ;;
    logs)
        logs
        ;;
    status)
        status
        ;;
    install)
        install
        ;;
    test)
        test
        ;;
    rebuild)
        rebuild
        ;;
    clean)
        clean
        ;;
    help|"")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac