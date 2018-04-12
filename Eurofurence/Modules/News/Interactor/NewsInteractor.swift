//
//  NewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol NewsInteractor {

    func prepareViewModel(_ completionHandler: @escaping (NewsViewModel) -> Void)

}
