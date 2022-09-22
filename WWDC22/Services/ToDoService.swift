//
//  ToDoService.swift
//  WWDC22
//
//  Created by Tomas Trujillo on 2022-08-23.
//

import Foundation
import Combine

struct ToDo: Identifiable {
  enum Priority {
    case low
    case medium
    case high
  }
  
  enum Project: String, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case growth = "Growth"
    case wishList = "Wish List"
  }
  
  let id = UUID()
  let title: String
  let priority: Priority
  let project: Project
  var finishedOn: Date?
  var finishedOnWithoutTime: Date? { finishedOn?.dateWithoutTime() }
  var isDone: Bool { finishedOn != nil }
}

protocol ToDoService {
  var toDos: AnyPublisher<[ToDo], Never> { get }
  func add(toDo: ToDo)
}

final class ToDoServiceAdapter: ToDoService {
  static let shared = ToDoServiceAdapter()
  private var currentValueToDos = CurrentValueSubject<[ToDo], Never>([])
  var toDos: AnyPublisher<[ToDo], Never> {
    currentValueToDos.eraseToAnyPublisher()
  }
  
  private init() {
    currentValueToDos.value = getMockToDos()
  }
  
  func add(toDo: ToDo) {
    var tasks = currentValueToDos.value
    tasks.append(toDo)
    currentValueToDos.value = tasks
  }
}

private extension ToDoServiceAdapter {
  func getMockData() -> [ToDo] {
    var tasks: [ToDo] = []
    tasks.append(ToDo(title: "Take out trash ", priority: .medium, project: .personal))
    tasks.append(ToDo(title: "Renew insurance", priority: .high, project: .personal))
    tasks.append(ToDo(title: "Buy chocolates 🍫", priority: .low, project: .personal))
    tasks.append(ToDo(title: "Wash dishes", priority: .medium, project: .personal))
    tasks.append(ToDo(title: "Water plants 🌱", priority: .medium, project: .personal))
    tasks.append(ToDo(title: "Changes tires", priority: .low, project: .personal, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Groom cat 🐈", priority: .medium, project: .personal, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Signup for Swift course 🐥", priority: .low, project: .growth))
    tasks.append(ToDo(title: "Look for mentor", priority: .medium, project: .growth))
    tasks.append(ToDo(title: "Subscribe to Coding With Tom ;)", priority: .high, project: .growth))
    tasks.append(ToDo(title: "Look for kata website", priority: .low, project: .growth))
    tasks.append(ToDo(title: "Update CV", priority: .medium, project: .growth, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Prepare presentation", priority: .high, project: .work))
    tasks.append(ToDo(title: "Schedule offsite", priority: .medium, project: .work))
    tasks.append(ToDo(title: "Order extra monitor", priority: .low, project: .work))
    tasks.append(ToDo(title: "Complete DEI training", priority: .high, project: .work, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Update OS on all devices", priority: .high, project: .work, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Send invites to All Hands", priority: .low, project: .work, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Prepare demo for PM's", priority: .medium, project: .work, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Pair programming session", priority: .medium, project: .work, finishedOn: pastDate()))
    tasks.append(ToDo(title: "Get a dog 🐶", priority: .high, project: .wishList))
    tasks.append(ToDo(title: "Buy a boat ⛵️", priority: .low, project: .wishList))
    tasks.append(ToDo(title: "Get a cat 🐈", priority: .high, project: .wishList, finishedOn: pastDate()))
    return tasks
  }
  
  func pastDate() -> Date {
    let calendar = Calendar.current
    return calendar.date(byAdding: .day, value: Int.random(in: -7 ... -1), to: Date()) ?? Date()
  }
}

extension ToDoServiceAdapter {
  func getMockToDos() -> [ToDo] {
    let todos = getMockData()
    return todos.flatMap { todo in
      (1 ... 10).map { index in
        ToDo(title: "\(todo.title) \(index)",
             priority: todo.priority,
             project: todo.project,
             finishedOn: dateInPastMonth())
      }
    }
  }
  
  private func dateInPastMonth() -> Date {
    let calendar = Calendar.current
    return calendar.date(byAdding: .month, value: Int.random(in: -11 ... 0), to: Date()) ?? Date()
  }
}
