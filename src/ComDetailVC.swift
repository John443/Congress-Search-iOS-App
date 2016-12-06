//
//  ComDetailVC.swift
//  Congress
//
//  Created by John Jiang on 2016/11/26.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit
import CoreData

class ComDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var dict:Dictionary<String, AnyObject> = [:]
    var content:NSManagedObject!
    var comID = ""
    var name = ""
    var prefix:Array<String> = ["ID", "Parent ID", "Chamber", "Office", "Contact"]
    var dbPrefix:Array<String> = ["comID", "comParent", "comChamber", "comOffice", "comContact", "comName"]
    var data:Array<String> = []
    
    var navBar: UINavigationBar!
    var textView: UITextView!
    var favBtn: UIButton!
    var delBtn: UIButton!
    var officeView: UITextView!
    var tableViewDetail: UITableView!
    
    var favCom = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        getDetail()
        loadItem()
        loadDatas()
    }
    
    func loadItem() {
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
        navBar.backgroundColor = UIColor.white
        self.view.addSubview(navBar)
        
        let button = UIButton(frame: CGRect(x: 0, y: 30, width: 80, height: 20))
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.init(red: 52 / 255.0, green: 152 / 255.0, blue: 219 / 255.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(self.returnToMain(_:)), for: .touchUpInside)
        self.navBar.addSubview(button)
        
        textView = UITextView(frame: CGRect(x: screenWidth / 2 - 80, y: 20, width: 200, height: 30))
        textView.backgroundColor = UIColor.init(white: 1.0, alpha: 0)
        textView.text = "Committee Details"
        textView.font = UIFont(name: "Helvetica", size: 20)
        self.navBar.addSubview(textView)
        
        favBtn = UIButton(frame: CGRect(x: screenWidth - 50, y: 20, width: 40, height: 40))
        let icon1 = UIImage(named: "Star-20")
        favBtn.setImage(icon1, for: .normal)
        favBtn.addTarget(self, action: #selector(self.favor(_:)), for: .touchUpInside)
        self.navBar.addSubview(favBtn)
        
        delBtn = UIButton(frame: CGRect(x: screenWidth - 50, y: 20, width: 40, height: 40))
        let icon2 = UIImage(named: "Star Filled-20")
        delBtn.setImage(icon2, for: .normal)
        delBtn.addTarget(self, action: #selector(self.delfav(_:)), for: .touchUpInside)
        self.navBar.addSubview(delBtn)
        
        officeView = UITextView(frame: CGRect(x: 20, y: 75, width: screenWidth - 40, height: 100))
        officeView.text = name
        officeView.font = UIFont(name: "Helvetica", size: 15)
        self.view.addSubview(officeView)
        
        tableViewDetail = UITableView(frame: CGRect(x: 0, y: 185, width: screenWidth, height: screenHeight - 180))
        tableViewDetail.delegate = self
        tableViewDetail.dataSource = self
        tableViewDetail.register(ComDetailCell.self, forCellReuseIdentifier: "detailCell")
        self.view.addSubview(self.tableViewDetail)
        
        if searchDetail() {
            favBtn.isHidden = true
            delBtn.isHidden = false
        }
        else {
            favBtn.isHidden = false
            delBtn.isHidden = true
        }
    }
    
    func loadDatas() {
        for _ in 0...4 {
            data.append("N.A.")
        }
        if dict.count > 0 {
            for item in dict {
                switch item.key {
                case "committee_id":
                    data[0] = (item.value as? String)!
                case "parent_committee_id":
                    data[1] = (item.value as? String)!
                case "chamber":
                    if let str = item.value as? String {
                        data[2] = str.capitalized
                    }
                case "office":
                    data[3] = (item.value as? String)!
                case "phone":
                    data[4] = (item.value as? String)!
                default:
                    continue
                }
            }
        }
        else {
            for i in 0...4 {
                if let val = content.value(forKey: dbPrefix[i]) as? String {
                    data[i] = val
                }
            }
        }
    }
    
    func favor(_ sender: UIButton) {
        delBtn.isHidden = false
        favBtn.isHidden = true
        storeDetail()
    }
    
    func delfav(_ sender: UIButton) {
        delBtn.isHidden = true
        favBtn.isHidden = false
        delDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeDetail() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "FavCom", in: context)
        let detail = NSManagedObject(entity: entity!, insertInto: context)
        for i in 0 ..< 5 {
            detail.setValue(data[i], forKey: dbPrefix[i])
        }
        detail.setValue(name, forKey: dbPrefix[5])
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    func searchDetail() -> Bool {
        var tag = false
        for item in favCom {
            if (item.value(forKey: "comID") as! String) == comID {
                tag = true
            }
        }
        return tag
    }
    
    func delDetail() {
        let context = getContext()
        for item in favCom {
            if item.value(forKey: "comID") as! String == comID {
                context.delete(item)
            }
        }
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    func getDetail() {
        let fetchRequest: NSFetchRequest<FavCom> = FavCom.fetchRequest()
        do {
            let res = try getContext().fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            favCom = res as! [NSManagedObject]
//            for item in favCom {
//                for pre in dbPrefix {
//                    print(item.value(forKey: pre) as? String)
//                }
//            }
        }
        catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prefix.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewDetail {
            let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! ComDetailCell
            cell.title.text = prefix[indexPath.row]
            cell.detail.text = data[indexPath.row]
            return cell
        }
        else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func returnToMain(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
