# OSS-UNO

I could not find a decent UNO game, so I decided to make my own ;)

Why is this better than any other UNO game?

- No ads
- No "pay to continue playing" system
- 100% free
- Open source
  - If you don't like something, you can change it
  - If you want something, you can add it
  - Written in Teal ([Lua but better](https://youtu.be/ooQ-_9YQVw0))
- Looks good
- No tracking
- No selling your data
- Single player mode
- Has controller support

## Contents

- [Running the Game](#running-the-game)
  - [Requirements](#requirements)
  - [Setup and Running](#setup-and-running)
- [Game Info](#game-info)
  - [Levels](#levels)
- [Files & Structures](#files-and-structures)
- [VSCode Debugging](#vscode-debugging)
  - [Requirements](#debugging-requirements)
  - [Setup](#setup-debugging)

## Running The Game

### Requirements

- [Lua](https://www.lua.org) (v5.4+)
- [Love2D](https://love2d.org) (v11.4)
- [LuaRocks](https://luarocks.org)
- [trash-cli](https://github.com/andreafrancia/trash-cli) (optional)
  - This is so we can safely delete any files and easily restore it if we need to

##### Install Requirements:

Ubuntu: `sudo apt install lua5.4 love luarocks trash-cli`
Arch Linux: `sudo pacman -S install lua love luarocks trash-cli`

#### Modules

You can use Luarocks to install these modules - note that some of them are provided in the project source code.

Install: `luarocks install tl --local`

- [lunajson](https://luarocks.org/modules/grafi/lunajson)

  - So we can read and write `json`. It is included in the project, but is only used for compiling the code into an executable, not running it.

- [tl](https://github.com/teal-language/tl)
  - To compile the code into regular Lua

<!-- ##### Install Modules:

1. `alias luai="luarocks install --local"`
2. `luai tl && luai lunajson` -->

### Setup and Running

1. Get the code on your PC (git clone or download)
1. Download all dependencies (Requirements & Modules)
1. Go into the folder with `main.tl`
1. `./run.sh` **(Linux/Mac)** (note that if you don't have trash-cli installed, you will need to modify `clean.sh` to use `rm` instead)
1. Enjoy UNO

#### Running on Windows

If you're on Windows, then running `./run.sh` will not work (unless you use WSL - Windows Subsystem for Linux). You then need to:

1. Generate Lua Code
   - So just `tl gen` all the .tl (not the .d.tl) files in the code so you get the Lua code
   - Then remove any standalone requires, aka `require "something.something"` (don't remove any `local x = require.....`) in _all_ the .lua files
   - Remove any lines that contains `local _tl_compat` (usually the first line in some .lua files)
1. Run it!
   - `love .` or whatever the Windows version of this is

## Game Info

### Levels

There are 3 levels to choose from, these are currently their limitations:

#### Easy (1)

- Bot cannot chain +2 cards (cannot add a +2 to negate your +2)
- Bot cannot play a +2 directly after playing a +2
- Bot cannot play a +4
- Bot only has 50% chance to say uno before playing 2nd last card

#### Normal (2)

- Only 70% chance that bot says uno before playing 2nd last card

#### Hard (3)

No limitations

## Files and Structures

- `assets` - All game assets (images/audio etc.)
  - `backgrounds` - Game background images
    - `saves` - GIMP save files for images
  - `buttons` - Button images
    - `icon` - Button icons images
    - `text` - Button text images
  - `cards` - All card images
  - `ui-sounds` - Game BGM and SFX
- `check.sh` - Script to display `tl` checks
- `clean.sh` - Script to clean up the code after generating Lua files
- `data` - Any data the game should store, such as saves or configs
  - `settings.json` - User settings/config for the game
- `gen.sh` - Generate Lua files
- `love.d.tl` - Any `.d.tl` files are just typing, can be ignored for the most part
- `main.tl` - Any `.tl` files is the game code (just Lua with static typing)
- `README.md` - Game docs
- `run.sh` - Compile, run and clean up script in one
- `src` - Game source code (excluding `main.tl`)
  - `game` - Components in the game, such as cards and players
  - `menu` - Viewable game menus/screens/views
  - `utils` - util files, usually for components that are not visible, such as `SFX`

## VSCode Debugging

### Debugging Requirements:

- https://marketplace.visualstudio.com/items?itemName=tomblind.local-lua-debugger-vscode

### Setup Debugging

Add below to .vscode/launch.json:

```json
{
	"version": "0.2.0",
	"configurations": [
		{
			"type": "lua",
			"request": "launch",
			"name": "Debug",
			"program": "${workspaceFolder}/src/PlayedDeck.lua"
		},
		{
			"type": "lua-local",
			"request": "launch",
			"name": "Debug Love",
			"program": {
				"command": "/usr/bin/love"
			},
			"args": ["${workspaceFolder} "]
		}
	]
}
```

---

If you want to support the work I do, please consider donating to me on one of these platforms:

[<img alt="liberapay" src="https://img.shields.io/badge/-LiberaPay-EBC018?style=flat-square&logo=liberapay&logoColor=white" />](https://liberapay.com/stevesteacher/)
[<img alt="kofi" src="https://img.shields.io/badge/-Kofi-7648BB?style=flat-square&logo=ko-fi&logoColor=white" />](https://ko-fi.com/stevesteacher)
[<img alt="patreon" src="https://img.shields.io/badge/-Patreon-F43F4B?style=flat-square&logo=patreon&logoColor=white" />](https://www.patreon.com/Stevesteacher)
[<img alt="paypal" src="https://img.shields.io/badge/-PayPal-0c1a55?style=flat-square&logo=paypal&logoColor=white" />](https://www.paypal.com/donate/?hosted_button_id=P9V2M4Q6WYHR8)
