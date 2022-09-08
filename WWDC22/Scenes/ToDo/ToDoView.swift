//
//  ToDoView.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-08-23.
//

import SwiftUI

struct ToDoView: View {
  let toDo: ToDo
  
  var body: some View {
    HStack {
      if toDo.isDone {
        Image(systemName: "checkmark.seal.fill")
          .foregroundColor(.orange)
      }
      Text(toDo.title)
        .font(.title2)
      Spacer()
      toDo.project.view
      toDo.priority.view
    }
    .padding()
  }
}

fileprivate extension ToDo.Priority {
  @ViewBuilder
  var view: some View {
    switch self {
    case .low:
      Image(systemName: "tortoise.fill")
        .foregroundColor(.green)
    case .medium:
      Image(systemName: "scribble.variable")
        .foregroundColor(.yellow)
    case .high:
      Image(systemName: "hare.fill")
        .foregroundColor(.red)
    }
  }
}

fileprivate extension ToDo.Project {
  var view: some View {
    switch self {
    case .growth:
      return Image(systemName: "brain.head.profile")
    case .personal:
      return Image(systemName: "person.2.wave.2.fill")
    case .wishList:
      return Image(systemName: "lasso.and.sparkles")
    case .work:
      return Image(systemName: "pencil.slash")
    }
  }
}

struct ToDoView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .low, project: .work, finishedOn: Date()))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .high, project: .work))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .low, project: .personal))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .medium, project: .personal))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .high, project: .personal))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .low, project: .growth))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .medium, project: .growth))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .medium, project: .wishList))
      ToDoView(toDo: .init(title: "Some ToDo task", priority: .high, project: .wishList))
    }
  }
}
