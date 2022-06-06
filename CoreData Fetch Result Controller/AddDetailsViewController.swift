//
//  AddDetailsViewController.swift
//  CoreData Fetch Result Controller
//
//  Created by Mohamed Salman on 04/06/22.
//

import UIKit
import CoreData

class AddDetailsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    
    var container: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: container.viewContext) as? StudentModel
        
        student?.name = nameTextField.text
        student?.department = departmentTextField.text
        
        do {
            try container.viewContext.save()
        } catch  {
            print(error)
        }
//        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
        self.dismiss(animated: true)
    }
}
