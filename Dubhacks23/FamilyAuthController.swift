//
//  FamilyAuthController.swift
//  Dubhacks23
//
//  Created by Sean Lim on 10/14/23.
//

import Foundation
import FamilyControls

class FamilyAuthController: ObservableObject {
  let center = AuthorizationCenter.shared
  @Published var authorized = false
  var onboarded: Bool = false

  func getAuthorization() async {
    do {
      try await center.requestAuthorization(for: .individual)
      DispatchQueue.main.async {
        self.authorized = true
      }
    } catch {
      print("Failed to enroll user with error: \(error)")
    }
  }

}
