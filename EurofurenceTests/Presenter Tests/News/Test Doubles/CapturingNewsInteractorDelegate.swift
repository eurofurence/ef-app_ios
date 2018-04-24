//
//  CapturingNewsInteractorDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation.NSIndexPath
import XCTest

class CapturingNewsInteractorDelegate: NewsInteractorDelegate {
    
    fileprivate var viewModel: NewsViewModel?
    func viewModelDidUpdate(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }
    
}

extension CapturingNewsInteractorDelegate {
    
    struct Expectation {
        
        var components: [AnyHashable]
        
    }
    
    func verify(_ expectation: Expectation, file: StaticString = #file, line: UInt = #line) {
        class Visitor: NewsViewModelVisitor {
            var components = [AnyHashable]()
            
            func visit(_ userWidget: UserWidgetComponentViewModel) {
                components.append(AnyHashable(userWidget))
            }
            
            func visit(_ announcement: AnnouncementComponentViewModel) {
                components.append(AnyHashable(announcement))
            }
            
            func visit(_ event: EventComponentViewModel) {
                components.append(AnyHashable(event))
            }
        }
        
        let visitor = Visitor()
        if let viewModel = viewModel {
            var indexPaths = [IndexPath]()
            for section in (0..<viewModel.numberOfComponents) {
                for index in (0..<viewModel.numberOfItemsInComponent(at: section)) {
                    let indexPath = IndexPath(row: index, section: section)
                    indexPaths.append(indexPath)
                }
            }
            
            indexPaths.forEach({ viewModel.describeComponent(at: $0, to: visitor) })
        }
        
        guard expectation.components == visitor.components else {
            XCTFail("Expected \(expectation.components.count) components, but got \(visitor.components.count)",
                    file: file,
                    line: line)
            return
        }
        
        for (idx, expected) in expectation.components.enumerated() {
            let actual = visitor.components[idx]
            if expected != actual {
                XCTFail("Components at index \(idx) not equal: Expected \(expected), but got \(actual)")
                return
            }
        }
    }
    
}
