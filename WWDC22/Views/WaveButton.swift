//
//  WaveButton.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-06-20.
//

import SwiftUI

struct WaveButton: View {
  @State private var tapLocation: CGPoint?
  @State private var isAnimatingTap: Bool = false
  let text: String
  let action: () -> Void
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      HStack {
        Spacer()
        Text(text)
          .bold()
          .foregroundColor(.white)
          .shadow(radius: 2.0, x: 0, y: 3.0)
        Spacer()
      }
      .padding()
      .background(Color.green.gradient)
      .overlay(
        GeometryReader { proxy in
          Wave(radius: isAnimatingTap ? proxy.size.height * 3 : 0.0)
            .fill(Color.black.opacity(0.5))
            .offset(x: -proxy.size.width / 2, y: -proxy.size.height / 2)
            .offset(x: tapLocation?.x ?? 0.0, y: tapLocation?.y ?? 0.0)
        }
      )
      .clipShape(Capsule())
      .onTapGesture { location in
        guard !isAnimatingTap else { return }
        withAnimation { isAnimatingTap = true }
        tapLocation = location
        action()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          isAnimatingTap = false
        }
      }
      .padding()
    }
  }
}

struct Wave: Shape {
  var animatableData: CGFloat {
    get { radius }
    set { radius = newValue }
  }
  var radius: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: rect.center)
    let rect = CGRect(origin:
        .init(x: rect.midX - radius, y: rect.midY - radius),
                      size: CGSize(width: radius * 2, height: radius * 2)
    )
    path.addEllipse(in: rect)
    return path
  }
}

private extension CGRect {
  var center: CGPoint {
    .init(x: midX, y: midY)
  }
}

struct WaveButton_Previews: PreviewProvider {
  static var previews: some View {
    WaveButton(text: "Tap Me") { }
  }
}
