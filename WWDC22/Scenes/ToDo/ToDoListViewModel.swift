//
//  ToDoListViewModel.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-08-23.
//

import Foundation
import Combine

protocol ToDoListViewModel: ObservableObject {
  var toDos: [ToDo] { get }
}

final class ToDoListViewModelAdapter: ToDoListViewModel {
  struct Dependencies {
    var toDoService: ToDoService = ToDoServiceAdapter.shared
  }
  
  private let dependencies: Dependencies
  private var subscirptions = Set<AnyCancellable>()
  
  @Published var toDos: [ToDo] = []
  
  init(dependencies: Dependencies = .init()) {
    self.dependencies = dependencies
    setup()
  }
}

private extension ToDoListViewModelAdapter {
  func setup() {
    dependencies.toDoService.toDos.receive(on: RunLoop.main).sink { [weak self] in
      self?.toDos = $0
    }.store(in: &subscirptions)
  }
}

