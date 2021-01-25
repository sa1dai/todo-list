//
//  ChecklistViewController.swift
//  TodoList
//
//  Created by Admin on 25.01.2021.
//

import UIKit

class TodoListViewController: UITableViewController {

  var todoList: TodoList

  @IBOutlet weak var deleteButton: UIBarButtonItem!
  
  private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
    return TodoList.Priority(rawValue: index)
  }
  
  @IBAction func addItem(_ sender: Any) {
    
    let newRowIndex = todoList.todoList(for: .medium).count
    _ = todoList.newTodo()
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  @IBAction func deleteItems(_ sender: Any) {
    if let selectedRows = tableView.indexPathsForSelectedRows {
      for indexPath in selectedRows {
        if let priority = priorityForSectionIndex(indexPath.section) {
          let todos = todoList.todoList(for: priority)
          
          let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
          let item = todos[rowToDelete]
        
          todoList.remove(item, from: priority, at: rowToDelete)
        }
      }
      tableView.beginUpdates()
      tableView.deleteRows(at: selectedRows, with: .automatic)
      tableView.endUpdates()
      setIsEnabledDeleteButton()
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    todoList = TodoList()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = editButtonItem
    tableView.allowsMultipleSelectionDuringEditing = true
    deleteButton.isEnabled = false
  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    tableView.setEditing(tableView.isEditing, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let priority = priorityForSectionIndex(section) {
      return todoList.todoList(for: priority).count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath)
    //let item = todoList.todos[indexPath.row]
    if let priority = priorityForSectionIndex(indexPath.section) {
      let items = todoList.todoList(for: priority)
      let item = items[indexPath.row]
      configureText(for: cell, with: item)
      configureCheckmark(for: cell, with: item)
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if tableView.isEditing {
      setIsEnabledDeleteButton()
      return
    }
    if let cell = tableView.cellForRow(at: indexPath) {
      if let priority = priorityForSectionIndex(indexPath.section) {
        let items = todoList.todoList(for: priority)
        let item = items[indexPath.row]
        item.toggleChecked()
        configureCheckmark(for: cell, with: item)
        tableView.deselectRow(at: indexPath, animated: true)
      }
     
    }
  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if tableView.isEditing {
      setIsEnabledDeleteButton()
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if let priority = priorityForSectionIndex(indexPath.section) {
      let item = todoList.todoList(for: priority)[indexPath.row]
      todoList.remove(item, from: priority, at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
  }
    
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    
    if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
       let destPriority = priorityForSectionIndex(destinationIndexPath.section) {
      
      let item = todoList.todoList(for: srcPriority)[sourceIndexPath.row]
      todoList.move(item: item, from: srcPriority, at:sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
    }
    
    tableView.reloadData()
  }
  
  func setIsEnabledDeleteButton() {
    let hasSelectedRows = tableView.indexPathsForSelectedRows != nil
    deleteButton.isEnabled = hasSelectedRows
  }
  
  func configureText(for cell: UITableViewCell, with item: TodoListItem) {
    if let checkmarkCell = cell as? TodoListCellView {
      checkmarkCell.todoTextLabel.text = item.text
    }
  }
  
  func configureCheckmark(for cell: UITableViewCell, with item: TodoListItem) {
    guard let checkmarkCell = cell as? TodoListCellView else {
      return
    }
    if item.checked {
      checkmarkCell.checkmarkLabel.text = "√"
    } else {
      checkmarkCell.checkmarkLabel.text = ""
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItemSegue" {
      if let itemDetailViewController = segue.destination as? TodoListItemViewController {
        itemDetailViewController.delegate = self
        itemDetailViewController.todoList = todoList
      }
    } else if segue.identifier == "EditItemSegue" {
      if let itemDetailViewController = segue.destination as? TodoListItemViewController {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let priority = priorityForSectionIndex(indexPath.section)
          {
            
          let item = todoList.todoList(for: priority)[indexPath.row]
          itemDetailViewController.itemToEdit = item
          itemDetailViewController.delegate = self
        }
      }
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return TodoList.Priority.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var title: String? = nil
    if let priority = priorityForSectionIndex(section) {
      switch priority {
      case .high:
        title = "High Priority Todos"
      case .medium:
        title = "Medium Priority Todos"
      case .low:
        title = "Low Priority Todos"
      case .no:
        title = "Someday Todo Items"
      }
    }
    return title
  }
  
  
}

extension TodoListViewController: TodoListItemViewControllerDelegate {
  func todoListItemViewControllerDidCancel(_ controller: TodoListItemViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func todoListItemViewController(_ controller: TodoListItemViewController, didFinishAdding item: TodoListItem) {
    navigationController?.popViewController(animated: true)
    let rowIndex = todoList.todoList(for: .medium).count - 1
    let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  func todoListItemViewController(_ controller: TodoListItemViewController, didFinishEditing item: TodoListItem) {
    
    for priority in TodoList.Priority.allCases {
      let currentList = todoList.todoList(for: priority)
      if let index = currentList.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: priority.rawValue)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
    }
    navigationController?.popViewController(animated: true)
  }
  
  
}
