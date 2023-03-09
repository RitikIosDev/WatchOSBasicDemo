//
//  ViewController.swift
//  WatchOSDemo
//
//  Created by Ritik on 08/12/22.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    let session = WCSession.default

    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session.delegate = self
        session.activate()
    }

    @IBAction func sendButton(_ sender: UIButton) {
        sendMessageToWatch()
    }
}

extension ViewController: WCSessionDelegate{
    
    func sendMessageToWatch() {
        // Send a message to the paired Apple Watch
        
        guard messageTextField.text != nil else {
            return
        }
        
        if let dispatchedMessage = ["message": messageTextField.text as Any] as? [String : Any] {
            
            session.sendMessage(dispatchedMessage, replyHandler: { reply in
                // Handle the reply
                if let response = reply["response"] as? String {
                    let alertController = UIAlertController(title: "Sent", message: "\(response)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    DispatchQueue.main.async { [weak self] in
                        self?.present(alertController, animated: true, completion:  nil)
                    }
                }
            }, errorHandler: { error in
                // Handle the error
                print("Error sending message: \(error)")
            })
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
}




