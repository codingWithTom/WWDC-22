//
//  TimelineCharts.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-09-19.
//

import SwiftUI
import Charts

struct ToDoPerDate {
  let todos: [ToDo]
  let date: Date
}

struct TimelineCharts<ViewModel: ToDoListViewModel>: View {
  @ObservedObject var viewModel: ViewModel
  
  var todosOverTime: [ToDoPerDate] {
    let groupedTodos = viewModel.toDos.groupBy(keyPath: \.finishedOnWithoutTime)
    return groupedTodos.map { (key, elements) in
      ToDoPerDate(todos: elements, date: key ?? Date())
    }
  }
  
  var body: some View {
    Chart {
      ForEach(todosOverTime.indices, id: \.self) { index in
        let todosPerDate = todosOverTime[index]
        PointMark(
          x: .value("Date", todosPerDate.date),
          y: .value("Quantity", todosPerDate.todos.count)
        )
      }
    }
    .padding(.horizontal)
  }
}

struct TimelineCharts_Previews: PreviewProvider {
  private class MockToDoListViewModel: ToDoListViewModel {
    lazy var toDos: [ToDo] = {
      return ToDoServiceAdapter.shared.getMockToDos()
    }()
  }
  static var previews: some View {
    TimelineCharts(viewModel: MockToDoListViewModel())
  }
}
