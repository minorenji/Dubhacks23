//
//  UmweltButtonStyle.swift
//  Dubhacks23
//
//  Created by Sean Lim on 10/14/23.
//

import Foundation
import SwiftUI

struct UmweltButton: View {
  let action: () -> Void
  let label: String
  let size: CGSize

  init(
    label: String,
    size: CGSize,
    action: @escaping () -> Void
  ) {
    self.label = label
    self.size = size
    self.action = action
  }

  var body: some View {
    RoundedRectangle(cornerRadius: 90)
      .stroke(Color.black, lineWidth: 1) // Add a black border with a width of 2
      .frame(width: size.width, height: size.height)
      .overlay {
        Text(label)
          .font(.custom("Poppins-Regular", size: 16))
      }
      .onTapGesture {
        action()
      }
  }
}

struct AsyncUmweltButton: View {
  var action: () async -> Void
  var label: String
  var size: CGSize
  @State private var asyncTaskActive = false

  init(
    disabled: Bool = false,
    label: String,
    size: CGSize,
    action: @escaping () async -> Void
  ) {
    self.action = action
    self.label = label
    self.size = size
  }

  var body: some View {
    UmweltButton(label: label, size: size) {
        asyncTaskActive = true
        Task {
          await action()
          asyncTaskActive = false
        }
      }
    .opacity(asyncTaskActive ? 0.4 : 1)
  }

}

struct SquareButton: View {
  let action: () -> Void
  let imageName: String
  let size: CGSize
  let label: String

  init(
    label: String,
    size: CGSize,
    imageName: String,
    action: @escaping () -> Void
  ) {
    self.label = label
    self.size = size
    self.imageName = imageName
    self.action = action
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 15)
        .stroke(Color.black, lineWidth: 1) // Add a black border with a width of 2
        .frame(width: size.width, height: size.height)
        .overlay {
          VStack(spacing: 5) {
            Image(imageName)
              .frame(width: 40)
            Text(label)
              .font(.custom("Poppins-Regular", size: 12))
              .padding(.horizontal, 5)
              .multilineTextAlignment(.center)
          }
        }
        .onTapGesture {
          action()
        }
    }
  }
}
