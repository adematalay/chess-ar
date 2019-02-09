//
//  ChessViewController.swift
//  ChessAR
//
//  Created by Adem Atalay on 2.02.2019.
//  Copyright © 2019 MAKU Teknoloji. All rights reserved.
//

import SceneKit
import ChessEngine.Swift
import ARKit

class ChessViewController: BaseViewController {
    private let sceneView: BoardSceneView
    
    init(router: AppRouter, engine: ChessEngine?, audio: AudioServiceProtocol?) {
        self.sceneView = BoardSceneView(engine: engine, audio: audio)
        super.init(router: router)
        self.view.addSubview(self.sceneView)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        //sceneView.placeBoard(at: SCNVector3(0, -0.5, -0.4))
        //sceneView.fen = "8/5prk/p5rb/P3N2R/1p1PQ2p/7P/1P3RPq/5K2 w - - 1 0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupLayout() {
        self.sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func configureSession() {
        let configuration = ARWorldTrackingConfiguration()
        
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: ARModels.ChessReferenceObjectGroup.rawValue, bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: ARModels.ChessReferenceObjectGroup.rawValue, bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        configuration.detectionObjects = referenceObjects
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension ChessViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        sceneView.placeBoard(on: node)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
