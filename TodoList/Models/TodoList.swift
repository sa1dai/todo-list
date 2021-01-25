//
//  TodoList.swift
//  TodoList
//
//  Created by Admin on 25.01.2021.
//

import Foundation

class TodoList {
  
  enum Priority: Int, CaseIterable {
    case high, medium, low, no
  }
  
  private var highPriorityTodos: [TodoListItem] = []
  private var mediumPriorityTodos: [TodoListItem] = []
  private var lowPriorityTodos: [TodoListItem] = []
  private var noPriorityTodos: [TodoListItem] = []
  
  var isEmpty: Bool {
    return highPriorityTodos.isEmpty &&
      mediumPriorityTodos.isEmpty &&
      lowPriorityTodos.isEmpty &&
      noPriorityTodos.isEmpty
  }
  
  func addTodo(_ item: TodoListItem, for priority: Priority, at index: Int = -1) {
    switch priority {
    case .high:
      if index < 0 {
        highPriorityTodos.append(item)
      } else {
        highPriorityTodos.insert(item, at: index)
      }
    case .medium:
      if index < 0 {
        mediumPriorityTodos.append(item)
      } else {
        mediumPriorityTodos.insert(item, at: index)
      }
    case .low:
      if index < 0 {
        lowPriorityTodos.append(item)
      } else {
        lowPriorityTodos.insert(item, at: index)
      }
    case .no:
      if index < 0 {
        noPriorityTodos.append(item)
      } else {
        noPriorityTodos.insert(item, at: index)
      }
    }
  }
  
  func todoList(for priority: Priority) -> [TodoListItem] {
    switch priority {
    case .high:
      return highPriorityTodos
    case .medium:
      return mediumPriorityTodos
    case .low:
      return lowPriorityTodos
    case .no:
      return noPriorityTodos
    }
  }
  
  func newTodo() -> TodoListItem {
    let item = TodoListItem()
    item.text = ""
    item.checked  = true
    mediumPriorityTodos.append(item)
    return item
  }
  
  func move(item: TodoListItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int) {
    remove(item, from: sourcePriority, at: sourceIndex)
    addTodo(item, for: destinationPriority, at: destinationIndex)
    
  }
  
  func remove(_ item: TodoListItem, from priority: Priority, at index: Int) {
    switch priority {
    case .high:
      highPriorityTodos.remove(at: index)
    case .medium:
      mediumPriorityTodos.remove(at: index)
    case .low:
      lowPriorityTodos.remove(at: index)
    case .no:
      noPriorityTodos.remove(at: index)
    }

  }
  
}
