//
//  ItemDetailViewController.swift
//  TodoList
//
//  Created by Admin on 25.01.2021.
//

import UIKit

protocol TodoListItemViewControllerDelegate: class {
  func todoListItemViewControllerDidCancel(_ controller: TodoListItemViewController)
  func todoListItemViewController(_ controller: TodoListItemViewController, didFinishAdding item: TodoListItem)
  func todoListItemViewController(_ controller: TodoListItemViewController, didFinishEditing item: TodoListItem)
}

class TodoListItemViewController: UITableViewController {

  weak var delegate: TodoListItemViewControllerDelegate?
  weak var todoList: TodoList?
  weak var itemToEdit: TodoListItem?
  
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var addBarButton: UIBarButtonItem!
  @IBOutlet weak var textfield: UITextField!
 
  
  @IBAction func cancel(_ sender: Any) {
    delegate?.todoListItemViewControllerDidCancel(self)
  }
  
  @IBAction func done(_ sender: Any) {
    if let item = itemToEdit, let text = textfield.text {
      item.text = text
      delegate?.todoListItemViewController(self, didFinishEditing: item)
    } else {
      if let item = todoList?.newTodo() {
        if let textFieldText = textfield.text {
          item.text = textFieldText
        }
        item.checked = false
        delegate?.todoListItemViewController(self, didFinishAdding: item)
      }
    }
    

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let item = itemToEdit {
      title = "Edit Item"
      textfield.text = item.text
      addBarButton.isEnabled = true
    }
    navigationItem.largeTitleDisplayMode = .never
  }
  
  override func viewWillAppear(_ animated: Bool) {
    textfield.becomeFirstResponder()
  }
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
}

extension TodoListItemViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textfield.resignFirstResponder()
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let oldText = textfield.text,
          let stringRange = Range(range, in: oldText) else {
        return false
    }
    
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    if newText.isEmpty {
      addBarButton.isEnabled = false
    } else {
      addBarButton.isEnabled = true
    }
    return true
  }
  
  
}

