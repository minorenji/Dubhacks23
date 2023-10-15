//
//  LongText.swift
//  Dubhacks23
//
//  Created by Sean Lim on 10/14/23.
//

import Foundation
import SwiftUI

struct PaperText: View {
  @Binding var offset: CGFloat




  var text: String

  private func determineTruncation(_ geometry: GeometryProxy) {
    // Calculate the bounding box we'd need to render the
    // text given the width from the GeometryReader.
    let total = self.text.boundingRect(
      with: CGSize(
        width: geometry.size.width,
        height: .greatestFiniteMagnitude
      ),
      options: .usesLineFragmentOrigin,
      attributes: [.font: UIFont.systemFont(ofSize: 16)],
      context: nil
    )

  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(self.text)
        .font(.system(size: 24))
      // see https://swiftui-lab.com/geometryreader-to-the-rescue/,
      // and https://swiftui-lab.com/communicating-with-the-view-tree-part-1/
        .background(GeometryReader { geometry in
          Color.clear.onAppear {
            self.determineTruncation(geometry)
          }
        })
    }
  }



}
