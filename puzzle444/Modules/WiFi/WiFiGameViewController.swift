//
//  WiFiGameViewController.swift
//  puzzle444
//
//  Created by 01587913 on 24.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import SceneKit

protocol ViewProtocol: class {
    func setGameStatusText(status: String)
    func setNetworkStatusText(status: String)
    func updateDots(dots: Array<Player>)
    func exitToMenu()
}

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
    

    override func viewWillDisappear(_ animated: Bool) {
        presenter.disconnect()
    }
    
    func exitToMenu(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = .white
        scene.backgroundColor = .black
        scene.scene = PrimitivesScene()
        scene.frame = self.view.frame
        scene.allowsCameraControl = true
        scene.autoenablesDefaultLighting = true
        let tapGesture = UITapGestureRecognizer( target: self, action: #selector(handleTap))
        scene.addGestureRecognizer(tapGesture)
        view.addSubview(scene)
        
        setupHUD()
        configurator.configure(with: self)
        presenter.configureView()

    }
    
    /// Настройка HUD
    func setupHUD(){
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setToolbarHidden(true, animated: true)

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
    
    func updateDots(dots: Array<Player>) {
        DispatchQueue.main.async {
            for node in (self.scene.scene?.rootNode.childNodes)! {
                let dot = dots[ Game.coordToIndex(coord: node.name!) ]
                let color = dot == .blue ? UIColor.blue : dot == .red ? UIColor.red : UIColor.gray
                node.geometry?.firstMaterial?.diffuse.contents = color
            }
        }
    }
    
    func setGameStatusText(status: String){
        DispatchQueue.main.async {
            self.labelGameStatus.text = status
        }
    }
    
    func setNetworkStatusText(status: String){
        DispatchQueue.main.async {
            self.itemNetworkStatus.title = status
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    /// Обработка нажатия на объекты сцены
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
    
    @objc func networkMenuClicked(){
        presenter.networkMenuClicked()
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

