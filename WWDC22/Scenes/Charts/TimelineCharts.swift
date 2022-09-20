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
  enum Mode: Equatable {
    case month
    case quarter
    case year
  }
  
  @ObservedObject var viewModel: ViewModel
  @State private var mode: Mode = .month
  @Environment(\.horizontalSizeClass) private var hSizeClass
  
  var todosOverTime: [ToDoPerDate] {
    let groupedTodos = viewModel.toDos.groupBy(keyPath: \.finishedOnWithoutTime)
    return groupedTodos.map { (key, elements) in
      ToDoPerDate(todos: elements, date: key ?? Date())
    }.sorted { $0.date < $1.date }
  }
  
  var quarterlyTodosOverTime: [ToDoPerDate] {
    let groupedTodos = viewModel.toDos.groupBy {
      let calendar = Calendar.current
      let date = $0.finishedOn?.dateWithoutTime() ?? Date()
      return calendar.date(byAdding: .month, value: -(date.month() % 3), to: date)
    }
    return groupedTodos.map { (key, elements) in
      ToDoPerDate(todos: elements, date: key ?? Date())
    }.sorted { $0.date < $1.date }
  }
  
  var yearlyTodosOverTime: [ToDoPerDate] {
    let groupedTodos = viewModel.toDos.groupBy {
      $0.finishedOn?.dateByYear()
    }
    return groupedTodos.map { (key, elements) in
      ToDoPerDate(todos: elements, date: key ?? Date())
    }.sorted { $0.date < $1.date }
  }
  
  var body: some View {
    VStack {
      Picker("", selection: $mode.animation()) {
        Text("Month")
          .tag(Mode.month)
        Text("Quarter")
          .tag(Mode.quarter)
        Text("Year")
          .tag(Mode.year)
      }
      .pickerStyle(SegmentedPickerStyle())
      Chart {
        if [.month, .quarter].contains(mode) {
          let todos = mode == .month ? todosOverTime : quarterlyTodosOverTime
          ForEach(todos.indices, id: \.self) { index in
            let todosPerDate = todos[index]
            LineMark(
              x: .value("Date", todosPerDate.date),
              y: .value("Quantity", todosPerDate.todos.count)
            )
            .interpolationMethod(.catmullRom)
            PointMark(
              x: .value("Date", todosPerDate.date),
              y: .value("Quantity", todosPerDate.todos.count)
            )
            .foregroundStyle(Color.orange)
          }
        } else {
          ForEach(yearlyTodosOverTime.indices, id: \.self) { index in
            let todosPerDate = todosOverTime[index]
            BarMark(
              x: .value("Date", todosPerDate.date),
              y: .value("Quantity", todosPerDate.todos.count)
            )
          }
        }
      }
      .chartXAxis {
        switch mode {
        case .month:
          AxisMarks(values: .stride(by: .month)) { _ in
            AxisValueLabel(format: .dateTime.month(
              hSizeClass == .compact ? .narrow : .abbreviated)
            )
          }
        case .quarter:
          AxisMarks(values: .stride(by: .month)) { value in
            if let date = value.as(Date.self),
               date.month() % 3 == 0 /* Beginning of Quarter */{
              AxisGridLine().foregroundStyle(Color.blue)
              AxisTick()
              AxisValueLabel(format: .dateTime.month(.wide))
            } else {
              AxisGridLine()
            }
          }
        case .year:
          AxisMarks(values: .stride(by: .year))
        }
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
