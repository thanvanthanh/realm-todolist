//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by Thanh - iOS on 19/05/2022.
//

import UIKit

class AddTodoViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var doneActionCallback: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextfield()
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    func setupTextfield() {
        textField.placeholder = "to do something ???"
        textField.delegate = self
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(AddTodoViewController.doneAction))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(AddTodoViewController.cancelAction))
    }
    
    @objc
    func doneAction() {
        doneActionCallback?(textField.text)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddTodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneAction()
        textField.resignFirstResponder()
        return true
    }
}
