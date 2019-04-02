//
//  VCListNotes.swift
//  MyNotesPP
//
//  Created by user146960 on 4/1/19.
//  Copyright © 2019 Miguel. All rights reserved.
//

import UIKit
import CoreData
class VCListNotes: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var listNotes  = [MyNotes]()
    
    @IBOutlet weak var tvNotesList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadNotes()
        tvNotesList.delegate = self
        tvNotesList.dataSource = self
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TVCNotes = tableView.dequeueReusableCell(withIdentifier: "CellNote", for: indexPath) as! TVCNotes
        
        cell.SetNotes(note: listNotes[indexPath.row])
        cell.buDelete.tag = indexPath.row
        cell.buDelete.addTarget(self, action: #selector(buDeletePress(_ :)), for: .touchUpInside)
        
        cell.buEdit.tag = indexPath.row
        cell.buEdit.addTarget(self, action: #selector(buEditPress(_ :)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func buDeletePress(_ sender:UIButton){
        context.delete(listNotes[sender.tag])
        LoadNotes()
    }
    
    @objc func buEditPress(_ sender:UIButton){
        performSegue(withIdentifier: "EditOrAddSegue", sender: listNotes[sender.tag])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditOrAddSegue" {
            if let AddOrEdit = segue.destination as? ViewController {
                if let mynote = sender as? MyNotes {
                    AddOrEdit.EditNote = mynote
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func buAdd(_ sender: Any) {
        performSegue(withIdentifier: "EditOrAddSegue", sender: nil)
    }
    
    func LoadNotes(){
        let fetchRequest:NSFetchRequest<MyNotes> = MyNotes.fetchRequest()
        
        do{
            listNotes = try context.fetch(fetchRequest)
            tvNotesList.reloadData()
        } catch {
            print("Couldnt access to the database")
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
