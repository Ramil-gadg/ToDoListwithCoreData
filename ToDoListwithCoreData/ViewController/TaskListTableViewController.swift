//
//  TaskListTableViewController.swift
//  ToDoListwithCoreData
//
//  Created by Рамил Гаджиев on 04.09.2021.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    
    var storeManager = DataStore.shared
    var taskLists: [TaskList] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskLists = storeManager.fetchTaskList()
        print(taskLists)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTaskLists))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        
    }
    
    @objc func addTaskList () {
        showAlert()
    }
    @objc func deleteTaskLists () {
        storeManager.deleteAllTaskLists()
        taskLists.removeAll()
        tableView.reloadData()
    }
    
    
 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let taskList = taskLists[indexPath.row]
        cell.textLabel?.text = taskList.name
        let tasks = storeManager.fetchTask(taskList: taskList, completed: nil)
        cell.detailTextLabel?.text = "\(tasks.count)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskList = taskLists[indexPath.row]
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "taskVC") as! TaskTableViewController
        vc.taskList = taskList
        navigationController?.pushViewController(vc, animated: true)
        
    }
    


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            let taskList = taskLists[indexPath.row]
            taskLists.remove(at: indexPath.row)
            storeManager.deleteTaskList(taskList: taskList)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    func showAlert() {
        let alert = UIAlertController(title: "Добавить список дел", message: "Напишите категорию списка", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { action in
            guard let name = alert.textFields?.first?.text, name.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {return}
            let newTaskList = self.storeManager.saveTaskList(name: name)
            self.taskLists.append(newTaskList)
            self.tableView.reloadData()
            }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alert.addTextField { textField in
            textField.placeholder = "Введите название категории"
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        }
    }

