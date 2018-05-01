//
//  VerifyingNewsInteractorDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation.NSIndexPath
import XCTest

class VerifyingNewsInteractorDelegate: NewsInteractorDelegate {
    
    fileprivate var viewModel: NewsViewModel?
    func viewModelDidUpdate(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }
    
}

extension VerifyingNewsInteractorDelegate {
    
    struct Expectation {
        
        var components: [AnyHashable]
        var titles: [String]
        
        fileprivate func verify(components: [AnyHashable], titles: [String?], file: StaticString, line: UInt) {
            guard self.components.count == components.count else {
                XCTFail("Expected \(self.components.count) components, but got \(components.count)",
                    file: file,
                    line: line)
                return
            }
            
            for (idx, expected) in self.components.enumerated() {
                let actual = components[idx]
                if expected != actual {
                    XCTFail("Components at index \(idx) not equal: Expected \(expected), but got \(actual)")
                    return
                }
            }
            
            guard self.titles.count == titles.count else {
                XCTFail("Expected \(self.titles.count) titles, but got \(titles.count)",
                    file: file,
                    line: line)
                return
            }
            
            for (idx, expected) in self.titles.enumerated() {
                let actual = titles[idx]
                if expected != actual {
                    XCTFail("Titles at index \(idx) not equal: Expected \(String(describing: expected)), but got \(String(describing: actual))",
                        file: file,
                        line: line)
                    return
                }
            }
        }
        
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
            
            func visit(_ countdown: ConventionCountdownComponentViewModel) {
                components.append(AnyHashable(countdown))
            }
        }
        
        let visitor = Visitor()
        var titles: [String?] = []
        if let viewModel = viewModel {
            traverse(through: viewModel, using: visitor)
            titles = (0..<viewModel.numberOfComponents).map(viewModel.titleForComponent)
            
            expectation.verify(components: visitor.components, titles: titles, file: file, line: line)
        }
        else {
            XCTFail("Did not witness a view model", file: file, line: line)
        }
    }
    
    private func traverse(through viewModel: NewsViewModel, using visitor: NewsViewModelVisitor) {
        var indexPaths = [IndexPath]()
        let numberOfComponents = viewModel.numberOfComponents
        
        for section in (0..<numberOfComponents) {
            for index in (0..<viewModel.numberOfItemsInComponent(at: section)) {
                let indexPath = IndexPath(row: index, section: section)
                indexPaths.append(indexPath)
            }
        }
        
        indexPaths.forEach({ viewModel.describeComponent(at: $0, to: visitor) })
    }
    
}
