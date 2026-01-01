#!/usr/bin/env bash
# ==============================================================================
# Cross-platform build & test script for Retro RTS (Linux & macOS)
# ==============================================================================

set -euo pipefail

BUILD_TYPE="Release"
RUN_TESTS=false
CLEAN=false

print_usage() {
    echo "Usage: ./build.sh [OPTIONS]"
    echo "Options:"
    echo "  --debug        Build with Debug configuration"
    echo "  --test         Run the test suite with CTest after build"
    echo "  --clean        Clean build directory before configuring"
    echo "  --help         Show this help message"
}

for arg in "$@"; do
    case "$arg" in
        --debug)
            BUILD_TYPE="Debug"
            ;;
        --test)
            RUN_TESTS=true
            ;;
        --clean)
            CLEAN=true
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg"
            print_usage
            exit 1
            ;;
    esac
done

echo "======================================================"
echo "         Retro RTS — Build Pipeline (C++20)"
echo "======================================================"

if ! command -v cmake &> /dev/null; then
    echo "Error: CMake is not installed or not in PATH."
    exit 1
fi

BUILD_DIR="build"

if [ "$CLEAN" = true ] && [ -d "$BUILD_DIR" ]; then
    echo "[*] Cleaning build directory..."
    rm -rf "$BUILD_DIR"
fi

echo "[*] Configuring project with CMake ($BUILD_TYPE)..."
cmake -S . -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE="$BUILD_TYPE"

echo "[*] Compiling targets..."
cmake --build "$BUILD_DIR" --config "$BUILD_TYPE" --parallel

echo "[✓] Build completed successfully!"

if [ "$RUN_TESTS" = true ]; then
    echo "[*] Running CTest test suites..."
    ctest --test-dir "$BUILD_DIR" -C "$BUILD_TYPE" --output-on-failure
    echo "[✓] All tests passed!"
fi
