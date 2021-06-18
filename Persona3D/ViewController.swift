//
//  ViewController.swift
//  Persona3D
//
//  Created by William Dion on 2021-06-18.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var slider: UISwitch!
    
    var jokerAnchor: ARImageAnchor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        preserveJoker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Persona Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        DispatchQueue.main.async {
            if let imageAnchor = anchor as? ARImageAnchor {
                self.jokerAnchor = imageAnchor
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
                
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi/2
                
                node.addChildNode(planeNode)
                
                if let personaScene = SCNScene(named: "art.scnassets/joker.scn") {
                    if let personaNode = personaScene.rootNode.childNodes.first {
                        personaNode.eulerAngles.x = .pi
                        personaNode.scale = .init(0.000005, 0.000005,  0.000005)
                        planeNode.addChildNode(personaNode)
                    } else {
                        print("Failed to load joker")
                    }
                }
            }
        }
        return node
    }
}
