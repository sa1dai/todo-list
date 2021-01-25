//
//  ChecklistItem.swift
//  TodoList
//
//  Created by Admin on 25.01.2021.
//

import Foundation

class TodoListItem: NSObject {
  
  @objc var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
  
}
