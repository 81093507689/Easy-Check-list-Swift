//
//  ViewController.swift
//  EasyChecklist
//
//  Created by developer on 23/03/19.
//  Copyright © 2019 EasyChecklist. All rights reserved.
//

import UIKit
protocol addNewCategoryProtocol: class {
    func doneContinue(getID:Int,getTitle:String)
    
    
}

class ViewController: UIViewController,addNewCategoryProtocol {
 
    

    var aryData: NSMutableArray = NSMutableArray()
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var viwNorecord: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.tableFooterView = UIView()
        tbl.estimatedRowHeight = 44.0
        self.tbl.rowHeight = UITableView.automaticDimension
        
        self.title = "Check List"
        navigationBar()
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllCategory()
        if(aryData.count > 0)
        {
            viwNorecord.isHidden = true
        }else
        {
            viwNorecord.isHidden = false
        }
        tbl.reloadData()
    }
    

    func navigationBar()
    {
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(self.click_Setting))
        
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        
    }
    
    @IBAction func click_Setting(sender: UIButton)
    {
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:ADDCategoryVC = mainStory.instantiateViewController(withIdentifier: "ADDCategoryVC") as! ADDCategoryVC
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func doneContinue(getID:Int,getTitle:String) {
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:AddNotesVC = mainStory.instantiateViewController(withIdentifier: "AddNotesVC") as! AddNotesVC
        viewController.getTitle = getTitle
        viewController.categoryID = getID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func click_DeleteCategory(sender: UIButton)
    {
        let getObje = aryData.object(at: sender.tag) as! NSDictionary
        let getid = getObje.value(forKey: "id") as? String ?? ""
        
        let alertController = UIAlertController(title: "Delete", message: "Are You sure want to delete?", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            FMDBQueueManager.shareFMDBQueueManager.DeleteCategory(categoryid: getid)
            self.aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllCategory()
            self.tbl.reloadData()
            
            if(self.aryData.count > 0)
            {
                self.viwNorecord.isHidden = true
            }else
            {
                self.viwNorecord.isHidden = false
            }
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
       
        
        alertController.addAction(action1)
        alertController.addAction(action2)
       
        self.present(alertController, animated: true, completion: nil)
        
    }
}




extension ViewController:UITableViewDataSource,UITableViewDelegate
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.aryData.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let getObje = aryData.object(at: indexPath.row) as! NSDictionary
        
        cell.lblTitle.text = getObje.value(forKey: "text") as? String ?? ""
        
        let getDate:String = getObje.value(forKey: "dt") as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let getFinalDate = dateFormatter.date(from: getDate)
        dateFormatter.dateFormat = "dd/MMMM/yyyy"
        let getdateINString = dateFormatter.string(from: getFinalDate!)
        
        cell.lblDate.text = getdateINString
        
        cell.btnDelete.tag = indexPath.row
        
        let total = getObje.value(forKey: "total") as? String ?? ""
        let getcompleted = getObje.value(forKey: "completed") as? String ?? ""
        
        cell.lblTotalCount.text = "\(getcompleted)" + "/" + total
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let getObje = aryData.object(at: indexPath.row) as! NSDictionary
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:AddNotesVC = mainStory.instantiateViewController(withIdentifier: "AddNotesVC") as! AddNotesVC
        viewController.getTitle = getObje.value(forKey: "text") as? String ?? ""
        let getCategoryID:String = getObje.value(forKey: "id") as? String ?? ""
        print(getCategoryID)
        viewController.categoryID = Int(getCategoryID) ?? 0
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
