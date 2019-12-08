//
//  WiFiGameViewController.swift
//  puzzle444
//
//  Created by 01587913 on 24.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import GameKit
import MultipeerConnectivity

class WiFiGameViewController: UIViewController, MCBrowserViewControllerDelegate, MoveProtocol {
    
    var mpcHandler = MPCHandler()
    
    let mainMenuButton = UIButton()
    let resetGameButton = UIButton()
    let scene = SCNView()
    let toolbar = UIToolbar()
    
    let labelGameStatus = UILabel()
    var itemMenu = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(networkMenu))
    
    let itemSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
    let itemNetworkStatus = UIBarButtonItem(title: "Статус соединения", style: .plain, target: self, action: nil)
    let game = Game()
    
    var opponentName: String = ""
    var opponentPeerID: MCPeerID!
    var myFigure: Player = .free
    var myValue: Double = 0.0
    var statusText: String = ""
    var drawSent = false
    
    override func viewWillDisappear(_ animated: Bool) {
        mpcHandler.advertiseSelf(advertise: false)
        mpcHandler.session.disconnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mpcHandler.setupPeer(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
        
        view.backgroundColor = .white
        scene.backgroundColor = .black
        scene.scene = PrimitivesScene()
        scene.frame = self.view.frame
        scene.allowsCameraControl = true
        scene.autoenablesDefaultLighting = true
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(handleTap))
        scene.addGestureRecognizer(tapGesture)
        view.addSubview(scene)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)
        setupToolBar()
        
        game.isGameOver = true
        mpcHandler.delegate = self
    }
    
    /// Настройка HUD
    func setupToolBar(){
        toolbar.autoresizesSubviews = true
        labelGameStatus.textColor = .green
        labelGameStatus.text = "Найдите оппонента для игры"
        toolbar.setItems([itemMenu, itemSpace, itemNetworkStatus ], animated: true)
        view.addSubview(toolbar)
        view.addSubview(labelGameStatus)
        
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        labelGameStatus.translatesAutoresizingMaskIntoConstraints = false
        labelGameStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        labelGameStatus.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        labelGameStatus.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        labelGameStatus.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func initGame(){
        game.reset()
        DispatchQueue.main.async {
            for node in (self.scene.scene?.rootNode.childNodes)! {
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            }
            self.labelGameStatus.text = self.game.status
        }

    }
    
    /// Сбос игры
    func sendDrawRequest(){
        do {
            drawSent = true
        try mpcHandler.session.send("draw".data(using: .utf8, allowLossyConversion: false)!, toPeers: [opponentPeerID], with: .reliable)
        } catch {
            print("ошибка отправки предложения о ничьей")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    /// Обработка нажатия на объекты сцены
    /// - Parameter gestureRecognizer: распознаватель жеста
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer){
        if game.activePlayer == myFigure {
            let p = gestureRecognizer.location(in: scene)
            let hitResults = scene.hitTest(p, options: [:])
            if hitResults.count > 0 {
                let result: SCNHitTestResult = hitResults[0]
                guard let name = result.node.name else { return }
                performMove(coord: name)
                do {
                    try mpcHandler.session.send(name.data(using: .utf8, allowLossyConversion: false)!, toPeers: [opponentPeerID], with: .reliable)
                } catch {
                    print("ошибка отправки хода оппоненту")
                }
            }
        }
    }
    
    func performMove(coord: String){
        var color: UIColor
        print("обработка хода в \(coord)")
        if game.isValidMove(dotName: coord ){
            print("move is valid")
            if game.activePlayer == .blue {
                color = UIColor.blue
            } else {
                color = UIColor.red
            }
            print("current color is \(color)")
            DispatchQueue.main.async {
                for node in (self.scene.scene?.rootNode.childNodes )! {
                    if  node.name == coord {
                        print("найдена ячейка \(String(describing: node.name)). покрасили")
                        node.geometry?.firstMaterial?.diffuse.contents = color
                    }
                }
            }
            print("передали ход в модель игры")
            game.move(dotName: coord)
        }
        DispatchQueue.main.async {
            self.labelGameStatus.text = self.game.status
        }
    }
    
    @objc func networkMenu(){
        let menu = UIAlertController(title: "Вы желаете", message: "выберите действие", preferredStyle: .actionSheet)
        if opponentPeerID == nil {
            let actionConnect = UIAlertAction(title: "Найти оппонента", style: .default, handler: { (UIAlertAction)->Void in
                self.myFigure = .free
                self.myValue = Double.random(in: 0 ..< 1)
                self.findOpponent()
            } )
            menu.addAction(actionConnect)
        } else {
            let actionConnect = UIAlertAction(title: "Найти другого игрока", style: .destructive, handler: { (UIAlertAction)->Void in
                self.mpcHandler.session.disconnect()
                self.opponentPeerID = nil
                self.myFigure = .free
                self.myValue = Double.random(in: 0 ..< 1)
                self.findOpponent()
            } )
            menu.addAction(actionConnect)
        }
        if game.isGameOver && opponentPeerID != nil {
            let actionNew = UIAlertAction(title: "Новая игра", style: .default, handler: { (UIAlertAction)->Void in
                self.startNewGame()
            } )
            menu.addAction(actionNew)
        }
        if !game.isGameOver {
            let actionReset = UIAlertAction(title: "Предложить ничью", style: .default, handler: { (UIAlertAction)->Void in
                self.sendDrawRequest()
            } )
            menu.addAction(actionReset)
        }
        let actionContinue = UIAlertAction(title: "Подолжить игру", style: .cancel, handler: { (UIAlertAction)->Void in
            
        } )
        menu.addAction(actionContinue)
        let actionExit = UIAlertAction(title: "Выход в меню", style: .destructive, handler: { (UIAlertAction)->Void in
            self.closeGame()
        } )
        menu.addAction(actionExit)
        self.present( menu, animated: true, completion: nil)
    }
    
    func startNewGame(){
        guard game.isGameOver else { return }
        game.reset()
        myFigure = .free
        myValue = Double.random(in: 0 ..< 1)
        do {
            if self.opponentPeerID != nil {
                try self.mpcHandler.session.send("newGame".data(using: .utf8, allowLossyConversion: false )!, toPeers: [self.opponentPeerID], with: .reliable)
                newGame()
            } else {
                print("а откуда у нас оппонент???")
            }
        } catch {
            print("error")
        }

    }
    
    func findOpponent(){
        guard mpcHandler.session != nil else { return }
        mpcHandler.setupBrowser()
        mpcHandler.browser.delegate = self
        present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func receiveMove(coord: String) {
        print("пришли данные \(coord)")
        if myFigure == .free {
            print("я вне игры, необходимо определиться кто за кого")
            guard let opponentValue = Double(coord) else {return}
            if self.myValue > opponentValue {
                self.myFigure = .blue
                statusText = "Соединено, мой цвет СИНИЙ"
            }
            else {
                self.myFigure = .red
                statusText = "Соединено, мой цвет КРАСНЫЙ"
            }
            print("всё очень просто. моё значение \(myValue), у соперника \(opponentValue), значит у меня \(myFigure)")
            game.isGameOver = false
            DispatchQueue.main.async {
                self.itemNetworkStatus.title = self.statusText
            }
            return
        }
        performMove(coord: coord)
    }
    
    func opponentFound(name: String, peerID: MCPeerID) {
        print("ВНИМАНИЕ! ПРИСОЕДИНИЛСЯ ИГРОК \(name)")
        opponentName = name
        opponentPeerID = peerID
        DispatchQueue.main.async {
            self.labelGameStatus.text = "Начните новую игру или ждите приглашения"
            self.itemNetworkStatus.title = "Присоединился \(name)"
        }
    }
    
    func newGame(){
        initGame()
        myFigure = .free
        myValue = Double.random(in: 0 ..< 1)
        print("поступило интересное предложение начать новую игру")
        print("загадали наше значение, немного подождем, чтобы оппонент тоже его загадал")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            print("ну вот, отправляем наше значение")
            do {
                if self.opponentPeerID != nil {
                    try self.mpcHandler.session.send("\(self.myValue)".data(using: .utf8, allowLossyConversion: false )!, toPeers: [self.opponentPeerID], with: .reliable)
                } else {
                    print("а откуда у нас оппонент???")
                }
            } catch {
                print("error")
            }
        }

    }
    
    func receiveDrawRequest() {
        DispatchQueue.main.async {
        print("видимо соперник уже проигрывает")
        let alert = UIAlertController.init(title: "Ничья", message: "Оппонент предлагает ничью, согласны?", preferredStyle: .alert)
        let actionDraw = UIAlertAction(title: "Согласен", style: .default) { (UIAlertAction) in
            print("принимаем ничью")
            do {
                try self.mpcHandler.session.send("drawConfirmed".data(using: .utf8, allowLossyConversion: false)!, toPeers: [self.opponentPeerID], with: .reliable)
                DispatchQueue.main.async {
                    self.game.isGameOver = true
                    self.labelGameStatus.text = "Ничья. Начните новую игру"
                    self.itemNetworkStatus.title = "Соединено."
                }
            }catch {
                
            }
        }
        let actionDeny = UIAlertAction(title: "Отвергнуть", style: .destructive) { (UIAlertAction) in
            print("со злорадством отвергаем ничью. враг слаб. добьём его!")
            
        }
        alert.addAction(actionDraw)
        alert.addAction(actionDeny)
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    func drawConfirmed() {
        print("ничья подтверждена")
        if drawSent {
            game.isGameOver = true
            myFigure = .free
            DispatchQueue.main.async {
                self.labelGameStatus.text = "Ничья. Начните новую игру"
                self.itemNetworkStatus.title = "Соединено."
            }
        }
    }
    
    func connectionReset() {
        print("Оппонент покинул игру")
        opponentPeerID = nil
        opponentName = ""
        DispatchQueue.main.async {
            self.labelGameStatus.text = "Начните игру или ожидайте приглашения"
            self.itemNetworkStatus.title = "Соединение разорвано"
            self.myFigure = .free
            self.myValue = 0.0
            self.stopGame()
        }
    }
    
    func stopGame(){
        game.isGameOver = true
        myFigure = .free
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func closeGame(){
        if game.isGameOver {
            self.navigationController?.popViewController(animated: true)
        } else {
        let alert = UIAlertController(title: "Подтверждение", message: "Выйти из сетевой игры?", preferredStyle: .alert)
        let actionExit = UIAlertAction(title: "Выйти", style: .destructive, handler: { (UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        let actionCancel = UIAlertAction(title: "Раздумал", style: .cancel, handler: nil)
        
        alert.addAction(actionExit)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
        }
    }
    
}

