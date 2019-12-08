//
//  puzzle444Tests.swift
//  puzzle444Tests
//
//  Created by 01587913 on 25.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import XCTest
@testable import puzzle444

class puzzle444Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGame() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game=Game()
        XCTAssertNotNil(game)
    }

    func testMovesisEmpty() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game=Game()
        let result = game.moves.count == 0
        XCTAssertTrue(result)
    }

    func testFirstPlayer() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game=Game()
        let result = game.activePlayer == .blue
        XCTAssertTrue(result)
    }

    func testNextPlayers() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game=Game()
        game.move(dotName: "111")
        var result = game.activePlayer == .red
        XCTAssertTrue(result)
        game.move(dotName: "222")
        result = game.activePlayer == .blue
        XCTAssertTrue(result)
    }

    func testUndo() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game=Game()
        var result = game.moves.count == 0
        XCTAssertTrue(result)

        game.move(dotName: "111")
        game.move(dotName: "222")
        game.undo()
        result = game.moves.count == 1
        XCTAssertTrue(result)
    }

    func testGameOver(){
        let game=Game()
        game.dots[0] = .blue
        game.dots[1] = .blue
        game.dots[2] = .blue
        game.dots[3] = .blue
        game.checkGameOver()
        guard let result = game.isGameOver else {
            XCTFail("Результат должен быть определен")
            return
        }
        XCTAssertTrue(result)
    }
    
    func testNoGameOver(){
        let game=Game()
        game.dots[0] = .blue
        game.dots[1] = .blue
        game.dots[2] = .red
        game.dots[3] = .blue
        game.checkGameOver()
        guard let result = game.isGameOver else {
            XCTFail("Результат должен быть определен")
            return
        }
        XCTAssertFalse(result)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
