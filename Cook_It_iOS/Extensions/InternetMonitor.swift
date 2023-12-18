//
//  InternetMonitor.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 17/12/23.
//

import Foundation
import Network

class InternetMonitor {
    var internetStatus = false
    var internetType = ""
    
    static let shared = InternetMonitor()
    private init(){
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.internetStatus = true
                if path.usesInterfaceType(.wifi) {
                    self.internetType = "WiFi"
                }
                else {
                    self.internetType = "no WiFi"
                }
            }
            else {
                self.internetStatus = false
            }
        }
    }
}

