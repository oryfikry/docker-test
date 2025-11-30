#!/bin/bash

# Verification script to check all required files are present

echo "=========================================="
echo "Verifying Required Files"
echo "=========================================="
echo ""

ERRORS=0

# Check docker-compose.yml
if [ -f "docker-compose.yml" ]; then
    echo "✅ docker-compose.yml exists"
else
    echo "❌ docker-compose.yml NOT FOUND"
    ERRORS=$((ERRORS + 1))
fi

# Check service1 files
if [ -f "service1/Dockerfile" ]; then
    echo "✅ service1/Dockerfile exists"
    if [ -s "service1/Dockerfile" ]; then
        echo "   File size: $(wc -c < service1/Dockerfile) bytes"
    else
        echo "   ⚠️  WARNING: service1/Dockerfile is empty!"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "❌ service1/Dockerfile NOT FOUND"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "service1/package.json" ]; then
    echo "✅ service1/package.json exists"
else
    echo "❌ service1/package.json NOT FOUND"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "service1/index.js" ]; then
    echo "✅ service1/index.js exists"
else
    echo "❌ service1/index.js NOT FOUND"
    ERRORS=$((ERRORS + 1))
fi

# Check service2 files
if [ -f "service2/Dockerfile" ]; then
    echo "✅ service2/Dockerfile exists"
    if [ -s "service2/Dockerfile" ]; then
        echo "   File size: $(wc -c < service2/Dockerfile) bytes"
    else
        echo "   ⚠️  WARNING: service2/Dockerfile is empty!"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "❌ service2/Dockerfile NOT FOUND"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "service2/package.json" ]; then
    echo "✅ service2/package.json exists"
else
    echo "❌ service2/package.json NOT FOUND"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "service2/index.js" ]; then
    echo "✅ service2/index.js exists"
else
    echo "❌ service2/index.js NOT FOUND"
    ERRORS=$((ERRORS + 1))
fi

# Check MySQL init files
if [ -d "mysql_init" ]; then
    echo "✅ mysql_init directory exists"
    if [ -f "mysql_init/init.sql" ]; then
        echo "✅ mysql_init/init.sql exists"
    else
        echo "⚠️  mysql_init/init.sql NOT FOUND (optional)"
    fi
else
    echo "⚠️  mysql_init directory NOT FOUND (optional)"
fi

echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ All required files are present!"
    echo "You can now run: docker compose up -d --build"
else
    echo "❌ Found $ERRORS error(s). Please fix before proceeding."
fi
echo "=========================================="

exit $ERRORS

