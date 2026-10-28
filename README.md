# 🐉 Dynamic Game Content Using Prolog — Dragon Slayer

[![Language: Prolog](https://img.shields.io/badge/Language-Prolog-orange.svg)](https://www.swi-prolog.org/)
[![Environment: SWI-Prolog](https://img.shields.io/badge/Environment-SWI--Prolog-blue.svg)](https://www.swi-prolog.org/)
[![Genre: Text RPG](https://img.shields.io/badge/Genre-Text%20Adventure%20%2F%20RPG-darkgreen.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](#)

An interactive, text-based dungeon crawler and RPG adventure implemented entirely in **Prolog** (SWI-Prolog). This project demonstrates how declarative logic programming, first-order predicate logic, dynamic state manipulation, and rule-based inference engines can be used to generate dynamic game content, manage persistent states, and drive procedural quest mechanics.

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Dungeon Map](#-dungeon-map)
- [Prerequisites & Installation](#-prerequisites--installation)
- [How to Run the Game](#-how-to-run-the-game)
- [Controls & Command Reference](#-controls--command-reference)
- [Gameplay Walkthrough & Strategy](#-gameplay-walkthrough--strategy)
- [Under the Hood: Logic Architecture](#-under-the-hood-logic-architecture)
- [Project Structure](#-project-structure)
- [Author & Credits](#-author--credits)

---

## 🌟 Overview

In **The Dragon Slayer**, you enter a treacherous dungeon with a single goal: defeat the terrifying **Boss Dragon** lurking in the obsidian Throne Room and claim the realm's treasure. 

Along your quest, you must:
1. Navigate corridors and ancient chambers using compass directions or gaming hotkeys (`WASD`).
2. Search rooms to discover legendary armaments, keys, and consumable potions.
3. Overcome the guardian skeleton blocking the path.
4. Unlock the sealed obsidian Throne Room using the Iron Key found in the Armory.
5. Slay the Dragon in turn-based combat with strategic item use before your HP hits zero!

---

## ✨ Key Features

- **Declarative Dynamic World State**: Tracks player location, item placements, monster health, and quest flags dynamically via `assertz/1` and `retract/1`.
- **Gated Progression & Lock Puzzles**: Dynamic rule checks (`check_lock/1`) prevent players from entering guarded or locked sectors (like the Throne Room) without required quest items (`iron_key`).
- **Dynamic Combat System**:
  - **Fist Combat**: Deals low base damage (1–2 HP).
  - **Armed Combat**: Equipping the `sword` drastically scales damage output (5–9 HP).
  - **Retaliation & Permadeath**: Monsters retaliate each turn; dropping to 0 HP triggers instant Game Over.
- **Inventory & Consumables**: Collect keys and weapons; use healing potions to recover health (+10 HP).
- **Gamer-Friendly Shortcuts**: Native support for single-character inputs (`w`, `a`, `s`, `d`, `f`, `e`, `q`, `r`, `z`, `x`) mimicking modern RPG hotkeys.

---

## 🗺️ Dungeon Map

```
                     +---------------------------+
                     |       Throne Room         |
                     |  [DANGER: Boss Dragon]    |
                     |   * Requires Iron Key *   |
                     +-------------+-------------+
                                   | (North)
             +---------------------+---------------------+
             |                                           |
+------------+------------+     +------------------+    +------------+------------+
|         Forge           |     |     Hallway      |    |         Armory          |
|  [Item: Ancient Sword]  |<--->| [Skeleton Mob]   |<-->|   [Item: Iron Key]      |
|                         |     | [Healing Potion] |    |                         |
+-------------------------+     +--------+---------+    +-------------------------+
       (West)                            | (South)                (East)
                                +--------+---------+
                                |     Entrance     |
                                |  [Starting Area] |
                                +------------------+
```

---

## 💻 Prerequisites & Installation

To run this game, you need **SWI-Prolog** installed on your system.

### 1. Download SWI-Prolog

- **Official Download Portal**: [SWI-Prolog Downloads](https://www.swi-prolog.org/Download.html)

#### Direct Download Links:
- **Windows (64-bit)**: [Download .exe](https://www.swi-prolog.org/download/stable/bin/swipl-10.0.2-1.x64.exe.envelope)
- **macOS (Intel & Apple Silicon)**: [Download .dmg](https://www.swi-prolog.org/download/stable/bin/swipl-10.0.2-1.fat.dmg)
- **Linux (Debian / Ubuntu)**:
  ```bash
  sudo apt-get update
  sudo apt-get install swi-prolog
  ```
- **macOS (Homebrew)**:
  ```bash
  brew install swi-prolog
  ```

---

## 🚀 How to Run the Game

### Clone the Repository
```bash
git clone https://github.com/Dhanushrdy/Dynamic-Game-Content-Using-Prolog.git
cd Dynamic-Game-Content-Using-Prolog
```

### Option A: Via Command Line (Recommended)
Launch the game directly from your terminal and execute `init.` automatically:
```bash
swipl -s dragon_slayer.pl -g "init."
```

### Option B: Via SWI-Prolog GUI
1. Open the **SWI-Prolog** application.
2. In the top navigation menu, go to **File** > **Consult...**
3. Browse to this directory and select `dragon_slayer.pl`.
4. In the interpreter prompt, start the game by typing:
   ```prolog
   init.
   ```
   *(Don't forget the period `.` at the end of every Prolog command!)*

---

## 🎮 Controls & Command Reference

> **Note:** In Prolog syntax, all commands must conclude with a period (`.`) followed by pressing <kbd>Enter</kbd>.

| Key / Shortcut | Full Predicate | Category | Description |
| :---: | :--- | :--- | :--- |
| **`w.`** | `move(north).` | Movement | Move North |
| **`s.`** | `move(south).` | Movement | Move South |
| **`a.`** | `move(west).` | Movement | Move West |
| **`d.`** | `move(east).` | Movement | Move East |
| **`f.`** | `take(Item).` | Interaction | Grab / Pick up item from the current room |
| **`e.`** | `attack.` | Combat | Strike the monster present in the current room |
| **`r.`** | `use(healing_potion).` | Consumable | Drink healing potion (+10 HP) |
| **`q.`** | `status.` | Information | Check current HP and Inventory contents |
| **`z.`** | `look.` | Information | Inspect current room, items on floor, and threats |
| **`x.`** | `finish.` | Quest | Complete the quest after slaying the dragon |
| — | `init.` | System | Reset game state to the beginning |
| — | `halt.` | System | Exit the SWI-Prolog interpreter |

---

## ⚔️ Gameplay Walkthrough & Strategy

For an optimal playthrough without succumbing to the dungeon's horrors:

1. **Step into the Hallway**:
   - Type `w.` to step from the Entrance into the Hallway.
   - You will see a `skeleton` (5 HP) and a `healing_potion`.
2. **Collect the Healing Potion**:
   - Type `f.` to stash the potion into your inventory for later.
3. **Equip Yourself at the Forge**:
   - Head west with `a.` to enter the Ancient Forge.
   - Grab the **sword** with `f.`. Your attacks will now deal **5–9 damage** instead of bare-fist punches (1–2 damage).
4. **Obtain the Throne Room Key**:
   - Return east with `d.` to the Hallway.
   - Move east with `d.` into the Armory.
   - Grab the **iron_key** with `f.`.
5. **Clear the Guardian Skeleton**:
   - Return west with `a.` to the Hallway.
   - Attack the skeleton with `e.`. With your sword, you can defeat it in 1 or 2 turns!
   - If your health is low, type `r.` to restore 10 HP.
6. **Confront the Boss Dragon**:
   - Head north with `w.`. Your Iron Key automatically unlocks the Throne Room doors!
   - Face the `boss_dragon` (30 HP) and attack repeatedly using `e.`.
   - Monitor your HP via `q.`.
7. **Claim Victory**:
   - Once the dragon falls, type `x.` to conclude your quest and receive your victory honors!
   - Type `halt.` to close the session.

---

## 🧠 Under the Hood: Logic Architecture

The game engine is built on fundamental Prolog concepts:

- **Dynamic Predicates (`:- dynamic`)**:
  Allows the database to be mutated during runtime as facts change:
  ```prolog
  :- dynamic at/2.          % at(Object, Location)
  :- dynamic has/1.         % has(Item)
  :- dynamic hp/1.          % hp(CurrentHealth)
  :- dynamic monster_hp/2.  % monster_hp(Monster, CurrentHealth)
  :- dynamic alive/1.       % alive(Entity)
  ```
- **Pattern Matching & Cut Operator (`!`)**:
  Enforces deterministic choices and guards against unnecessary backtracking during item acquisition, locked door checks, and turn cycles.
- **Negation as Failure (`\+`)**:
  Ensures safe interactions, such as verifying entities are not monsters before allowing pickup (`\+ alive(Target)`), and verifying dragon status prior to finishing the quest (`\+ alive(boss_dragon)`).

---

## 📁 Project Structure

```text
Dynamic-Game-Content-Using-Prolog/
├── dragon_slayer.pl     # Core game logic, knowledge base, rules & mechanics
└── README.md            # Comprehensive documentation, setup guide & walkthrough
```

---

## 👤 Author

- **Tarugu Dhanush Kumar Reddy** ([@Dhanushrdy](https://github.com/Dhanushrdy))
