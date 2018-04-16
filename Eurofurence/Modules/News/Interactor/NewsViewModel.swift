//
//  NewsViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct NewsViewModel {

    struct Component {

        var title: String
        var numberOfItems: Int

    }

    var components: [Component]

    var numberOfComponents: Int {
        return components.count
    }

    func numberOfItemsInComponent(at index: Int) -> Int {
        return components[index].numberOfItems
    }

    func titleForComponent(at index: Int) -> String {
        return components[index].title
    }

}
