//
//  Dubhacks23App.swift
//  Dubhacks23
//
//  Created by Sean Lim on 10/14/23.
//

import SwiftUI
@main
struct Dubhacks23App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var flowController = FlowController()
    var body: some Scene {
        WindowGroup {
          NavigationStack {
            FlowView()
            .environmentObject(flowController)
            .onAppear {
              ShieldController.removeShield()
            }
          }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
      ShieldController.removeShield()
    }
}
