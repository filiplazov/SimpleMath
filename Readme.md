# Simple Math app

[![Build Status](https://app.bitrise.io/app/bdde9ef31505ea1c/status.svg?token=Hm5PXHsL4uQeV_oGsKFtuA&branch=master)](https://app.bitrise.io/app/bdde9ef31505ea1c)

SimpleMath is an app that generates simple math equations for young children to help them solve and learn in a fun way. I've made this app for my 6 year old daughter because I don't have to write or print the equations and I don't need to evaluate them as well, the app does it all. 
I am very happy I can make my daughter's learning process easier, but this project has also given me a great "toy" to play around and learn / practice SwiftUI & Combine.
It is heavily inspired by Paul Hudson's recent [SwiftUI Live video](https://www.youtube.com/watch?v=FE4ys3tW1VI), I highly recommend it.

## Features

- [x] Generate addition, subtraction, multiplication and division equations.
- [x] Record results and provide visual and audio feedback.
- [x] Show progress of completed equations as well as correct answers.
- [x] Display results after a completed session with corrections on wrong answers.
- [x] An option to start a new session after finishing.
- [x] Display a simple cheerful animation if all equations are solved correctly.
- [x] Settings UI that allows customization of:
    - [x] Operand digit input range.
    - [x] Number of generated equations (minimum 5, maximum 30).
    - [x] Enable / disable equation types: addition, subtraction, multiplication, division.
    - [x] Toggle sounds.
- [x] Scaling fonts and UI for all supported iOS13+ devices.

<p align="center">
    <img src="Images/Recording.gif" width="400" max-width="90%" alt="SimpleMath" />
</p>

## Todo

- [ ] Add light / dark mode support.
- [ ] Customize colors / themes (it is very purple now, my target audience demanded it!).
- [ ] Support landscape layout.
- [ ] Adaptive sessions, use wrong answers from previous sessions, repetition is key!
- [ ] More gamification, with sounds and visual effects, simple achievement system.
- [ ] Helpful hints when tapping on current equation.
- [ ] Flexible equation layout, ex `1 + _ = 3`.
- [ ] Whatever my target audience demands!

## Is this app available on the App Store?

Yes, click on the link below.

<p align="center">
  <a href="https://apps.apple.com/us/app/simple-math-learn-by-solving/id1508285174?ls=1">
    <img src="Images/appstore.png" width="400" max-width="90%" alt="App Store" />
  </a>
</p>

## What about Android?

At this time I have no plans to support Android, but you are more than welcome to implement an Android version yourself.

## Requirements

- iOS 13.2+
- Xcode 11.4+
- Swift 5.2+

## Author
* [Filip Lazov](https://github.com/filiplazov) ([@filiplazov](https://twitter.com/filiplazov))

## Credits
SimpleMath was inspired by the following projects:

* [SwiftUI Live: Building an app from scratch](https://www.youtube.com/watch?v=FE4ys3tW1VI) by [Paul Hudson](https://twitter.com/twostraws)
* [Build a SwiftUI App for iOS13](https://designcode.io/swiftui?promo=learnswiftui) by [Meng To](https://twitter.com/MengTo) (Design+code)
* [Thinking in SwiftUI](https://www.objc.io/books/thinking-in-swiftui/) A book by [Chris Eidhof](https://twitter.com/chriseidhof) and [Florian Kugler](https://twitter.com/floriankugler)

## License

SimpleMath is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

All sounds in this project are made using Garage Band and are royalty free.