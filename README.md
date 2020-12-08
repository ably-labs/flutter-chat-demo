# Flutter chat app demo

This is a basic chat app built with [Flutter](https://flutter.dev/) and [Ably](https://www.ably.io/).

You can check out a [short video demo of this application along with some explanation of the code](https://www.youtube.com/watch?v=wwytqIh8km0).

<img width="1000" alt="Ably Flutter chat app screenshot" src="https://user-images.githubusercontent.com/5900152/98269650-e64f4c00-1f85-11eb-807a-0852ed90b813.png">

## How to run this app locally

1. Clone this repo and cd to the folder containing the project files:

`git clone https://github.com/ably-labs/flutter-chat-demo.git`

`cd flutter-chat-demo/realtime_chat_ably`

2. [Create a free account with Ably](https://www.ably.io/signup) to get your API Key.

3. Add a file called `config.dart` in `/realtime_chat_ably/lib` and paste the following: 

```
const String AblyAPIKey = "YOUR-ABLY-API-KEY";
```

Replace the placeholder with your own API Key

4. Run `flutter packages get` to install the dependencies

5. Open two or more simulators on your system

6. Run `flutter run -d all` to run the app on all the simulator devices

When you send a message in one of the devices, it should come up in realtime on all the devices.


---

## What is Ably?

[Ably](https://www.ably.io/) is a pub/sub messaging platform with a suite of integrated services to deliver complete realtime functionality directly to end-users. 

This project uses [Ably's Flutter plugin](https://pub.dev/packages/ably_flutter_plugin/) to enable realtime chat between any number of users.

---

The app's UI is adopted from Marcus Ng's YouTube video - [Flutter Chat UI Tutorial | Apps From Scratch](https://www.youtube.com/watch?v=h-igXZCCrrc)

<img width="1000" alt="YouTube video screenshot" src="https://user-images.githubusercontent.com/5900152/101506105-f2f00700-396c-11eb-8283-124f40b0a3c6.png">

## Other notes

- All of Ably's messaging limits, broken down by package can be found in a [support article](https://support.ably.com/support/solutions/articles/3000053845-do-you-have-any-connection-message-rate-or-other-limits-on-accounts-).

- If you have any questions, please [leave a message to me directly on Twitter](https://www.twitter.com/Srushtika) or reach out to Ably's support team at [support@ably.com](mailto:support@ably.com).

- It'll be amazing and helpful to other developers to add more features to this chat app, please check out the open issues if you'd like to contribute to this project.