#!/bin/bash

# Quick Start Script for Docker Setup
# This script helps set up and run the application on a fresh Ubuntu server

set -e  # Exit on error

echo "=========================================="
echo "Docker Test - Quick Start Script"
echo "=========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    echo "Please install Docker first. See SETUP.md for instructions."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    echo "Please install Docker Compose first. See SETUP.md for instructions."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "⚠️  Not running as root. Using 'sudo' for Docker commands."
    DOCKER_CMD="sudo docker compose"
else
    DOCKER_CMD="docker compose"
fi

# Stop any existing containers
echo "🛑 Stopping any existing containers..."
$DOCKER_CMD down 2>/dev/null || true

# Build and start services
echo "🔨 Building and starting services..."
$DOCKER_CMD up -d --build

# Wait a bit for services to start
echo "⏳ Waiting for services to initialize..."
sleep 5

# Check service status
echo ""
echo "📊 Service Status:"
$DOCKER_CMD ps

echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Services are running:"
echo "  • MySQL:     localhost:3306"
echo "  • Service1:  http://localhost:3001"
echo "  • Service2:  http://localhost:3002"
echo ""
echo "Useful commands:"
echo "  • View logs:     $DOCKER_CMD logs -f"
echo "  • Stop services: $DOCKER_CMD down"
echo "  • Restart:       $DOCKER_CMD restart"
echo ""
echo "Test the services:"
echo "  curl http://localhost:3001/health"
echo "  curl http://localhost:3002/"
echo ""

