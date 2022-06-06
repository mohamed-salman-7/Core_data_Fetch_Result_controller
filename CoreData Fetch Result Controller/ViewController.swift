//
//  ViewController.swift
//  CoreData Fetch Result Controller
//
//  Created by Mohamed Salman on 04/06/22.
//

import UIKit
import CoreData

open class StudentModel: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var department: String?

}
class ViewController: UIViewController {

    @IBOutlet weak var studentListTableView: UITableView!
    
    var container: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.container
    }
    
    var students: [StudentModel] = [] {
        didSet {
            self.studentListTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        studentListTableView.delegate = self
        studentListTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
        
        let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        
        students = try! container.viewContext.fetch(fetchAll) as! [StudentModel]
    }
    
    
    @objc func reload() {
        let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        students = try! container.viewContext.fetch(fetchAll) as! [StudentModel]
        }
}

class StudentCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as? StudentCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = students[indexPath.row].name ?? "name"
        return cell
    }
    
    
}

