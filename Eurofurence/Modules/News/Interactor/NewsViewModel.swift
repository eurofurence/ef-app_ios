//
//  NewsViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol NewsViewModel {

    var numberOfComponents: Int { get }

    func numberOfItemsInComponent(at index: Int) -> Int
    func titleForComponent(at index: Int) -> String

}
