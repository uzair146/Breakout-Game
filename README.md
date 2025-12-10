# Breakout Game in Assembly Language

## Overview
This is a console-based Breakout-style arcade game implemented in x86 Assembly Language as a semester project for Computer Organization and Assembly Language (COAL). The game runs in DOS mode and features classic gameplay where players control a paddle to bounce a ball and break bricks. It demonstrates low-level programming concepts such as memory management, interrupts for keyboard input, timer delays, sound generation via PC speaker, and text-mode graphics.

The project was developed by a two-member team using DOS interrupts for rendering, input handling, and audio. It includes custom pixel art, sound effects, and a menu system.

## Features
- **Core Gameplay**: Control a paddle to bounce a ball and destroy bricks across multiple levels.
- **HUD Elements**: Displays score, level, and lives (with custom heart icons).
- **Physics and Collisions**: Ball movement with velocity, paddle/ball collisions, brick destruction with scoring based on brick color.
- **Levels and Progression**: Automatic level-up when all bricks are cleared, with increasing ball speed.
- **Lives System**: 3 lives per game; lose a life on ball miss, game over on zero lives.
- **Menu System**: Main menu with help screen showing rules, controls, and scoring legend.
- **Sound Effects**: Custom tones for paddle hits, brick breaks, life loss, level up, game start, and game over using PC speaker (via PIT 8253).
- **Custom Graphics**: Pixel art for the title logo, custom characters for ball and hearts using BIOS interrupts.

## Technologies Used
- **Language**: x86 Assembly (NASM/TASM compatible).
- **Environment**: DOS (tested on DOSBox).
- **Key Interrupts**:
  - INT 10h: Video services for text-mode graphics and custom characters.
  - INT 16h: Keyboard input (non-blocking and blocking).
  - INT 15h: Microsecond delays for timing.
  - Port I/O: For sound generation (PIT Channel 2 and speaker control).
- **No External Libraries**: Pure Assembly with direct hardware interaction.

**Note**: This project is designed for 16-bit DOS environments. Sound effects rely on the PC speaker hardware emulation in DOSBox.

## How to Run
1. **Prerequisites**:
   - DOSBox (for modern systems) or a real DOS machine/virtual machine.
   - Assembler: NASM (recommended) or TASM.

2. **Assemble the Code**:
   - Assemble the main file: `nasm main.asm -f bin -o breakout.com` (or use TASM equivalents).
   - The project includes multiple ASM files (%include directives handle assembly).

3. **Run in DOSBox**:
   - Mount your project directory in DOSBox: `mount c .`
   - Navigate: `c:`
   - Run: `breakout.com`

4. **Controls**:
   - Arrow Keys (Left/Right): Move paddle.
   - Spacebar: Launch ball (when stuck to paddle).
   - ESC: Exit game.
   - ENTER: Start from menu.
   - H: Help in menu.

**Gameplay Tips**:
- Break all bricks to level up.
- Score points based on brick color: Red (40), Magenta (30), Green (20), Yellow (10).
- Avoid letting the ball fall below the paddle.

## Group Members
This project was developed by a two-member team:
- **Muhammad Uzair Hussain**
- **Saqib Ali**

## Limitations and Future Improvements
- No support for mouse input or high-resolution graphics (limited to 80x25 text mode).
- Sound is basic (PC speaker tones); no advanced audio.
- Single-player only; no high scores saving.
- Potential improvements: Add power-ups, multiplayer mode, or port to modern OS with emulators/libraries like SDL for graphics.

## License
This project is for educational purposes. Feel free to use or modify it, but please credit the original authors.
