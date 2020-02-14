# 🧭 Navigation in SwiftUI

![swift v5.1](https://img.shields.io/badge/swift-v5.1-orange.svg)
![platform iOS](https://img.shields.io/badge/platform-iOS-blue.svg)
![deployment target iOS 13](https://img.shields.io/badge/deployment%20target-iOS%2013-blueviolet)

Unidirectional data flow driven navigation for SwiftUI applications

## 📝 Description

This project explores ways to implement navigation in a SwiftUI application, using unidirectional data flow architecture.

### ➡️ Demo app

Simple application with a navigation stack that mimics `UINavigationController` behavior. From initial, root screen user can go to the first step screen. The step screen allows to navigate to the next step (until step number three, which is the last one) or to go back to the root screen.

![navigation flow](Misc/navigation_flow.svg)

State of the navigation stack is modeled as an array of navigation items, hold by a store object. Whenever the array changes, view is updated to display top-most navigation item from the stack. User interface is fully customizable, supports **"swipe from edge to go back"** gesture and both **left-to-right** and **right-to-left** layout directions. The implementation provides some default visual style and animations, but those can be easily customized as well. Everything is written in **pure SwiftUI**, without using `UIViewControllerRepresentable` to wrap `UINavigationController`.

Component | Description
:--- | :---
[`Store`](SwiftUINavigationDemo/State/Store.swift) | Simplified implementation of **store object** that holds app's state
[`RootState`](SwiftUINavigationDemo/State/RootState.swift) | **State model** representation of root screen view
[`StepState`](SwiftUINavigationDemo/State/StepState.swift) | **State model** representation of step screen view

View | Description
:--- | :---
[`AppView`](SwiftUINavigationDemo/Views/AppView.swift) | Main **view** of the app containing navigation stack
[`RootView`](SwiftUINavigationDemo/Views/AppView.swift) | Root screen **view**, initial screen of the app
[`StepView`](SwiftUINavigationDemo/Views/AppView.swift) | Step screen **view**

### 🧩 Navigation components

Component | Description
:--- | :---
[`NavigationItem`](SwiftUINavigationDemo/Navigation/NavigationItem.swift) | Protocol of a **state model** that represents an item on navigation stack
[`NavigationItemView`](SwiftUINavigationDemo/Navigation/NavigationItemView.swift) | **View** that represents navigation item
[`NavigationItemViewFactory`](SwiftUINavigationDemo/Navigation/NavigationItemViewFactory.swift) | **Function** that creates a view for given navigation item
[`NavigationStackView`](SwiftUINavigationDemo/Navigation/NavigationStackView.swift) | **View** that represents stack of navigation items, as `UINavigationController` does
[`NavigationBarView`](SwiftUINavigationDemo/Navigation/NavigationBarView.swift) | **View** that represents navigation bar
[`NavigationBackButton`](SwiftUINavigationDemo/Navigation/NavigationBackButton.swift) | Back button **view** that can be displayed on navigation bar
[`NavigationBackGesture`](SwiftUINavigationDemo/Navigation/NavigationBackGesture.swift) | **View modifier** that attaches a "swipe from edge to go back" gesture to the navigation item view

## 🛠 Setup

Requirements:

- [Xcode](https://developer.apple.com/xcode/) 11.3.1

Open `SwiftUINavigation.xcodeproj` in Xcode and run the app.

## 📄 License

Copyright © 2020 [EL Passion](https://www.elpassion.com)

License: [GNU GPLv3](LICENSE)
