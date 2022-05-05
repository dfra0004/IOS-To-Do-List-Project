//
//  PreviewTaskViewController.swift
//  FIT3178-Productive
//
//  Created by Dillon Frawley on 4/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class PreviewTaskViewController: UIViewController{

    @IBOutlet weak var realTaskTitleLabel: UILabel!
    @IBOutlet weak var realTaskDescriptionLabel: UILabel!
    
    var task: ToDoTask?
    
    
    @IBAction func handleSwipeRight(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        self.realTaskTitleLabel.text = self.task?.taskTitle
        self.realTaskDescriptionLabel.text = self.task?.taskDescription

        // Do any additional setup after loading the view.
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
