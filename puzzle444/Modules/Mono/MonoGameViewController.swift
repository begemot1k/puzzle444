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
    let labelGameStatus = UILabel()

    let itemText = UIBarButtonItem()
    let itemGameMenu = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(gameMenu))
    let divider = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        scene.backgroundColor = .black
        scene.scene = PrimitivesScene()
        scene.frame = self.view.frame
        scene.allowsCameraControl = true
        scene.autoenablesDefaultLighting = true
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(handleTap(gestureRecognizer:)))
        scene.addGestureRecognizer(tapGesture)
        view.addSubview(scene)
        
        setupToolBar()
    }
    
    /// Настройка тулбаров. да, их два
    func setupToolBar(){
        toolbar.autoresizesSubviews = true
        
        labelGameStatus.text = game.status
        
        toolbar.setItems([itemGameMenu, divider ], animated: true)
        
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
            labelGameStatus.text = game.status
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
    
    func undo(){
        let color = UIColor.gray
        game.undo()
        for node in (scene.scene?.rootNode.childNodes)! {
            if game.dots[game.coordToIndex(coord:  node.name! )] == .free {
                node.geometry?.firstMaterial?.diffuse.contents = color
            }
        }        
        labelGameStatus.text = game.status
    }
    
    @objc func gameMenu(){
        let menu = UIAlertController(title: "Вы желаете", message: "выберите действие", preferredStyle: .actionSheet)
        let actionUndo = UIAlertAction(title: "Отменить последний ход", style: .default, handler: { (UIAlertAction)->Void in
            self.undo()
        } )
        menu.addAction(actionUndo)
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

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
