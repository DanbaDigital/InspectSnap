# InspectSnap
WoW Classic addon that 'snaps' the inspected character to be still, allowing you to see the gear while walking away.

## Installation
1. Download the addon files.
2. Extract the `InspectSnap` folder into your `World of Warcraft/Interface/AddOns/` directory.
3. Restart WoW or reload UI (`/reload`).
4. Enable the addon in the AddOns menu (from character select screen).

## Usage
- Inspect a target as usual (right-click > Inspect).
- A custom InspectSnap window will appear showing the target's gear.
- The window remains open even after moving away, allowing continued gear inspection.
- Drag the window to reposition.
- Close with the X button.
- Toggle the addon on/off with `/inspectsnap toggle`.

## Limitations
- Does not actually freeze the inspected character's model (not possible in Classic APIs).
- Gear data is captured at the time of inspection; does not update in real-time.
- Custom frame may not perfectly replicate the default inspect UI.
- Use at your own risk; ensure compliance with server rules.

## Compatibility
- Designed for Turtle WoW (version 1.18.0, interface 11200).
- May work on other Classic servers with similar API. 
