//
//  StartView.swift
//  Dubhacks23
//
//  Created by Sean Lim on 10/14/23.
//

import SwiftUI

enum ViewStep {
  case start
  case box
  case prep
  case map
}

class FlowController : ObservableObject {
  @Published var currentStep: ViewStep = .start
}


struct FlowView: View {
  @EnvironmentObject var flowController: FlowController
  var body: some View {
    NavigationStack {
      ZStack {
        Color(red: 246, green: 246, blue: 246)
          .ignoresSafeArea()
        switch flowController.currentStep {
        case .start:
          StartView()
        case .box:
          //MapView()
          BoxView()
        case .prep:
          PrepView()
        case .map:
          MapView()
        }
      }

    }
    .ignoresSafeArea(.keyboard)
    .foregroundColor(.black)
    .statusBar(hidden: true)
  }
}

struct StartView: View {
  @EnvironmentObject var flowController: FlowController
  var body: some View {
    VStack {
      Image("boxLid")
        .blur(radius: 25)
        .overlay {
          VStack {
            Text("Umwelt")
              .font(.custom("Gayathri-Bold", size: 48))

            UmweltButton(label: "start", size: CGSize(width: 198, height: 46)) {
              withAnimation(.easeInOut(duration: 0.5)) {
                flowController.currentStep = .box
              }
            }
          }
        }

    }
  }

}



struct BoxView: View {
  @State private var appeared = false
  @State private var boxIsOpen = false
  @State private var paperIsShown = false
  @State private var worriesDone = false
  @State private var worriesDone2 = false
  @State private var text = ""
  @EnvironmentObject var flowController: FlowController
  var body: some View {
    VStack(alignment: .center) {
      ZStack {
        ZStack { // closed box
          Image("boxBase")
          HStack(alignment: .center, spacing: 0) {
            Image("boxLidLeft")
            Image("boxLidRight")
          }
        }
        .opacity(boxIsOpen && !worriesDone2 ? 0 : 1)
        ZStack { // open box
          Text("Before we embark on this adventure, cast away your worries...")
            .frame(width: 300)
            .offset(y: -170)
            .opacity(worriesDone ? 0 : 1)
          Image("box_open")
          HStack {
            SquareButton(
              label: "Write your worries into the box",
              size: CGSize(width: 143, height: 101),
              imageName: "note_line" ) {
                paperIsShown = true
              }
          }
          .offset(y: 230)
          .opacity(worriesDone ? 0 : 1)
        }
        .opacity(boxIsOpen && !worriesDone2 ? 1 : 0)
        Image("notes")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: worriesDone2 ? 0 : 100)
          .offset(y: worriesDone ? 0 : 1000)
          .onTapGesture {
            withAnimation() {
              worriesDone2 = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Wait for 2 seconds
              flowController.currentStep = .prep
            }
          }
      }
      .blur(radius: appeared ? 0 : 25)

      .onTapGesture {
        withAnimation(.easeInOut(duration: 1)) {
          boxIsOpen = true
        }
      }
    }
    .transition(.asymmetric(insertion: .identity, removal: .slide))

    .onAppear {
      withAnimation {
        appeared = true
      }
      
    }
    .fullScreenCover(isPresented: $paperIsShown) {
      PaperView(worriesDone: $worriesDone)
    }
  }
}

struct PaperView : View {
  @FocusState var worryFieldFocused: Bool
  @Binding var worriesDone: Bool
  @State private var text = ""
  @Environment(\.dismiss) var dismiss
  var body: some View {
    NavigationStack {
      GeometryReader { _ in
        VStack(spacing: 3) {
          TextField("", text: $text, axis: .vertical)
            .font(.custom("Poppins-Regular", size: 24))
            .lineLimit(15, reservesSpace: true)
            .focused($worryFieldFocused)
            .background(.clear)
            .padding(.horizontal, 25)

        }
        .padding(.horizontal, 15)
        .background(
          Image("notes")
            .resizable()
            .ignoresSafeArea(.all)
        )
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 10, height: 21)
              Text("Cancel")
                .font(.custom("Poppins-Regular", size: 20))
            }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button {
              withAnimation(.spring().speed(0.25)) {
                worriesDone = true
              }
              dismiss()
            } label : {
              Text("Done")
                .font(.custom("Poppins-Bold", size: 20))
            }

          }
        }
        .foregroundColor(.black)
        .onAppear {
          worryFieldFocused = true
        }
      }
      .ignoresSafeArea(.keyboard)
    }
  }
}

enum Step: Int {
  case zero
  case one
  case two
  case three
}

struct PrepView: View {
  @EnvironmentObject var flowController: FlowController
  @StateObject var authController = FamilyAuthController()
  @State var step: Step = .zero
  var body: some View {
    VStack(alignment: .center, spacing: 50) {
      Text("You will be venturing out into the unknown, leaving behind things that may be familiar to you...")
        .font(.custom("Poppins-Regular", size: 16))
        .opacity(step.rawValue >= 1 ? 1 : 0)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { // Wait for 2 seconds
            withAnimation {
              step = .two
            }
          }
        }
      Text("Choose a few items to take with you on this adventure, should an emergency arise.")
        .font(.custom("Poppins-Regular", size: 16))
        .opacity(step.rawValue >= 2 ? 1 : 0)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 4) { // Wait for 2 seconds
            withAnimation {
              step = .three
            }
          }
        }
      RoundedRectangle(cornerRadius: 8)
        .stroke(.black, lineWidth: 1)
        .overlay {
          Text("While in your journey, your apps will be locked. Select the apps that you need to keep in your phone’s Settings.")
            .font(.custom("Poppins-Regular", size: 12))
        }
        .opacity(step.rawValue >= 3 ? 1 : 0)
        .frame(height: 100)
      AsyncUmweltButton(label: "next", size: CGSize(width: 128, height: 36)) {
        await authController.getAuthorization()
        ShieldController.applyShield()
        flowController.currentStep = .map
      }
      .opacity(step.rawValue >= 3 ? 1 : 0)

    }
    .multilineTextAlignment(.center)
    .padding(.horizontal, 30)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Wait for 2 seconds
        withAnimation {
          step = .one
        }
      }
    }
  }
}


// MARK: - Previews

struct StartView_Previews: PreviewProvider {
  static var previews: some View {
    PrepView()
  }
}
