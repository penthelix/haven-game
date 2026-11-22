# Discoth

A 2D dodge game made in Godot 4.7, submitted as part of [Hack Club](https://hackclub.com) [Haven](https://haven.hackclub.com).

You are a small pixel character trapped inside a TV. A DVD logo bounces around the screen with the chaotic energy of an unsupervised screensaver. Your job is to not get hit. That is the entire game. You are welcome.

## What It Is

Discoth is a survival game where your objective is to dodge a bouncing DVD logo for as long as possible. Move in any direction but just avoid the logo. Try not to feel personally attacked when it corners you.

When the logo hits you, your character plays a death animation, everything freezes and you sit with your choices.

## How to Run It

Play the game on [itch.io](https://thebatmanonly.itch.io/discoth).

## Controls

| Key                  | Action     |
| -------------------- | ---------- |
| W / Arrow Up / Space | Move up    |
| S / Arrow Down       | Move down  |
| A / Arrow Left       | Move left  |
| D / Arrow Right      | Move right |

Diagonal movement is normalized, so you cannot go faster by holding two keys at once. The game thought of that before you did.

## How It Works

The DVD logo spawns at a random position and bounces off the walls. The player moves freely in all four directions with no gravity and no jumping.

When the logo touches the player, the player's death animation plays once and the scene tree pauses completely. The logo stops mid-bounce. The music stops. Everything just... ends.

## Dev Setup

1. You will need Godot 4.7 or later. It is free. You can get it at [godotengine.org](https://godotengine.org).

2. Clone this repository

3. Open Godot, click Import, select the `project.godot` file inside the `src/` folder, and hit Play.

## Project Structure

```
src/
  player.gd              - Player movement and death logic
  character_body_2d.gd   - DVD logo bounce physics and collision detection
  node_2d.tscn           - Main scene (level, logo, player, boundaries)
  player.tscn            - Player scene with animations
assets/
  images/                - Spritesheets, overlays, UI graphics
  sound/                 - Background music, win and lose audio
```

## Tech Stack

- Godot Engine 4.7
- GDScript
- 2D physics (CharacterBody2D)
- AnimatedSprite2D with custom spritesheets
- TileMapLayer for the level background

## Credits

music: "Violin Lose 4" by floraphonic
background assests: canva ready to use assests

all other assets and sprites were self designed

## AI Disclosure

An LLM was queried during one collaborative debugging session. Sparing that, no AI was used in the creation of this project.

Made by Batman, yapping_aaloo and helix
