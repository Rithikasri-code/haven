<p align="center">
  <img src="assets/banner.svg" alt="Haven Engine Banner" width="100%" />
</p>

<p align="center">
  <a href="https://github.com/Rithikasri-code/haven/actions"><img src="https://img.shields.io/badge/Build-Passing-38bdf8?style=flat-square&logo=githubactions&logoColor=white&labelColor=0f172a" alt="Build Status" /></a>
  <img src="https://img.shields.io/badge/Standard-C%2B%2B20-818cf8?style=flat-square&logo=c%2B%2B&logoColor=white&labelColor=0f172a" alt="C++20" />
  <img src="https://img.shields.io/badge/Framework-SDL3-38bdf8?style=flat-square&labelColor=0f172a" alt="SDL3" />
  <img src="https://img.shields.io/badge/Storage-SQLite%203-blue?style=flat-square&logo=sqlite&logoColor=white&labelColor=0f172a" alt="SQLite 3" />
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-e2e8f0?style=flat-square&labelColor=0f172a" alt="Platforms" />
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-yellow?style=flat-square&labelColor=0f172a" alt="GPL-3.0" /></a>
</p>

---

## 📌 Overview

**Haven** is a high-performance, native open-source reimplementation of the classic 1998 isometric turn-based tactical strategy engine (*Fallen Haven: Liberation Day*), developed in the design spirit of modern engine preservation projects like **OpenRA**, **OpenXcom**, and **fheroes2**.

Engineered entirely from the ground up in modern **C++20** with **SDL3**, the engine provides native, cross-platform execution on **macOS (Apple Silicon arm64)**, **Windows (x64)**, and **Linux (x64)** without emulators or legacy compatibility layers.

> [!NOTE]
> **Strict Cleanroom Engineering:** Haven contains **zero proprietary game assets**. No original executables, sound files, graphics, or databases are bundled in the repository or releases. All sprites, cinematics, and campaign parameters are dynamically decoded at runtime from legitimate game data files or synthetic test suites.

---

## 🏗️ System Architecture

```mermaid
flowchart TD
    subgraph ClientLayer["🖥️ Presentation & Client Layer"]
        UI["UI Atlas & Font Subsystem\n(stb_truetype, Liberation Sans)"]
        Audio["Audio Engine\n(SDL3 Audio, stb_vorbis)"]
        Render["Isometric Depth Renderer\n(8-bit Palette Cycling, SDL_SCALEMODE_PIXELART)"]
    end

    subgraph SimulationServer["⚙️ Deterministic Simulation Server"]
        BattleState["Battle State Machine\n(Turn Phase, Action Points, Fog of War)"]
        Combat["Tactical Combat Engine\n(Line of Sight, Armor Mitigation, Splash Damage)"]
        AIMap["Tactical AI & PathMap\n(Multi-Goal A* Sweeper, Threat Rings)"]
    end

    subgraph DataPipeline["💾 Data & Asset Decoding Subsystem"]
        DBI["DBI Sprite Decoder\n(5,900+ RLE Sprites)"]
        SMK["Smacker 2 Video & Animation\n(Native SMK2 Decoder)"]
        SQLite["SQLite Storage Engine\n(Replaces legacy Jet/MDB)"]
        LZMA["Inno & ISO Decoders\n(LZMA/LZMA2 Extractors)"]
    end

    ClientLayer <--> SimulationServer
    SimulationServer <--> DataPipeline
```

---

## ⚡ Core Technical Capabilities

* **Modern C++20 Core:** Strict modular architecture leveraging modern standard library constructs, concepts, atomic state machines, and RAII resource management.
* **Deterministic Server-Client Separation:** Even in single-player and hot-seat skirmish modes, simulation state runs through a decoupled request-event messaging pipeline (`BattleState` ↔ `applyEvent`), paving the way for multi-client networking.
* **Advanced Tactical AI & A\* PathMap:**
  * Multi-target inverted distance transform and sweeping pathfinding (`PathMap`).
  * Phase-driven threat assessment: target priority weighting, move-to-fire ring calculation, and patrol/escort group behaviors.
* **Isometric Sorting & Depth Engine:**
  * Dynamic per-tile isometric depth sorting supporting bridges, multicarrier vehicles, damage-based wall crumbling, and surface fire effects across all 114 maps.
  * Real-time 18-step 100ms palette-cycling water and energy animation (`PALCYCLE`).
* **High-Throughput Asset Extractors:**
  * Proprietary format decoders written without external runtime dependencies (`.DBI` 8-bit RLE sprites, `.FF` / `.SMK` video streams, `.PAL` color banks).
  * Automated migration pipeline from legacy MS Access/Jet `.MDB` databases into relational SQLite 3 schemas.

---

## 🧪 Comprehensive Verification Suite

Retro RTS includes **17 isolated unit and integration test suites** executed on every commit via GitHub Actions:

| Test Suite | Subsystem Validated |
| :--- | :--- |
| `battle_test` | AP consumption, combat line-of-fire, reaction fire, and objective evaluations |
| `campaign_test` | Strategic colony state transitions, tech trees, and city-building grids |
| `dbi_test` | Sprite unpack verification, color-key integrity, and bounding box metrics |
| `ff_test` | Smacker video chunking, audio synchronization, and keyframe transparency |
| `map_test` | Isometric tile coordinate projection and obstacle traversability matrices |
| `install_test` | Inno Setup LZMA/LZMA2 archive extraction and checksum verification |
| `save_test` | Atomic game state serialization, RNG recovery, and backwards compatibility |

---

## 🚀 Quickstart & Building

### Prerequisites
* **CMake 3.25+**
* **C++20 Compliant Compiler** (MSVC 2022/2026, Clang 16+, GCC 13+)
* **Dependencies:** SDL3 and SQLite3 are automatically fetched and pinned with cryptographic SHA hashes via CMake `FetchContent`.

### Windows (PowerShell)
```powershell
# Build and run the test suite with a single command
.\build.ps1 -RunTests
```

### macOS & Linux
```bash
chmod +x build.sh
./build.sh --test
```

### Docker (Headless Linux Build & Test)
Compile and verify all 17 test suites in an isolated container without local C++ toolchains:
```bash
docker build -t haven .
```

---

## 🛠️ Debugging & Agent Tooling (Built-in MCP Server)

Retro RTS features an internal **Model Context Protocol (MCP)** server for AI-driven automated testing and headless integration:

```bash
# Launch engine with MCP server enabled on localhost
./openday --mcp --mcp-port 47800
```
Allows external agents or automation scripts to:
* Capture 8-bit indexed compressed PNG screenshots.
* Inspect live simulation state (`battle_state`, units, pathfinder graphs).
* Inject deterministic commands (Move, Fire, Deploy, EndTurn).

---

## 📄 Licensing & Disclaimers

* **Source Code:** Released under the **GNU General Public License v3.0 (GPL-3.0)**. See [LICENSE](LICENSE) for details.
* **Third-Party Code:** Contains permissive libraries documented in [THIRD_PARTY.md](THIRD_PARTY.md).
* **Trademark Notice:** *Fallen Haven* and *Liberation Day* are trademarks of their respective copyright holders. This project is an independent cleanroom reimplementation and is not affiliated with, endorsed by, or connected to the original publishers.
