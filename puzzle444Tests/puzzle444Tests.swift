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
        let game = Game()
        XCTAssertNotNil(game)
    }

    func testMovesisEmpty() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game = Game()
        let result = game.moves.count == 0
        XCTAssertTrue(result)
    }

    func testFirstPlayer() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game = Game()
        let result = game.activePlayer == .blue
        XCTAssertTrue(result)
    }

    func testNextPlayers() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let game = Game()
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
        let game = Game()
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
        let game = Game()
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
    
    func testCoordinates(){
        var result: Bool
        let game = Game()
        game.move(dotName: "000")
        game.move(dotName: "333")

        result = game.dots[Game.coordToIndex(coord: "000")] == .blue
        XCTAssertTrue(result)
        result = game.dots[Game.coordToIndex(coord: "333")] == .red
        XCTAssertTrue(result)

        result = Game.coordToIndex(coord: "123") == 57
        XCTAssertTrue(result)
    }
    
    func testPresenterViewProtocol(){
        let view_mock = View_mock()
        let presenter = Presenter(view: view_mock)
        presenter.setGameStatusText(status: "kjvsdcf")
        presenter.setNetworkStatusText(status: "kjsdgfbc")
        presenter.setNetworkStatusColor(color: UIColor.black)
        let myDots = Array.init(repeating: Player.free, count: 64)
        presenter.updateDots(dots: myDots)
        
        XCTAssertEqual(view_mock.gameStatusCount, 1)
        XCTAssertEqual(view_mock.networkStatusCount, 1)
        XCTAssertEqual(view_mock.networkColorCount, 1)
        XCTAssertEqual(view_mock.updateDotsCount, 1)
    }
    
    func testPresenterConfigure(){
        let view_mock = View_mock()
        let presenter = Presenter(view: view_mock)
        presenter.configureView()
        XCTAssertEqual(view_mock.gameStatusCount, 1)
        XCTAssertEqual(view_mock.networkStatusCount, 1)
        XCTAssertEqual(view_mock.networkColorCount, 1)
        XCTAssertEqual(view_mock.updateDotsCount, 0)

    }
    
    func testPrimitivesNodesCount(){
        let scene = PrimitivesScene()
        let numberOfNodes = 65
        XCTAssertEqual(scene.rootNode.childNodes.count, numberOfNodes)
    }

    func testPrimitivesNodesNames(){
        let scene = PrimitivesScene()
        for node in scene.rootNode.childNodes {
            XCTAssertNotNil(node.name)
        }

        for node in scene.rootNode.childNodes {
            XCTAssertEqual(node.name?.lengthOfBytes(using: .utf8), 3)
        }
    }

    func testRouter(){
        let wifi = View_mock()
        let router = Router(viewController: wifi)
        router.exitToMenu()
        XCTAssertEqual(wifi.exitToMenuCount, 1)
    }
    
    func testConfigurator(){
        let configurator : ConfiguratorProtocol = Configurator()
        let view = View_mock()
        configurator.configure(with: view)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}


