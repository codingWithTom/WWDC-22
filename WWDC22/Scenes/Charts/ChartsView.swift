//
//  ChartsView.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-08-24.
//

import SwiftUI
import Charts

struct ToDoGroup: Identifiable {
  let project: ToDo.Project
  let quantity: Int

  var id: String { project.rawValue }
}

struct ChartsView<ViewModel: ToDoListViewModel>: View {
  @ObservedObject var viewModel: ViewModel
  private var completedToDos: [ToDo] {
    viewModel.toDos.filter { $0.isDone }
  }
  private var incompleteToDos: [ToDo] {
    viewModel.toDos.filter { !$0.isDone }
  }
  private var groups: [ToDoGroup] {
    ToDo.Project.allCases.map { project in
      ToDoGroup(project: project,
                quantity: viewModel.toDos.filter { $0.project == project }.count)
    }
  }
  private var incompleteGroups: [ToDoGroup] {
    ToDo.Project.allCases.map { project in
      ToDoGroup(project: project,
                quantity: incompleteToDos.filter { $0.project == project }.count)
    }
  }
  private var completedGroups: [ToDoGroup] {
    ToDo.Project.allCases.map { project in
      ToDoGroup(project: project,
                quantity: completedToDos.filter { $0.project == project }.count)
    }
  }
  
  
  var body: some View {
    VStack {
      Chart {
        ForEach(groups) { group in
          BarMark(
            x: .value("Project", group.project.rawValue),
            y: .value("Amount", group.quantity)
          )
          .foregroundStyle(by: .value("Project", group.project.rawValue))
        }
        ForEach(completedGroups) { group in
          BarMark(
            x: .value("Project", group.project.rawValue),
            y: .value("Amount", group.quantity)
          )
          .foregroundStyle(by: .value("Project", group.project.rawValue))
          .opacity(0.3)
        }
      }
      .chartLegend(.hidden)
      Spacer()
      Chart {
        ForEach(groups) { group in
          PointMark(
            x: .value("Project", group.project.rawValue),
            y: .value("Amount", group.quantity)
          )
        }
        
        ForEach(completedGroups) { group in
          PointMark(
            x: .value("Project", group.project.rawValue),
            y: .value("Amount", group.quantity)
          )
        }
        .foregroundStyle(Color.green)
      }
    }
  }
}

struct ChartsView_Previews: PreviewProvider {
  private class MockToDoListViewModel: ToDoListViewModel {
    var toDos: [ToDo] { [
      .init(title: "Some ToDo task", priority: .low, project: .work),
      .init(title: "Some ToDo task", priority: .high, project: .work),
      .init(title: "Some ToDo task", priority: .high, project: .work, finishedOn: Date()),
      .init(title: "Some ToDo task", priority: .high, project: .work, finishedOn: Date()),
      .init(title: "Some ToDo task", priority: .high, project: .work, finishedOn: Date()),
      .init(title: "Some ToDo task", priority: .low, project: .personal, finishedOn: Date()),
      .init(title: "Some ToDo task", priority: .medium, project: .personal),
      .init(title: "Some ToDo task", priority: .high, project: .growth),
      .init(title: "Some ToDo task", priority: .low, project: .growth),
      .init(title: "Some ToDo task", priority: .medium, project: .growth),
      .init(title: "Some ToDo task", priority: .medium, project: .wishList, finishedOn: Date()),
      .init(title: "Some ToDo task", priority: .medium, project: .wishList, finishedOn: Date()),
      .init(title: "Some ToDo task", priority: .medium, project: .wishList, finishedOn: Date()),
      .init(title: "Some ToDo task", priority: .high, project: .wishList)
    ]}
  }
  static var previews: some View {
    ChartsView(viewModel: MockToDoListViewModel())
  }
}
