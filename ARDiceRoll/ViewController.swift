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
    
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show feature points as the plane detection is being processed
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
//        // Node for Dice
//        let diceGeo = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.005)
//        let diceMat = SCNMaterial()
//        diceMat.diffuse.contents = UIColor.blue
//        diceGeo.materials = [diceMat]
//        let diceNode = SCNNode()
//        diceNode.position = SCNVector3(x:0, y:-1, z:-0.5)
//        // Give the node a geometry of cube
//        diceNode.geometry = diceGeo
//
//        // Node for Earth
//        let earthGeo = SCNSphere(radius: 0.2)
//        let earthMat = SCNMaterial()
//        earthMat.diffuse.contents = UIImage(named: "art.scnassets/earth_day_2k.jpg")
//        earthGeo.materials = [earthMat]
//        let earthNode = SCNNode()
//        earthNode.position = SCNVector3(x:1, y:0.1, z:-0.7)
//        // Give the node a geometry of cube
//        earthNode.geometry = earthGeo
//
//        sceneView.scene.rootNode.addChildNode(diceNode)
//        sceneView.scene.rootNode.addChildNode(earthNode)
        
        sceneView.autoenablesDefaultLighting = true
        
        
        //// Code from default AR Project
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        // Create a new scene: diceScene
        
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//        let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true)
//        diceNode?.position = SCNVector3(x: 0, y: 0, z: -0.2)
//        sceneView.scene.rootNode.addChildNode(diceNode!)
        
        // Set the scene to the view
        // sceneView.scene = diceScene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("Session is supported = \(ARConfiguration.isSupported)")
        print("World Tracking is supported = \(ARWorldTrackingConfiguration.isSupported)")

        if ARWorldTrackingConfiguration.isSupported {
            // Use Configuration Compatible with AR9+ Chips
            let configuration = ARWorldTrackingConfiguration()
            
            configuration.planeDetection = .horizontal
            
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
//            if !results.isEmpty {
//                print("Touched the plane.")
//            } else {
//                print("Touched outside the plane.")
//            }
            
            if let hitResult = results.first {
                // print(hitResult)

                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true)
                diceNode?.position = SCNVector3(
                    x: hitResult.worldTransform.columns.3.x,
                    // Add half of the height of the dice so they appear exactly on planar surface
                    y: hitResult.worldTransform.columns.3.y + (diceNode?.boundingSphere.radius)!,
                    z: hitResult.worldTransform.columns.3.z
                )
                
                // Add the new Die to the array of Dice Nodes
                diceArray.append(diceNode!)
                
                sceneView.scene.rootNode.addChildNode(diceNode!)
                
                roll(dice: diceNode!)
 
            }
            
        }
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        // Dice face shows 2 as default
        
        let random6 = Float(arc4random_uniform(6) + 1)
        var randomX: Float
        var randomZ: Float
        
        print(random6)
        
        switch random6 {
            
        case 1:
            randomX = Float.pi/2
            randomZ = 0
        case 2:
            randomX = 0
            randomZ = 0
        case 3:
            randomX = 0
            randomZ = Float.pi/2
        case 4:
            randomX = Float.pi
            randomZ = 0
        case 5:
            randomX = 0
            randomZ = -(Float.pi/2)
        case 6:
            randomX = Float.pi * (3/2)
            randomZ = 0
        default:
            fatalError("This should never occur. Random Roll should be from 1 to 6.")
        }
        
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(6 * Float.pi + randomX),
            y: CGFloat(6 * Float.pi),
            z: CGFloat(6 * Float.pi + randomZ),
            duration: 0.5)
        )
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
            print("Plane detected.")
            let planeAnchor = anchor as! ARPlaneAnchor
            let planeGeo = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            // Rotation is counterclockwise and 180 degrees is Pi radians
            planeNode.transform = SCNMatrix4MakeRotation( -Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            planeGeo.materials = [gridMaterial]
            planeNode.geometry = planeGeo
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
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
