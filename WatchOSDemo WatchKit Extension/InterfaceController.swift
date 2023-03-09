//
//  InterfaceController.swift
//  WatchOSDemo WatchKit Extension
//
//  Created by Ritik on 08/12/22.
//

import WatchKit
import Foundation
import UserNotifications
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    let session = WCSession.default
    
    @IBOutlet weak var messageLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        session.delegate = self
        session.activate()
    }
    
    override func willActivate() {
        super.willActivate()
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        // This method is called when watch view controller is no longer visible
    }

}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        // Handle the incoming message
        if let receivedMessage = message["message"] as? String {
            WKInterfaceDevice.current().play(.notification)
            self.messageLabel.setText(String(describing: receivedMessage))
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Message received"
        content.body = "You have received a message."

        let request = UNNotificationRequest(identifier: "message", content: content, trigger: nil)

        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if error != nil {
                // Handle the error
                print(error)
            }
        }
        
        // Send a reply
        let reply = ["response": "Message received by Watch"]
        replyHandler(reply)
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith \(activationState)")
    }
    
}

