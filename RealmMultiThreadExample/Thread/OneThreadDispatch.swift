//
//  OneThreadDispatch.swift
//  RealmMultiThreadExample
//
//  Created by Michał Solski on 06/02/2021.
//
// This class allows to dispatch operation every time in the same thread

import Foundation

public class OneThreadDispatch {
    
    private lazy var thread: Thread  = {
        Thread(target: self, selector: #selector(run), object: nil)
    }()
    private let threadAvailability = DispatchSemaphore(value: 1)
    
    private var nextBlock: (() -> Void)?
    private let nextBlockPending = DispatchSemaphore(value: 0)
    private let nextBlockDone = DispatchSemaphore(value: 0)
    
    public init(label: String) {
        thread.name = label
        thread.start()
    }
    
    public func sync(block: @escaping () -> Void) {
        threadAvailability.wait()
        nextBlock = block
        nextBlockPending.signal()
        nextBlockDone.wait()
        nextBlock = nil
        threadAvailability.signal()
    }
    
    @objc private func run() {
        while true {
            nextBlockPending.wait()
            nextBlock!()
            nextBlockDone.signal()
        }
    }
}
