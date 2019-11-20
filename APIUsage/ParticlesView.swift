//
//  ParticlesView.swift
//  APIUsage
//
//  Created by wtildestar on 21/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import SpriteKit

class ParticlesView: SKView {
    override func didMoveToSuperview() {
        // указали что размер сцены равен размеру нашего view
        let scene = SKScene(size: self.frame.size)
        // делаем сцену прозрачной
        scene.backgroundColor = UIColor.clear
        self.presentScene(scene)
        // разрешаем прозрачный фон
        self.allowsTransparency = true
        self.backgroundColor = UIColor.clear
        if let particles = SKEmitterNode(fileNamed: "ParticleScene.sks") {
            // указываем позицию
            particles.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
            // указываем пределы
            particles.particlePositionRange = CGVector(dx: self.bounds.size.width, dy: 0)
            scene.addChild(particles)
        }
        
        
    }
}
