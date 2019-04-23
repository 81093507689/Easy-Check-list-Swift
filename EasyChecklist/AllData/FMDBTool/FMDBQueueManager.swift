//
//  FMDBQueueManager.swift

import UIKit
import FMDB

class FMDBQueueManager: NSObject {

    static let shareFMDBQueueManager = FMDBQueueManager()
    
    var dbQueue : FMDatabaseQueue?
    
    func openDB(_ dbName : String)  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print("*******************************************************  ----------- > ",path)
        
        dbQueue = FMDatabaseQueue(path: "\(path)/\(dbName)")
      
        createTable()
        
       
        
    }
    //....Keychain access value
    //let getkeyvalue = Keychain.value(forKey: kappLastVersion) ?? "Not found"
    
    /*
     * Create Table in database
     * type cause -> 0 , resolution -> 1
     * section RBU 11 -> A , RBU 100 -> B , RBU 100 Sescor -> C , TCD 750 -> D
    */
    func createTable() -> Void {
        let sql_tbl = "CREATE TABLE IF NOT EXISTS NOTE ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE,'text' TEXT , 'completed' INTEGER, 'categoryid' INTEGER)"
      
        dbQueue?.inDatabase({ (db) -> Void in
            try? db.executeUpdate(sql_tbl, values: [])
        })
        
        let sql_tbl2 = "CREATE TABLE IF NOT EXISTS CATEGORY ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE,'text' TEXT ,'dt' datetime )"
        
        dbQueue?.inDatabase({ (db) -> Void in
            try? db.executeUpdate(sql_tbl2, values: [])
        })
    }
    
   
    
    func insertCATEGORY(getTitle:String)->Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let today = dateFormatter.string(from: NSDate() as Date)
        
        let sql = "INSERT INTO CATEGORY (text,dt) values ('\(getTitle)','\(today)')"
        var getId:Int = 0
        dbQueue?.inDatabase({ (db) ->Void in
            
            try? db.executeUpdate(sql, values: [])
            
            // print(Int(db.lastInsertRowId))
            getId = Int(db.lastInsertRowId)
            
            
            
            
        })
        
        
        return getId
      //  return getlastid.description
    }
    
    
    func insertNote(getTitle:String,getCategoryID:Int)->Int {
        
    
        
        let sql = "INSERT INTO NOTE (text,completed,categoryid) values ('\(getTitle)','0','\(getCategoryID)')"
        var getId:Int = 0
        dbQueue?.inDatabase({ (db) ->Void in
            
            try? db.executeUpdate(sql, values: [])
            
            // print(Int(db.lastInsertRowId))
            getId = Int(db.lastInsertRowId)
            
            
            
            
        })
        
        
        return getId
        //  return getlastid.description
    }
    
    
    func GetNotesByCategory(categoryId:Int)->NSMutableArray
    {
        let sql = "SELECT * FROM NOTE where categoryid = '\(categoryId)'"
        
        let resultArray:NSMutableArray = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getid = result.string(forColumn: "id") ?? ""
                    let gettext = result.string(forColumn: "text") ?? ""
                    let getcompleted = result.string(forColumn: "completed") ?? ""
                    let createDic:NSMutableDictionary = NSMutableDictionary()
                    
                    createDic.setValue(getid, forKey: "id")
                    createDic.setValue(gettext, forKey: "text")
                    createDic.setValue(getcompleted, forKey: "completed")
                    resultArray.add(createDic)
                }
            }
            
        })
        return resultArray
    }
    
    
    func GetAllCategory()->NSMutableArray
    {
        let sql = "SELECT *, (SELECT Count(*) as c FROM NOTE where categoryid = CATEGORY.id) as total, (SELECT Count(*) as c FROM NOTE where categoryid = CATEGORY.id and NOTE.completed = '1') as completed  FROM CATEGORY"
        
        let resultArray:NSMutableArray = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getid = result.string(forColumn: "id") ?? ""
                    let gettext = result.string(forColumn: "text") ?? ""
                    let getdt = result.string(forColumn: "dt") ?? ""
                    let getnotcompleted = result.string(forColumn: "total") ?? ""
                    let getcompleted = result.string(forColumn: "completed") ?? ""
                    
                    let createDic:NSMutableDictionary = NSMutableDictionary()
                    
                    createDic.setValue(getid, forKey: "id")
                    createDic.setValue(gettext, forKey: "text")
                    createDic.setValue(getdt, forKey: "dt")
                    createDic.setValue(getnotcompleted, forKey: "total")
                    createDic.setValue(getcompleted, forKey: "completed")
                    resultArray.add(createDic)
                }
            }
            
        })
        return resultArray
    }
    
    
    func UpdateNotes(noteid:String,completed:Int) {
   
        let sql = "UPDATE NOTE SET completed = \(completed) WHERE id = \(noteid)"
        
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            try? db.executeUpdate(sql, values: [])
        })
     
    }
    
    
    
    
    
    
    func DeleteNotes(categoryid:Int) {
        
        let sql = "DELETE FROM NOTE WHERE categoryid = '\(categoryid)' and completed = 1"
        
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            try? db.executeUpdate(sql, values: [])
        })
        
    }
    
    func DeleteCategory(categoryid:String) {
        
        let sql = "DELETE FROM CATEGORY WHERE id = '\(categoryid)'"
        
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            try? db.executeUpdate(sql, values: [])
        })
        
    }
    
}
