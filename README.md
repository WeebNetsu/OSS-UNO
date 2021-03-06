# OSS-UNO

I could not find a decent UNO game, so I decided to make my own ;)

Why is this better than any other UNO game?

- No ads
- No "pay to continue playing" system
- 100% free
- Open source
  - If you don't like something, you can change it
  - If you want something, you can add it
- Looks good
- Good performance
- No tracking
- No selling your data

## Running The Game

### Requirements

- [Lua](https://www.lua.org) (v5.4+)
- [Love2D](https://love2d.org) (v11.4)

### Setup & Running

1. Get the code on your PC (git clone or download)
2. Go into the folder with main.lua
3. `love .`
4. Enjoy UNO

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

## VSCode Debugging

### Requirements:

- https://marketplace.visualstudio.com/items?itemName=tomblind.local-lua-debugger-vscode

### Setup

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
