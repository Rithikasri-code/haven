<#
.SYNOPSIS
    Cross-platform build and test automation script for Retro RTS on Windows.

.PARAMETER BuildType
    CMake build configuration (Release, Debug, RelWithDebInfo). Default: Release.

.PARAMETER RunTests
    Executes the CTest test suite after a successful compilation.

.PARAMETER Clean
    Removes the existing build directory before configuring.
#>
param (
    [string]$BuildType = "Release",
    [switch]$RunTests,
    [switch]$Clean
)

$ErrorActionPreference = "Stop"

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "           Retro RTS — Build Pipeline (C++20)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

# 1. Verify CMake availability
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Error "CMake is not installed or not in system PATH. Please install CMake 3.25+."
    exit 1
}

$BuildDir = "build"

if ($Clean -and (Test-Path $BuildDir)) {
    Write-Host "[*] Cleaning existing build directory: $BuildDir..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $BuildDir
}

# 2. Configure CMake
Write-Host "[*] Configuring project (BuildType: $BuildType)..." -ForegroundColor Green
cmake -S . -B $BuildDir -DCMAKE_BUILD_TYPE=$BuildType

if ($LASTEXITCODE -ne 0) {
    Write-Error "CMake configuration failed."
    exit $LASTEXITCODE
}

# 3. Compile
Write-Host "[*] Building targets in parallel..." -ForegroundColor Green
cmake --build $BuildDir --config $BuildType --parallel

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build compilation failed."
    exit $LASTEXITCODE
}

Write-Host "[✓] Build completed successfully!" -ForegroundColor Green

# 4. Optional Test Execution
if ($RunTests) {
    Write-Host "[*] Executing test suite via CTest..." -ForegroundColor Cyan
    ctest --test-dir $BuildDir -C $BuildType --output-on-failure
    if ($LASTEXITCODE -ne 0) {
        Write-Error "One or more tests failed."
        exit $LASTEXITCODE
    }
    Write-Host "[✓] All test suites passed!" -ForegroundColor Green
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Binaries located in: $BuildDir" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
