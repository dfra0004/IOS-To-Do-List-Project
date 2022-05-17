//
//  AllTasksViewController.swift
//  FIT3178-Productive
//
//  Created by Dillon Frawley on 2/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

class AllTasksViewController: UITableViewController, DatabaseListener {
    
    var listenerType = ListenerType.allTasks
    weak var databaseController: DatabaseProtocol?
    
    let SECTION_ALL_TASKS: Int = 0
    let CELL_ALL_TASKS: String = "allTasksCell"
    
    var allTasks: [ToDoTask] = []
    var task: ToDoTask?
    var selectedRows :[Int]?
    
    @IBAction func saveSelectedTasks(_ sender: Any) {
        if self.selectedRows != nil {
            for i in 0 ... self.selectedRows!.count - 1 {
                if selectedRows![i] == 1 {
                    let task = self.allTasks[i]
                    let _ = self.databaseController?.addTask(taskTitle: (task.taskTitle)!, taskDescription: (task.taskDescription)!, taskType: "current", coordinate: CLLocationCoordinate2D(latitude: (task.latitude)!, longitude: (task.longitude)!))
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func handleDoubleTap(_ sender: Any) {
        guard let recognizer = sender as? UITapGestureRecognizer else {
            return
        }
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                let isIndexValid = allTasks.indices.contains(tapIndexPath.row)
                if isIndexValid == true {
                    self.task = self.allTasks[tapIndexPath.row]
                    performSegue(withIdentifier: "previewTaskSegue", sender: self)
                }
            }
        }
        
        
    }
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        self.tableView.allowsMultipleSelection = true

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            if allTasks.count == 0 {
                return 1
            }
            else {
                return self.allTasks.count
            }
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure and return a task cell
        if allTasks.count == 0 {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: CELL_ALL_TASKS, for: indexPath)
            var content = taskCell.defaultContentConfiguration()
            content.text = "No saved tasks, tap + to create a task"
            taskCell.contentConfiguration = content
            return taskCell
        } else {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: CELL_ALL_TASKS, for: indexPath)
            var content = taskCell.defaultContentConfiguration()
            let task = allTasks[indexPath.row]
            content.text = task.taskTitle
            taskCell.contentConfiguration = content
            return taskCell
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_ALL_TASKS{
            return true
        }
        else {
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            let task = self.allTasks[indexPath.row]
            self.databaseController?.deleteTask(task: task, taskType: "allTasks")
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
    }
    

    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        switch section {
        case 0:
            return "Number of Tasks Saved:" + String(self.allTasks.count)
        default:
            return ""
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRows?[indexPath.row] = 1
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedRows?[indexPath.row] = 0
    }
    

    
    func onTaskChange(change: DatabaseChange, currentTasks: [ToDoTask], completedTasks: [ToDoTask]) {
        //
    }
    
    func onAllTaskChange(change: DatabaseChange, allTasks: [ToDoTask]) {
        self.allTasks = allTasks
        self.selectedRows = []
        for _ in 0...self.allTasks.count -1 {
            self.selectedRows?.append(0)
        }
        tableView.reloadData()
    }
    
    func onAuthChange(change: DatabaseChange, currentUser: User?) {
        //
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewTaskSegue"{
            let destination = segue.destination as! PreviewTaskViewController
            destination.task = self.task
            if task?.latitude != nil && task?.longitude != nil {
                destination.coordinate = CLLocationCoordinate2D(latitude: (task!.latitude)!, longitude: (task!.longitude)!)
           
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

