//
//  OneThreadDispatchSpec.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//  
//

import Foundation
import Quick
import Nimble
@testable import RealmMultiThreadExample

class OneThreadDispatchSpec: QuickSpec {
    
    override func spec() {
        
        var sut: OneThreadDispatch!
        
        beforeEach {
            sut = OneThreadDispatch(label: "UnitTesting")
        }
            
        it("should run all operations in one thread") {
            var threadId: String?
            var operationCount: Int = 0
            let operation = {
                if threadId == nil {
                    threadId = "\(Thread.current)"
                }
                expect(threadId).to(equal("\(Thread.current)"))
                operationCount += 1
            }
            
            for i in 1...10 {
                sut.sync(block: operation)
                expect(operationCount).toEventually(equal(i))
            }
        }
    }
    
}
