//
//  EventBusRegistration.swift
//  EventBus
//
//  Created by Thomas Sherwood on 25/07/2016.
//  Copyright © 2016 ShezHsky. All rights reserved.
//

protocol EventBusRegistration {

    func supports<T>(_ event: T) -> Bool
    func represents<Consumer: EventConsumer>(consumer: Consumer) -> Bool
    func handle(event: Any)

}
