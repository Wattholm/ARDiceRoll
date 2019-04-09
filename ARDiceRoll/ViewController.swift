//
//  ViewController.swift
//  ARDiceRoll
//
//  Created by Kevin Joseph Mangulabnan on 09/04/2019.
//  Copyright © 2019 Kevin Joseph Mangulabnan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Node for Dice
        let diceGeo = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.005)
        let diceMat = SCNMaterial()
        diceMat.diffuse.contents = UIColor.blue
        diceGeo.materials = [diceMat]
        let diceNode = SCNNode()
        diceNode.position = SCNVector3(x:0, y:-1, z:-0.5)
        // Give the node a geometry of cube
        diceNode.geometry = diceGeo
        
        // Node for Earth
        let earthGeo = SCNSphere(radius: 0.2)
        let earthMat = SCNMaterial()
        earthMat.diffuse.contents = UIImage(named: "art.scnassets/earth_day_2k.jpg")
        earthGeo.materials = [earthMat]
        let earthNode = SCNNode()
        earthNode.position = SCNVector3(x:1, y:0.1, z:-0.7)
        // Give the node a geometry of cube
        earthNode.geometry = earthGeo

        sceneView.scene.rootNode.addChildNode(diceNode)
        sceneView.scene.rootNode.addChildNode(earthNode)
        
        sceneView.autoenablesDefaultLighting = true
        
        
        //// Code from default AR Project
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Session is supported = \(ARConfiguration.isSupported)")
        print("World Tracking is supported = \(ARWorldTrackingConfiguration.isSupported)")

        if ARWorldTrackingConfiguration.isSupported {
            // Use Configuration Compatible with AR9+ Chips
            let configuration = ARWorldTrackingConfiguration()
            // Run the view's session
            sceneView.session.run(configuration)
        } else {
            // Use Configuration for older models with processors lower than AR9
            let configuration = AROrientationTrackingConfiguration()
            // Run the view's session
            sceneView.session.run(configuration)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }





















    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
