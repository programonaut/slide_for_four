# Slide for Four Frontend

This is the client for Slide for Four. You can find it on [https://slide-for-four.de](https://slide-for-four.de).

Otherwise you can also install it on your own like this. You have two options. First to use it with my server and second to use it with a self hosted one.

To use my server:
1. Enter the directory `frontend`
2. Run the command: `flutter pub get`
3. Run the command: `flutter build web --release --web-renderer html`
4. Enter the directory `frontend/build`
5. Run the command: `npm i`
6. Run the command: `node index.js`
7. Open your Browser and visit: [http://localhost:3000](http://localhost:3000)

To use your self hosted server (to install check [here](../backend/README.md)):
1. Enter the directory `frontend`
2. Run the command: `flutter pub get`
3. Enter the directory `frontend/lib/helper`
4. Change the `address` inside the file `config.dart` to `ws://localhost:5000`
5. Run the command: `flutter build web --release --web-renderer html`
6. Enter the directory `frontend/build`
7. Run the command: `npm i`
8. Run the command: `node index.js`
9. Open your Browser and visit: [http://localhost:3000](http://localhost:3000)