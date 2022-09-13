//
//  ContentView.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-06-20.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      WelcomeView()
        .tabItem {Label("Welcome", systemImage: "person.crop.circle.fill.badge.checkmark") }
      ToDoList(viewModel: ToDoListViewModelAdapter())
        .tabItem {Label("ToDo's", systemImage: "rectangle.and.pencil.and.ellipsis") }
      ChartsView(viewModel: ToDoListViewModelAdapter())
        .tabItem {Label("Charts", systemImage: "chart.bar.xaxis") }
    }
  }
}

private struct WelcomeView: View {
  @State private var isTitleLarge: Bool = false
  
  var body: some View {
    VStack {
      Text("Weclome to WWDC 2022!")
        .font(isTitleLarge ? .largeTitle : .title2)
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(isTitleLarge ? Color.orange.gradient : Color.cyan.gradient)
        )
        .foregroundStyle( isTitleLarge ?
                      Color.white.shadow(.drop(radius: 2, x: 2.0, y: 2.0)) :
                            Color.black.shadow(.drop(color: .white, radius: 2, x: 2.0, y: 2.0))
        )
      Spacer()
      WaveButton(text: "Change Title") {
        withAnimation { isTitleLarge.toggle() }
        
      }
      Spacer()
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
