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
    
    
    var appDelegate: AppDelegate!
    
    let mainMenuButton = UIButton()
    let resetGameButton = UIButton()
    let scene = SCNView()
    let toolbar = UIToolbar()
    
    let labelGameStatus = UILabel()
    var itemMenu = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(networkMenu))
    let itemSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
    let itemNetworkStatus = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    let game = Game()
    
    var opponentName: String = ""
    var opponentPeerID: MCPeerID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate.mpcHandler.setupPeer(displayName: UIDevice.current.name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(advertise: true)
        
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
    }
    
    /// Настройка HUD
    func setupToolBar(){
        toolbar.autoresizesSubviews = true
        
        labelGameStatus.text = game.status
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
    
    /// Сбос игры
    func resetGame(){
        game.reset()
        for node in (scene.scene?.rootNode.childNodes)! {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        }
        labelGameStatus.text = game.status
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    /// Обработка нажатия на объекты сцены
    /// - Parameter gestureRecognizer: распознаватель жеста
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer){
        var color: UIColor
        let p = gestureRecognizer.location(in: scene)
        let hitResults = scene.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result: SCNHitTestResult = hitResults[0]
            guard let name = result.node.name else { return }
            if game.isValidMove(dotName: name ){
                if game.activePlayer == .blue {
                    color = UIColor.blue
                } else {
                    color = UIColor.red
                }
                result.node.geometry?.firstMaterial?.diffuse.contents = color
                game.move(dotName: name )
            }
            labelGameStatus.text = game.status
        }
    }
    
    @objc func networkMenu(){
        let menu = UIAlertController(title: "Вы желаете", message: "выберите действие", preferredStyle: .actionSheet)
        if opponentPeerID == nil {
            let actionConnect = UIAlertAction(title: "Найти оппонента", style: .default, handler: { (UIAlertAction)->Void in
                self.findOpponent()
            } )
            menu.addAction(actionConnect)
        }
        let actionReset = UIAlertAction(title: "Сбросить игру", style: .default, handler: { (UIAlertAction)->Void in
            self.resetGame()
        } )
        menu.addAction(actionReset)
        let actionContinue = UIAlertAction(title: "Подолжить игру", style: .cancel, handler: { (UIAlertAction)->Void in
            
        } )
        menu.addAction(actionContinue)
        let actionExit = UIAlertAction(title: "Выход в меню", style: .destructive, handler: { (UIAlertAction)->Void in
            self.navigationController?.popViewController(animated: true)
        } )
        menu.addAction(actionExit)
        
        self.present( menu, animated: true, completion: nil)
        
    }
    
    func findOpponent(){
        guard appDelegate.mpcHandler.session != nil else { return }
        appDelegate.mpcHandler.setupBrowser()
        appDelegate.mpcHandler.browser.delegate = self
        present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func receiveMove(coord: String) {
        print("received move \(coord)")
    }
    
    func opponentFound(name: String, peer: MCPeerID) {
        opponentName = name
        opponentPeerID = peer
    }
    
    func receiveDrawRequest() {
        print("видимо соперник уже проигрывает")
    }
    
    func connectionReset() {
        print("какая печаль")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

