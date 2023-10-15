//
//  ShieldController.swift
//  Dubhacks23
//
//  Created by Sean Lim on 10/14/23.
//

import Foundation
import ManagedSettings

enum ShieldController {
  static func applyShield() {
    ManagedSettingsStore().shield.applicationCategories = .all()
  }

  static func removeShield() {
    ManagedSettingsStore().clearAllSettings()
  }
}
