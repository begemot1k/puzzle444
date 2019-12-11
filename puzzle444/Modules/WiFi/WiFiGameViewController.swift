//
//  WiFiGameViewController.swift
//  puzzle444
//
//  Created by 01587913 on 24.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import SceneKit

class WiFiGameViewController: UIViewController, ViewProtocol {
    
    var presenter: PresenterProtocol!
    var configurator: ConfiguratorProtocol = Configurator()
    
    let mainMenuButton = UIButton()
    let resetGameButton = UIButton()
    let scene = SCNView()
    let toolbar = UIToolbar()
    
    let labelGameStatus = UILabel()
    var itemMenu = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(networkMenuClicked))
    
    let itemSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
    let itemNetworkStatus = UIBarButtonItem(title: "Статус соединения", style: .plain, target: self, action: nil)
    let itemFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupHUD()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    // MARK: Настройка представления
    
    /// Настройка HUD
    func setupHUD(){
        view.backgroundColor = .black
        scene.backgroundColor = .black
        scene.scene = PrimitivesScene()
        scene.frame = view.frame
        scene.allowsCameraControl = true
        scene.autoenablesDefaultLighting = true
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(handleTap))
        scene.addGestureRecognizer(tapGesture)
        view.addSubview(scene)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)
        
        toolbar.autoresizesSubviews = true
        labelGameStatus.textColor = .green
        toolbar.setItems([itemMenu, itemSpace, itemNetworkStatus, itemFlexibleSpace], animated: true)
        view.addSubview(toolbar)
        view.addSubview(labelGameStatus)
        
        scene.translatesAutoresizingMaskIntoConstraints = false
        scene.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scene.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scene.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scene.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        labelGameStatus.translatesAutoresizingMaskIntoConstraints = false
        labelGameStatus.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        labelGameStatus.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        labelGameStatus.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        labelGameStatus.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    // MARK: методы протокола ViewProtocol
    
    /// Красит точки в цвета в соответствии с моделью
    /// - Parameter dots: массив точек модели
    func updateDots(dots: Array<Player>) {
        DispatchQueue.main.async {
            for node in (self.scene.scene?.rootNode.childNodes)! {
                let dot = dots[ Game.coordToIndex(coord: node.name!) ]
                let color = dot == .blue ? UIColor.blue : dot == .red ? UIColor.red : UIColor.gray
                node.geometry?.firstMaterial?.diffuse.contents = color
            }
        }
    }
    
    /// Устанавливает статус состояния игы в лейбле
    /// - Parameter status: текст для отображения
    func setGameStatusText(status: String){
        DispatchQueue.main.async {
            self.labelGameStatus.text = status
        }
    }
    
    /// Устанавливает статус состояния сети в тулбаре
    /// - Parameter status: текст для отображения
    func setNetworkStatusText(status: String){
        DispatchQueue.main.async {
            self.itemNetworkStatus.title = status
        }
    }
    
    /// Устанавливает цвет для строки статуса  сети в тулбаре
    /// - Parameter color: цвет строки
    func setNetworkStatusColor(color: UIColor){
        DispatchQueue.main.async {
            self.itemNetworkStatus.tintColor = color
        }
    }
    
    // MARK: Обработка элементов управления
    
    /// Обработка нажатия кнопки меню в тулбаре, вызов меню для поиска оппонента, старта игры, ничьей и выхода
    @objc func networkMenuClicked(){
        presenter.networkMenuClicked()
    }
    
    /// Обработка нажатия на объекты сцены. Если пользователь нажал на точку, передаем её имя презентеру
    /// - Parameter gestureRecognizer: распознаватель жеста
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer){
        let p = gestureRecognizer.location(in: scene)
        let hitResults = scene.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result: SCNHitTestResult = hitResults[0]
            guard let name = result.node.name else { return }
            presenter.dotClicked(dotName: name)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.disconnect()
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

