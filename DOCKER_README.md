# Docker Development Environment

This project includes a comprehensive Docker development environment with all necessary tools pre-installed.

## Prerequisites

- Docker Engine (20.10 or later)
- Docker Compose V2
- Bash shell (for the helper script)

## Quick Start

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone <repository-url>
   cd context
   ```

2. **Build the Docker image**:
   ```bash
   ./docker-helper.sh build
   ```
   This will take a few minutes on first build as it installs all development tools.

3. **Start the development container**:
   ```bash
   ./docker-helper.sh start
   ```

4. **Enter the container shell**:
   ```bash
   ./docker-helper.sh shell
   ```

## Available Commands

The `docker-helper.sh` script provides these commands:

| Command | Description |
|---------|-------------|
| `./docker-helper.sh build` | Build the Docker image |
| `./docker-helper.sh start` | Start the container in background |
| `./docker-helper.sh stop` | Stop the running container |
| `./docker-helper.sh restart` | Restart the container |
| `./docker-helper.sh shell` | Enter interactive shell in container |
| `./docker-helper.sh run <cmd>` | Run a command in the container |
| `./docker-helper.sh install` | Install project dependencies |
| `./docker-helper.sh test` | Run project tests |
| `./docker-helper.sh logs` | View container logs |
| `./docker-helper.sh status` | Check container status |
| `./docker-helper.sh rebuild` | Rebuild container from scratch |
| `./docker-helper.sh clean` | Remove container and volumes |
| `./docker-helper.sh help` | Show help message |

## Usage Examples

### Running Tests
```bash
# Run Node.js tests
./docker-helper.sh run "npm test"

# Run Python tests
./docker-helper.sh run "pytest"

# Run specific test file
./docker-helper.sh run "pytest tests/test_example.py"
```

### Installing Dependencies
```bash
# Install all project dependencies automatically
./docker-helper.sh install

# Or manually install specific packages
./docker-helper.sh run "npm install express"
./docker-helper.sh run "pip install requests"
```

### Development Workflow
```bash
# Start the container
./docker-helper.sh start

# Work in the container shell
./docker-helper.sh shell

# Inside container, you have access to:
node --version    # Node.js 20.x
python3 --version # Python 3.10
rustc --version   # Rust 1.89
go version        # Go 1.21
```

### Debugging
```bash
# View container logs
./docker-helper.sh logs

# Check container status
./docker-helper.sh status

# Rebuild if something goes wrong
./docker-helper.sh rebuild
```

## What's Included

The Docker image includes:

### Languages & Runtimes
- **Node.js 20.x** with npm, pnpm, yarn
- **Python 3.10** with pip
- **Rust** (latest stable)
- **Go 1.21**

### Development Tools
- **Version Control**: git, gh (GitHub CLI)
- **Editors**: vim, nano
- **Search Tools**: ripgrep, fzf
- **File Viewers**: bat, tree
- **Network Tools**: curl, wget, netcat
- **Build Tools**: make, gcc, g++, cmake

### Node.js Global Packages
- TypeScript, tsx, ts-node
- Jest, Mocha, Vitest
- ESLint, Prettier, Biome
- PM2, Nodemon

### Python Packages
- pytest, pytest-cov, pytest-asyncio
- black, flake8, mypy, ruff, pylint
- jupyter, ipython
- pandas, numpy
- fastapi, uvicorn
- requests, httpx

## Architecture

- **Container Name**: `context-claude-code-dev`
- **Project Name**: `context-claude-dev` (prevents conflicts with other Docker projects)
- **Work Directory**: `/workspace` (mounted from current directory)
- **Volumes**: Persistent volumes for node_modules, pip cache, npm cache, etc.
- **Network**: Host network mode for easy access to local services

## Troubleshooting

### Container won't start
```bash
# Check if another container is using the same name
docker ps -a | grep context-claude

# Clean up and rebuild
./docker-helper.sh clean
./docker-helper.sh build
./docker-helper.sh start
```

### Permission issues
Files created in the container may have root ownership. To fix:
```bash
# Inside container, change ownership
./docker-helper.sh run "chown -R 1000:1000 /workspace"
```

### Out of disk space
```bash
# Clean up Docker system
docker system prune -a

# Remove our volumes and rebuild
./docker-helper.sh clean
./docker-helper.sh build
```

## Notes

- The container runs with host network mode for easy access to local services
- All project files are mounted at `/workspace` in the container
- Changes made in the container are reflected on your host and vice versa
- Dependencies installed in the container are cached in Docker volumes for persistence

## Customization

To add more tools or packages, edit the `Dockerfile` and rebuild:
```bash
# Edit Dockerfile
vim Dockerfile

# Rebuild with changes
./docker-helper.sh rebuild
```