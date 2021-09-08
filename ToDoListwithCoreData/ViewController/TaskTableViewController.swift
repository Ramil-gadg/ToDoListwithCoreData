//
//  TaskTableViewController.swift
//  ToDoListwithCoreData
//
//  Created by Рамил Гаджиев on 05.09.2021.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    
    var taskList: TaskList?
    var storeManager = DataStore.shared
    var completedTasks: [Tasks] = []
    var notCompletedTasks: [Tasks] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completedTasks = storeManager.fetchTask(taskList: taskList!, completed: true)
        notCompletedTasks = storeManager.fetchTask(taskList: taskList!, completed: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func addTask () {
        showAlert()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return notCompletedTasks.count
        } else {
            return completedTasks.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Не выполненные"
        } else {
            return "Выполненные"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasks", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = notCompletedTasks[indexPath.row].name
            cell.detailTextLabel?.text = notCompletedTasks[indexPath.row].descriptions
            return cell
        }
        else {
            cell.textLabel?.text = completedTasks[indexPath.row].name
            cell.detailTextLabel?.text = completedTasks[indexPath.row].descriptions
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if indexPath.section == 0 {
            let task = notCompletedTasks[index]
            showActionSheet (task: task, index: index)
        } else {
            let task = completedTasks[index]
            showActionSheet (task: task, index: index)
        }
        
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            if indexPath.section == 0 {
                let task = notCompletedTasks[index]
                notCompletedTasks.remove(at: indexPath.row)
                storeManager.deleteTask(taskList: taskList!, task: task)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let task = completedTasks[index]
                completedTasks.remove(at: indexPath.row)
                storeManager.deleteTask(taskList: taskList!, task: task)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func showAlert() {
        let alert = UIAlertController(title: "Добавить задачи", message: "Напишите задачу", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { action in
            if let name = alert.textFields?.first?.text, name.trimmingCharacters(in: .whitespacesAndNewlines) != "", let description = alert.textFields?.last?.text, description.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                let newTask = self.storeManager.saveTask(taskList: self.taskList!, name: name, description: description)
                self.notCompletedTasks.append(newTask)
            } else if let name = alert.textFields?.first?.text, name.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                let newTask = self.storeManager.saveTask(taskList: self.taskList!, name: name, description: "")
                self.notCompletedTasks.append(newTask)
            } else {return}
            
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alert.addTextField { textField in
            textField.placeholder = "Введите задачу"
        }
        alert.addTextField { textField in
            textField.placeholder = "Введите описание задачи"
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func showActionSheet (task: Tasks, index: Int) {
        let alert = UIAlertController(title: "Задача выполнена?", message: nil, preferredStyle: .actionSheet)
        let comletedTask = UIAlertAction(title: "Да, я молодец", style: .default) {[weak self] action in
            if task.completed == false {
                self?.notCompletedTasks.remove(at: index)
                self?.completedTasks.append(task)
                self?.storeManager.fetchAndChangeTask(task: task, completed: true)
               // task.completed = true
                self?.tableView.reloadData()
            }
        }
        var returnTaskButtonTitle = ""
        if task.completed == false {
            returnTaskButtonTitle = "Пока что нет"
        } else {
            returnTaskButtonTitle = "Оказалось, что нет"
        }
        let returnTask = UIAlertAction(title: returnTaskButtonTitle, style: .default) {[weak self] action in
            if task.completed == true {
                self?.completedTasks.remove(at: index)
                self?.notCompletedTasks.append(task)
                self?.storeManager.fetchAndChangeTask(task: task, completed: false)
                //task.completed = false
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alert.addAction(comletedTask)
        alert.addAction(returnTask)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}

