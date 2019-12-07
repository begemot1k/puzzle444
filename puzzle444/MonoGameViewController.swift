//
//  MonoGameViewController.swift
//  puzzle444
//
//  Created by 01587913 on 24.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import GameKit

class MonoGameViewController: UIViewController {
    
    let mainMenuButton = UIButton()
    let resetGameButton = UIButton()
    let scene = SCNView()
    let toolbar = UIToolbar()
    let statusToolbar = UIToolbar()
    
    let itemText = UIBarButtonItem()
    let itemHotSpot = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
    let itemReset = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
    let divider = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
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
    
    /// Настройка тулбаров. да, их два
    func setupToolBar(){
        toolbar.autoresizesSubviews = true
        
        itemText.tag = 0
        itemText.title = game.status
        itemText.setTitleTextAttributes(nil, for: .normal)
        itemText.action = #selector(placeButtons(sender:))
        itemHotSpot.tag = 1
        itemHotSpot.action = #selector(placeButtons(sender:))
        itemReset.tag = 2
        itemReset.action = #selector(placeButtons(sender:))
        
        toolbar.setItems([itemHotSpot, itemReset, divider ], animated: true)
        statusToolbar.setItems([itemText ], animated: true)
        view.addSubview(toolbar)
        view.addSubview(statusToolbar)
        
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        statusToolbar.translatesAutoresizingMaskIntoConstraints = false
        statusToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusToolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        statusToolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }
    
    /// Сбос игры
    func resetGame(){
        game.reset()
        for node in (scene.scene?.rootNode.childNodes)! {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        }
        itemText.title = game.status
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
            itemText.title = game.status
        }
    }
    
    /// Обработка нажатий на кнопки тулбаров
    /// - Parameter sender: нажатая кнопка
    @objc func placeButtons(sender: UIBarButtonItem){
        print("test event fired with \(sender)")
        // TODO: добавить запрос на выполнение действия
        if sender.tag == 1 {
            navigationController?.popViewController(animated: true)
        }
        if sender.tag == 2 {
            resetGame()
        }
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
