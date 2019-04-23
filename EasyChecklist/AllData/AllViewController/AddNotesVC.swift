//
//  AddNotesVC.swift
//  EasyChecklist
//
//  Created by developer on 23/03/19.
//  Copyright © 2019 EasyChecklist. All rights reserved.
//

import UIKit

class AddNotesVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtNotes: UITextField!
    var getTitle:String = ""
    var categoryID:Int = 0
    
    var aryData: NSMutableArray = NSMutableArray()
    var arySelectedIndex:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tbl: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbl.tableFooterView = UIView()
        tbl.estimatedRowHeight = 44.0
        self.tbl.rowHeight = UITableView.automaticDimension
        
        self.title = getTitle
        navigationBar()
        
        
        aryData = FMDBQueueManager.shareFMDBQueueManager.GetNotesByCategory(categoryId: categoryID)
        print(aryData)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        
        if(textField == txtNotes)
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
                return true
            }else
            {
                return false
            }
        }
        
        return false
    }
    
    @IBAction func click_submit(_ sender: UIButton)
    {
        let getText = self.txtNotes.text as? String ?? ""
        let getFinalText = getText.trimmingCharacters(in: .whitespaces)
        if(getFinalText.count > 0)
        {
            
            FMDBQueueManager.shareFMDBQueueManager.insertNote(getTitle: getFinalText, getCategoryID: categoryID)
            aryData = FMDBQueueManager.shareFMDBQueueManager.GetNotesByCategory(categoryId: categoryID)
            self.tbl.reloadData()
            self.txtNotes.text = ""
            self.view.endEditing(true)
        }
    }
    
    @IBAction func click_addCheckmark(_ sender: UIButton)
    {
        let getObje = aryData.object(at: sender.tag) as! NSDictionary
        let completed = getObje.value(forKey: "completed") as? String ?? ""
        let notesid = getObje.value(forKey: "id") as? String ?? ""
        if(completed == "0")
        {
            FMDBQueueManager.shareFMDBQueueManager.UpdateNotes(noteid: notesid, completed: 1)
        }else
        {
            FMDBQueueManager.shareFMDBQueueManager.UpdateNotes(noteid: notesid, completed: 0)
        }
        aryData = FMDBQueueManager.shareFMDBQueueManager.GetNotesByCategory(categoryId: categoryID)
        self.tbl.reloadData()
    }
    
    
    func navigationBar()
    {
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete"), style: .plain, target: self, action: #selector(self.click_Delete))
        
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        
    }
    
    @IBAction func click_Delete(sender: UIButton)
    {
        FMDBQueueManager.shareFMDBQueueManager.DeleteNotes(categoryid: categoryID)
        aryData = FMDBQueueManager.shareFMDBQueueManager.GetNotesByCategory(categoryId: categoryID)
        self.tbl.reloadData()
    }

}


extension AddNotesVC:UITableViewDataSource,UITableViewDelegate
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.aryData.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as! NotesTableViewCell
        
        let getObje = aryData.object(at: indexPath.row) as! NSDictionary
        
        let getTitle:String = getObje.value(forKey: "text") as? String ?? ""
        
        
        
        
        cell.btnCheckmark.tag = indexPath.row
        let getCheckmarkValue = getObje.value(forKey: "completed") as? String ?? ""
        
        if(getCheckmarkValue == "0")
        {
            cell.btnCheckmark.setImage(UIImage.init(named: "blank"), for: .normal)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: getTitle,attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size: 21.0)!])
           // attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.lblTitle.attributedText = attributeString
        }else
        {
            cell.btnCheckmark.setImage(UIImage.init(named: "tick"), for: .normal)
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: getTitle,attributes: [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue", size: 21.0)!])
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            cell.lblTitle.attributedText = attributeString
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
