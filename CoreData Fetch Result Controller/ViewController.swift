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
    
    //    var students: [StudentModel] = [] {
    //        didSet {
    //            self.studentListTableView.reloadData()
    //        }
    //    }
    var frc: NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        studentListTableView.delegate = self
        studentListTableView.dataSource = self
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
        
        //        let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        //
        //        students = try! container.viewContext.fetch(fetchAll) as! [StudentModel]
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "department", ascending: true),
                                        NSSortDescriptor(key: "name", ascending: true)]
        frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                         managedObjectContext: container.viewContext,
                                         sectionNameKeyPath: "department",
                                         cacheName: nil)
        try? frc?.performFetch()
        frc?.delegate = self
    }
    
    
    @objc func reload() {
        //        let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        //        students = try! container.viewContext.fetch(fetchAll) as! [StudentModel]
    }
}

class StudentCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return frc?.sections?.count ?? 1
        //        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc?.sections?[section].numberOfObjects ?? 0
        //        return students.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return frc?.sections?[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as? StudentCell else {
            return UITableViewCell()
        }
        let student = frc?.object(at: indexPath) as? StudentModel
        cell.nameLabel.text = student?.name ?? "name"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let student = frc?.object(at: indexPath)
            container.viewContext.delete(student! as! NSManagedObject)
            try? container.viewContext.save()
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        studentListTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            studentListTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            studentListTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            studentListTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            studentListTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            studentListTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            studentListTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        studentListTableView.endUpdates()
    }
}

