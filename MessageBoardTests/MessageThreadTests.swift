//
//  MessageThreadTests.swift
//  MessageBoardTests
//
//  Created by Andrew R Madsen on 9/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import XCTest
@testable import Message_Board

class MessageThreadTests: XCTestCase {
    
    func testCreateNewThread() {    // Bug 1 unit test
        let messageThreadController = MessageThreadController()
        
        let expectation = XCTestExpectation(description: "New message thread should have been created")
        let beforeCount = messageThreadController.messageThreads.count
        messageThreadController.createMessageThread(with: "Unit Test Thread") {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(messageThreadController.messageThreads.count, beforeCount + 1)
    }
    
    func testDecodeMessages() {     // Bug 3 unit test
        let messageThreadController = MessageThreadController()
        
        let expectation = XCTestExpectation(description: "Decoding messages failed")
        messageThreadController.fetchLocalMessageThreads {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        let firstThread = messageThreadController.messageThreads.first
        XCTAssertGreaterThan(firstThread?.messages.count ?? 0, 0)
    }
    
    // Bug 5 unit test
    func testEncodeMessage() {
        let messageThreadController = MessageThreadController()

        let expectation = XCTestExpectation(description: "Encoding message failed")
        messageThreadController.fetchMessageThreads {
            let thread = messageThreadController.messageThreads.first
            let messagesInThread = thread?.messages.count
            messageThreadController.createMessage(in: thread!, withText: "Unit test message", sender: "Unit Test") {
                XCTAssertEqual(thread!.messages.count, messagesInThread! + 1)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
        let encoder = JSONEncoder()
        XCTAssertNoThrow(try encoder.encode(messageThreadController.messageThreads.first!.messages.last!))
    }
}
