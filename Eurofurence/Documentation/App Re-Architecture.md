#  Re-Architecture Aims + Design

This document pertains to the reasoning behind the change in architecture for the Eurofurence app. An overview of the current design of the app (at time of writing) along with the issues we have found is laid out, followed by the proposed design and motivation.

This document remains a work in progress.

## Current Design

The Eurofurence app is composed of several discrete sections, each containing their own aggregation of features, including (but not limited to):

- Overview of con announcements and upcoming events
- Access to the event schedule and information about specific events
- Dealers in the den, along with their custom content they have provided

Each section is backed by its own `UIViewController` subclass, with its view outlet configured in `Main.storyboard`. Segues bind the flow of the application, such as nesting sections inside a `UITabBarController` and pushing additional `UIViewController`s based on user actions (e.g. tapping events). Each `UIViewController` subclass knows how to obtain its data via a dependency container, in addition to having access to app services such as image loading. These are then utilised to perform appropriate operations on its views, configuring the scene for presentation, and so on. This follows the Model-View-Controller (MVC) pattern, such that:

- Updates to the model are propagated to the view controller; the view controller performs operations on or using the model
- Events from the view are handled by the view controller; the view controller configures the view for presentation

Updates to the model are propagated using ReactiveSwift - a third party framework that exposes hooks into listening to changes on well-defined types. This additional glue is configured in the `viewDidLoad` implementations of most `UIViewController` subclasses, however this varies based on the content being shown.

### Flaws

The primary flaw in the current design is that a nontrivial amount of business logic resides in the presentation tier. The `UIViewController`s know too much about the model, and have absorbed far too many responsibilities. This leaves the system in the position where changes to the app are unsafe, and more time consuming then first assumed, as each `UIViewController` handles more behaviour than expected. For example:

- Changing the flow or structure of the app requires tearing down and rebuilding of segues
- Presenting `UIViewController`s are aware of the specific `UIViewController` class being presented in order to configure it for presentation, binding the flow together
- Amendments to behaviour of a particular scene are likely to have side-effects, as there is often complex decision making in preparing views for presentation. Instead of the presentation tier being told what to show, it instead has to infer what to display from the model
- As a consequence of the above, the view tier is intimate with how the data is structured. We cannot freely play with the structure of the model without needing to perform some shotgun surgery amongst the view model and presentation types

In addition to the above, the app has become completely dependant on a framework outside of our control (ReactiveSwift). We've previously ran into behavioural issues during integration into the app, however post-release it was made clear our ability to move forward with Swift and iOS versions may also be limited by the framework. We remain at the whim of ReactiveSwift to keep up to date with Xcode and Swift migrations in order to move forward ourselves. Further to this, in the event of a drastic API change on their part a significant amount of the app will need updating to accommodate the changes.

## Proposal

This document proposes that a complete re-architecture of the app is carried out, with the following intentions:

- Prepare a comprehensive test suite to catch regressions at development time
- Make clear boundaries between where data is processed and how it is presented
- Remove dependencies on as many external frameworks as possible

In order to support current roadmaps, this change is to be performed concurrently behind a feature switch. This allows partial releases of the new design without impacting any users, in the event we are not finished moving towards the new design in time for the convention.

### Test-First Development

To support a comprehensive test suite, tests should be at the forefront of our development lifecycle. New behaviour in the system must be documented with a failing (red) test, before any changes to production code are made. Following this principle allows us to freely restructure the internals of the app as patterns emerge while catching potential regressions ahead of a commit. This practice is known as TDD, of which there are plentiful resources online.

In addition to the above, a high quality test suit gives us additional safety in the release process. At present, we are at the behest of manually testing the app with attendee support in order to figure out if a build is up to par. This process is slow, prone to error and likely does not exhaust all the app behaviour. With enough coverage, we will be able to deduce whether a release of the app can be made within a few seconds with a higher deg.

### Domain Modelling

With the business logic residing in the presentation tier, rules of the domain are unclear - how the model is processed and presented are muddled together. Separating the domain such that the acquisition and storage of data is isolated from processing for the presentation tier allow for minimal risk when making changes to either side. This also allows for rapid and radical changes to the presentation tier in isolation from rest of the system, opening up the potential for more reuse between conventions should we open up the core behaviour of the app.

### Isolating Ourselves from Dependencies

As Swift and the Xcode toolset continue to rapidly change, we should aim to be at the forefront of (stable) releases. Too many third party dependencies can make this more difficult to achieve, either due to slow uptake or as projects eventually die down and become unmaintained. While we should not look to reinvent the wheel, becoming dependant on an external library should be justified and considered a risk.

## Proposed Design

(Note to reader: this section also discusses the design in-flight. Amendments to this are more than welcome as potential improvements are spotted.)

The proposed design is composed of several pieces:

- A `Director` that decides how the flow of the application should behave in response to user actions
- An app `Core` that manages the acquisition, processing and storage of con data in addition to system behaviour. This has the potential to be OS-agnostic.
- A set of `Module`s that represent scenarios within the app, providing views into the `Core`

### Director

The `Director` follows its metaphor, in that it is aware of all the scenes to be shown and how they should look. However it does not particularly _care_ how these scenes work, only that:

- They can be presented using standard OS patterns, e.g. `UIViewController` presentation
- They make require data (inputs) in order to function, and that they may produce events (outputs) that trigger other scenes to be displayed
- They are presentation-agnostic, such that the director can freely rearrange the scenes

This allows parts of the app to be developed in silos, while the `Director` manages the binding of them all together. It allows for the rearrangement of app components, such as moving to other navigation paradigms, while not requiring the scenes themselves to change.

### Module

A `Module` represents a component of the app that provides a function, for example the list of events would be an 'Events List' module. Modules are produced from a factory, which outputs a `UIViewController`. How the module is composed is an implementation detail, however for the purposes of testability the existing modules are composed of the following:

- The `presentation tier` (a `UIViewController` with a `UIView`, configured using a `.storyboard` or `.xib`) that purely focuses on the rendering of data, and interpretation of user actions into domain events (e.g. `userDidTapLoginButton`)
- A `presenter` that listens for events from the presentation tier, and performs actions on domain objects
- An `interactor` that represents a use case of the domain, that processes model objects acquired from the `Core` into `view model`s for presentation
- A `builder` that can compose the module using real dependencies, allowing the tests to be constructed at the widest level for the module while the director can build the real system trivially

When creating a new module, following test-first development against the `presenter` allows for tests that describe user actions against the domain. These are not only easy to write, but also produce the appropriate ports on the `presentation tier` and `interactor` that become trivial to write tests for and implement without producing unneeded work. This is formally known as presenter-first TDD (https://atomicobject.com/uploads/archive/files/PF_March2005.pdf).

### Core

The `Core` sits at the centre of everything, independent from presentation concerns and preferably operating system agnostic. It has no dependencies on system or third party frameworks, instead declaring ports against technology boundaries (e.g. network). This provides several benefits, including:

- All knowledge of how the model is acquired and persisted, along with the associated business rules for processing and adaption, live in one place
- With no platform or technology dependencies, the core can trivially run on any supported platform (e.g. macOS) or be easily ported for other apps
- The induced separation between presentation and business logic allows the two to develop in parallel with significantly reduced risk

Features of the core are deduced from use-cases that become apparent while following presenter-first TDD. It is important to note however that these features on the core must remain presentation agnostic; the requirement for data should feed into the API for the core, how it is presented should not go anywhere near it.

## Delivery

Some headway has already began on performing the above re-architechture, in order to come closer towards an ideal pattern. This includes:

- Porting some simple screens across to follow the `Module` pattern described above, specifically:
    - The 'Root' module on app launch
    - Tutorial
    - Preload
    - News (very basic version)
    - Login
    - Messages List
    - Message Detail
    - Knowledge List
    - Knowledge Detail
    - Web Pages
- The initial addition of the `Director`, that controls the presentation of the above `Module`s
- The inclusion of the app `Core` to support the above modules

This means that, at time of writing, the following screens are *not* ported across to modules:

- News Detail
- Events List
- Event Detail
- Dealers List
- Dealer Detail
- Maps
- Collect'em All*
- Settings
- About

*The Collection'em All in the current live version was backed by a web view, so there are likely multiple sub-modules to be spawned when porting this one across to a native implementation

Delivery of additional modules will also require changes to be made to the `Core` as new features are identified.

