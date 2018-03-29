#  Re-Architecture Aims + Design

This document pertains to the reasoning behind the change in architecture for the Eurofurence app. An overview of the current design of the app (at time of writing) along with the issues we have found is laid out, followed by the proposed design and motiviation.

This document remains a work in progress.

## Current Design

The Eurofurence app is composed of several discrete sections, each containing their own aggregation of features, including (but not limited to):

- Overview of con announcements and upcoming events
- Access to the event schedule and information about specific events
- Dealers in the den, along with their custom content they have provided

Each section is backed by its own `UIViewController` subclass, with its view outlet configured in `Main.storyboard`. Segues bind the flow of the application, such as nesting sections inside a `UITabBarController` and pushing additional `UIViewController`s based on user actions (e.g. tapping events). Each `UIViewController` subclass knows how to obtain its data via a dependency container, in addition to having access to app services as needed such as image loading. These are then utilised to perform appropriate operations on its views, configuring the scene for presentation, and so on. This follows the Model-View-Controller (MVC) pattern, such that:

- Updates to the model are propogated to the view controller; the view controller directly pokes the model
- Events from the view are handled by the view controller; the view controllers configures the view for presentation
- The view types are not aware of the model and vice-versa

Backing the main chunk of the model tier is ReactiveSwift -

### Flaws

The flaw in the aformentioned design is that our  `UIViewController` classes become massive (instead following the Massive-View-Controller pattern), making it difficult to reason about exactly what behaviour resides where. For example, the `UIViewController` subclass must:

- Perform appropriate bindings on the data provided by the model
- Make decisions based on the data available to change the presentation of the view
- Adapt view interactions directly into model events such as a refresh, opening a URL or showing another view controller

This leaves us in the position where changes to the app are less safe, and more time consuming then first assumed, as each `UIViewController` handles more behaviour than expected. For example:

- Changing the flow or structure of the app requires tearing down and rebuilding of segues; the presenting `UIViewController` will also have directly been aware of the specific `UIViewController` being presented
- Amendments to behaviour of a particular scene are likely to have side-effects, as there is often complex decision making in preparing views for presentation
- The view tier is intimate with how the data is structured,

In addition to the above, the app has become completley dependant on a framework outside of our control (ReactiveSwift). We've previously ran into behavioural issues during integration into the app, however post-release it was made clear our ability to move forward with Swift and iOS versions may also be limited by the framework. We remain at the whim of ReactiveSwift to keep up to date in order to move forward ourselves. In addition, in the event of a drastic API change on their part, a significant amount of the app will need updating.

## Proposal

This document proposes that a complete re-architecture of the app is carried out, with the following intentions:

- Prepare a comprehensive test suite such that we can decide whether to release in seconds, rather than days
- Make clear boundaries between where data is processed and how it is presented, such that both can change independant of one another
- Remove dependencies on as many external frameworks as possible, allowing us to move forward at our own pace unhinhibited by third parties

In order to support current roadmaps, this change is to be performed concurrently behind a feature switch. This allows partial releases of the new design without impacting any users, in the event we are not finished moving towards the new design in time for the convention.


