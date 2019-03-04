//
//  EventConsumer.swift
//  EventBus
//
//  Created by Thomas Sherwood on 25/07/2016.
//  Copyright © 2016 ShezHsky. All rights reserved.
//

/**
 An `EventConsumer` represents a type that consumes events transmitted through
 an `EventBus`, acting upon the meaning and representation of the received
 `Event`. `Event`s could represent a change in state, timer event, action etc.
 */
public protocol EventConsumer: Equatable {

    /// Represents the type of the event this consumer will observe.
    associatedtype Event

    /**
     Tells this consumer to accept and act upon the `Event`.
     
     - parameters:
        - event: An `Event` broadcast through an `EventBus`, representing a
                 change in state, action or other behaviour within your program.
    */
    func consume(event: Event)

}

public extension EventConsumer where Self: AnyObject {

    /**
     Compares two `EventConsumer`s that are reference types.
     
     - parameters:
     - lhs: An `EventConsumer` to compare
     - rhs: An `EventConsumer` to compare against `lhs`
     
     - returns: `true` if `lhs` and `rhs` both refer to the same `EventConsumer`,
     `false` otherwise.
     */
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }

}
