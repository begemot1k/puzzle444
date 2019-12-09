//
//  PrimitivesScene.swift
//  puzzle444
//
//  Created by 01587913 on 24.11.2019.
//  Copyright © 2019 vadim khamnuev. All rights reserved.
//

import UIKit
import SceneKit

class PrimitivesScene: SCNScene {
    var cameraNode: SCNNode?
    
    override init() {
        super.init()
        cameraNode?.position = SCNVector3(x: 0, y: 2, z: -2)
        for x in 0...3 {
            for y in 0...3 {
                for z in 0...3 {
                    let sphereGeometry = SCNSphere(radius: 0.2)
                    sphereGeometry.firstMaterial?.diffuse.contents = UIColor.gray
                    let sphereNode = SCNNode(geometry: sphereGeometry)
                    sphereNode.name = "\(x)\(y)\(z)"
                    sphereNode.position = SCNVector3(x: Float(x) * 2.0, y: Float(y) * 2.0, z: Float(z) * 2.0)
                    self.rootNode.addChildNode(sphereNode)
                }
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
