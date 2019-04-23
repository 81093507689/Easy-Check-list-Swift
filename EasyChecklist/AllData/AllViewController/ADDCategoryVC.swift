//
//  ADDCategoryVC.swift
//  EasyChecklist
//
//  Created by developer on 23/03/19.
//  Copyright © 2019 EasyChecklist. All rights reserved.
//

import UIKit

class ADDCategoryVC: UIViewController,UITextFieldDelegate {

    var delegate:addNewCategoryProtocol?
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var viw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
            viw.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        
        if(textField == txtAmount)
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
        let getText = self.txtAmount.text as? String ?? ""
        let getFinalText = getText.trimmingCharacters(in: .whitespaces)
        
        if(getFinalText.count > 0)
        {
           
            let getvalue:Int = FMDBQueueManager.shareFMDBQueueManager.insertCATEGORY(getTitle: getFinalText)
                    if(delegate != nil)
                    {
                        delegate?.doneContinue(getID: getvalue,getTitle:getFinalText)
                    }
                    
                    self.dismiss(animated: true, completion: nil)
            
        }else
        {
            let alert = UIAlertController(title: "OOPS!", message: "Please enter weight", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func click_Close(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }

}
