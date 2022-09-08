//
//  ToDoList.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-08-23.
//

import SwiftUI

struct ToDoList<ViewModel: ToDoListViewModel>: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    List {
      ForEach(viewModel.toDos, id: \.id) {
        ToDoView(toDo: $0)
      }
    }
  }
}

struct ToDoList_Previews: PreviewProvider {
  private class MockToDoListViewModel: ToDoListViewModel {
    var toDos: [ToDo] { [
      .init(title: "Some ToDo task", priority: .low, project: .work),
      .init(title: "Some ToDo task", priority: .high, project: .work),
      .init(title: "Some ToDo task", priority: .low, project: .personal),
      .init(title: "Some ToDo task", priority: .medium, project: .personal),
      .init(title: "Some ToDo task", priority: .high, project: .personal),
      .init(title: "Some ToDo task", priority: .low, project: .growth),
      .init(title: "Some ToDo task", priority: .medium, project: .growth),
      .init(title: "Some ToDo task", priority: .medium, project: .wishList),
      .init(title: "Some ToDo task", priority: .high, project: .wishList)
    ]}
  }
  static var previews: some View {
    ToDoList(viewModel: MockToDoListViewModel())
  }
}
