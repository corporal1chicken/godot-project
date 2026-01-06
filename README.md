# Godot Project
Just a simple Godot project. I have no major goals or scope for this, just something to show my progress learning Godot. 

Everything was recorded. Project was started on the 1/1/26.
YouTube Playlist (unlisted): https://www.youtube.com/playlist?list=PLWUHEaMTtDoGK_zPWCeyvtwJ3n01BQGWw

---
### Commit 1: Initial Commit
Basic version of the game. Includes:
- Main Menu
- Choosing a game (none implemented)

---
### Commit 2: a README.md
As the commit name suggests.

---
### Commit 3: Menu Flow Cleanup
Changed how menus are made so it's easier to add/remove screens. Also rewrote all the logic. No progress made on the games, but it's much easier to do so. UI was also realigned and made to scale properly.

---
### Commit 4: This Stupid README
It didn't update so it made a new commit and that's so annoying.

---
### Commit 5: Implemented actual Rock Paper Scissors
Game is actually playable. Pick a difficulty (easy/medium/hard) and it'll change how long you have to pick your move. AI is simple, just picking a move at random so this'll change to reflect difficulty. Also a score count at the top and round end text (you lose! Y beats X).

---
### Commit 6: Cleaned up game logic for Rock Paper Scissors
Separated logic so it's easier to add or remove stuff. Also added gamemodes though hardcoded. Best of 5, First to 3 and Endless. Can select this from the options screen.

---
### Commit 7: Survival Mode and Streak
Streak and best streak counter during RPS. Survival mode where you play until you lose your streak. Also added a quit button to quit midgame, and the game actually resets every new game.

---
### Commit 8: Rewrote main.gd + Small Stuff
Completely rewritten so everything is clearer and less repeated code. Also added rounds played counter and keybinds for the moves (1/2/3 for rock/paper/scissors). Changed how difficulty and gamemode rules are set to be less hardcoded.

---
### Commit 9: Gameplay Stuff
2 more gamemodes, comeback and no repeat. Comback has a max of 8 rounds and the AI starts on 3 points. No repeat doesn't let you play the same move twice. Dedicated results screen which shows more information such as how many times you played each move, total playtime. Also able to click 'enter' to go the next round (similar to 1/2/3 for the moves). Also tracks player history and AI set up.

---
### Commit 10: Pause Menu
Pause whilst in RPS, timer stops. Can go back to the main menu or quit entirely. Also fixed 2 bugs where no repeat ending on the first round, and another where changing your move before round ended was added to the move counter on the result screen. Game gives a reason as to why it ended.

---
### Commit 11: UI Change
Changed the UI a bit. Nothing major, just some colour

---
### Commit 12: More UI changes
Pause menu updated to be with the colour changes. Plays a slide out animation when opened/closed and blocks clicks on anything below it. Buttons are now duplicated in code by the game/difficulty configs so they don't need to be made manually. Controls option for the pause menu, which shows controls based on what screen you're on. 'H' to hide overlay (streak counter and rounds counter) in RPS. Tooltips for buttons as well.

---
### Commit 13: RPS Modifiers
3 modifiers that can be selected in RPS. Lock input doesn't allow move switching, on edge gives every draw a 50% chance to lose 1 point and double points for 2x points which stacks with gamemodes. Also changed gamemode.gd slightly. Changed main.gd to be less dependant of gamemode/difficulty dictionaries and now get everything from a single game_stats dictionary that is edited by gamemode.gd.

---
### Commit 14: Bugs fixes
Fixed a ton of bugs including some gamemodes ending on the first round, results screen being broken, pause menu control screen staying open when the menu is closed, more UI changes, text formatting for game end reasons and not selecting a modifier caused a runtime error. Also added to the RPS overlay details on what gamemode, difficulty and modifier you have. Readded the quit button (that I for some reason removed).