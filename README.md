# Slide for Four
Slide for Four is my entry for the Flutter Puzzle Hack Challenge.
You can play the game either by visiting the Website: [Slide for Four](https://slide-for-four.de)
or by installing the client or the client and the server on your device.

## How to Install
Before following this installtion guide you need to clone this repository.
Additionally you need [NodeJs](https://nodejs.org/en/) and [Flutter](https://flutter.dev/) installed on your device.

### Client
You can use the client either with my server, or with a self hosted server.

To use my server:
1. Enter the directory `frontend`
2. Run the command: `flutter pub get`
3. Run the command: `flutter build web --release --web-renderer html`
4. Enter the directory `frontend/build`
5. Run the command: `npm i`
6. Run the command: `node index.js`
7. Open your Browser and visit: [http://localhost:3000](http://localhost:3000)

To use your self hosted server:
1. Enter the directory `frontend`
2. Run the command: `flutter pub get`
3. Enter the directory `frontend/lib/helper`
4. Change the `address` inside the file `config.dart` to `ws://localhost:5000`
5. Run the command: `flutter build web --release --web-renderer html`
6. Enter the directory `frontend/build`
7. Run the command: `npm i`
8. Run the command: `node index.js`
9. Open your Browser and visit: [http://localhost:3000](http://localhost:3000)

### Server
1. Open the directory `backend`
2. Run the command: `npm i`
3. Run the command: `node index.js`

## How to Play
Instructions on how to play after you already visited the Website.
You always need a connection to the server (either mine or a self hosted one).

You can decide between Single- and Multiplayer. In the Singleplayer you play against an AI and in the Multiplayer you can play against a friend. To play the Multiplayer one of you has to create a new game and send the room code to a friend (you can copy it by clicking on the code). The other one has to join this game by entering the code in the text field that appears after clicking on join.

If one of you gets disconnected for whatever reason, reload the app and reconnect to the game by entering the code after clicking on reconnect.

Inside the Game you have to move your tiles by moving the white ones in the appropriate direction. The first one moving four of their own tiles in a row, column or diagonal wins the game.

Now we will have a look at the controls.
### PC
On PC you can hover over the white tiles to get buttons that visualize where the tile will move.

### Mobile
On Mobile you have to swipe on top of the white tiles in the direction you want them to move in.

My presentation of the game in video format can be found on youtube: [https://www.youtube.com/watch?v=MIHzGOf9Iag](https://www.youtube.com/watch?v=MIHzGOf9Iag)
