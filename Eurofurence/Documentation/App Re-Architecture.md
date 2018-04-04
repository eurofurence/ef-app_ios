#  Re-Architecture Aims + Design

This document pertains to the reasoning behind the change in architecture for the Eurofurence app. An overview of the current design of the app (at time of writing) along with the issues we have found is laid out, followed by the proposed design and motiviation.

This document remains a work in progress.

## Current Design

The Eurofurence app is composed of several discrete sections, each containing their own aggregation of features, including (but not limited to):

- Overview of con announcements and upcoming events
- Access to the event schedule and information about specific events
- Dealers in the den, along with their custom content they have provided

Each section is backed by its own `UIViewController` subclass, with its view outlet configured in `Main.storyboard`. Segues bind the flow of the application, such as nesting sections inside a `UITabBarController` and pushing additional `UIViewController`s based on user actions (e.g. tapping events). Each `UIViewController` subclass knows how to obtain its data via a dependency container, in addition to having access to app services such as image loading. These are then utilised to perform appropriate operations on its views, configuring the scene for presentation, and so on. This follows the Model-View-Controller (MVC) pattern, such that:

- Updates to the model are propogated to the view controller; the view controller performs operations on or using the model
- Events from the view are handled by the view controller; the view controller configures the view for presentation
- The view types are not aware of the model and vice-versa

Updates to the model are propogated using ReactiveSwift - a third party framework that exposes hooks into listening to changes on well-defined types. This additional glue is configured in the `viewDidLoad` implementations of most `UIViewController` subclasses, however this varies based on the content being shown.

### Flaws

The primary flaw in our current design is that a nontrivial amount of business logic resides in the presentation tier. Our `UIViewController`s know too much about our model, and have absorbed far too many responsibilities. This leaves us in the position where changes to the app are unsafe, and more time consuming then first assumed, as each `UIViewController` handles more behaviour than expected. For example:

- Changing the flow or structure of the app requires tearing down and rebuilding of segues; a symptom of this is exhibited via the presenting `UIViewController` being aware of the specific `UIViewController` class being presented in order to configure it for presentation
- Amendments to behaviour of a particular scene are likely to have side-effects, as there is often complex decision making in preparing views for presentation. Instead of our presentation tier being told what to show, it instead has to infer what to display from the model
- As a consequence of the above, the view tier is intimate with how the data is structured. We cannot freely play with the structure of our model without needing to perform some shotgun surgery amongst the view model and presentation types

In addition to the above, the app has become completley dependant on a framework outside of our control (ReactiveSwift). We've previously ran into behavioural issues during integration into the app, however post-release it was made clear our ability to move forward with Swift and iOS versions may also be limited by the framework. We remain at the whim of ReactiveSwift to keep up to date with Xcode and Seift migrations in order to move forward ourselves. Further to this, in the event of a drastic API change on their part a significant amount of the app will need updating to accomodate the changes.

## Proposal

This document proposes that a complete re-architecture of the app is carried out, with the following intentions:

- Prepare a comprehensive test suite to catch regressions at development time
- Make clear boundaries between where data is processed and how it is presented
- Remove dependencies on as many external frameworks as possible

In order to support current roadmaps, this change is to be performed concurrently behind a feature switch. This allows partial releases of the new design without impacting any users, in the event we are not finished moving towards the new design in time for the convention.

### Test-First Development

To support a comprehensive test suite, tests should be at the forefront of our development lifecycle. New behaviour in the system must be documented with a failing (red) test, before any changes to production code are made. Following this principle allows us to freely restructure the internals of the app as patterns emerge while catching potential regressions ahead of a commit. This practice is known as TDD, of which there are plentiful resources online.

In addition to the above, a high quality test suit gives us additional safety in our release process. At present, we are at the behest of manually testing the app with attendee support in order to figure out if a build is up to par. This process is slow, prone to error and likely does not exhaust all the app behaviour. With enough coverage, we will be able to deduce whether a release of the app can be made within a few seconds with a higher deg.

### Domain Modelling

With our business logic residing in our presentation tier, rules of our domain are unclear - how our model is processed, and what we get out of it, are muddled together. Seperating our domain such that the acquisition and storage of our data is isolated from processing for our presentation tier allow for minimal risk when making changes to either side. This also allows for rapid and radical changes to the presentation tier in isolation from rest of the system, opening up the potential for more reuse between conventions should we open up the core behaviour of the app.

### Isolating Ourselves from Dependencies

As Swift and the Xcode toolset continue to rapidly change, we should aim to be at the forefront of (stable) releases. Too many third party dependencies can make this more difficult to achieve, either due to slow uptake or as projects eventually die down and become unmaintained. While we should not look to reinvent the wheel, becoming dependant on an external library should be justified and considered a risk.

## Proposed Design

TBD
