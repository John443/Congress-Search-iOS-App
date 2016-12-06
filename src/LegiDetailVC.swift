//
//  DetailViewController.swift
//  Congress
//
//  Created by John Jiang on 2016/11/23.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit
import CoreData

class LegiDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var bioid = ""
    var dict:Dictionary<String, AnyObject> = [:]
    var content: NSManagedObject!
    var prefix:Array<String> = ["First Name", "Last Name", "State", "Birth Date", "Gender", "Chamber", "Fax No.", "Twitter", "Facebook", "Website", "Office No.", "Term Ends On"]
    var dbPrefix:Array<String> = ["legiFirstName", "legiLastName", "legiState", "legiBirth", "legiGender", "legiChamber", "legiFax", "legiFacebook", "legiTwitter", "legiWeb", "legiOffice", "legiTerm"]
    var data:Array<String> = []
    
    var navBar: UINavigationBar!
    var textView: UITextView!
    var favBtn: UIButton!
    var delBtn: UIButton!
    var imgView: UIImageView!
    var tableViewDetail: UITableView!
    
    var favLegi = [NSManagedObject]()

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
        
        textView = UITextView(frame: CGRect(x: screenWidth / 2 - 80, y: 20, width: 200, height: 35))
        textView.backgroundColor = UIColor.init(white: 1.0, alpha: 0)
        textView.text = "Legislator Details"
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
        
        imgView = UIImageView(frame: CGRect(x: 100, y: 70, width: screenWidth - 200, height: 300))
        let strUrl = "https://theunitedstates.io/images/congress/original/" + bioid + ".jpg"
        addRemoteImage(img: imgView, strUrl: strUrl)
        imgView.contentMode = .scaleAspectFit
        self.view.addSubview(imgView)
        
        tableViewDetail = UITableView(frame: CGRect(x: 0, y: 370, width: screenWidth, height: screenHeight - 370))
        tableViewDetail.delegate = self
        tableViewDetail.dataSource = self
        tableViewDetail.register(LegiDetailCell.self, forCellReuseIdentifier: "detailCell")
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
    
    func addRemoteImage(img: UIImageView, strUrl: String) {
        let url = NSURL(string: strUrl)
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let image = UIImage(data: data! as Data)
            img.image = image
        }
        else {
            img.image = UIImage(named: "defaultImage")
        }
    }
    
    func loadDatas() {
        for _ in 0...11 {
            data.append("N.A.")
        }
        if dict.count > 0 {
            for item in dict {
                switch item.key {
                case "first_name":
                    data[0] = (item.value as? String)!
                case "last_name":
                    data[1] = (item.value as? String)!
                case "state_name":
                    data[2] = (item.value as? String)!
                case "birthday":
                    let str = (item.value as? String)!
                    let formater = DateFormatter()
                    formater.dateFormat = "yyyy-MM-dd"
                    let date = formater.date(from: str)
                    formater.dateFormat = "dd MMM yyyy"
                    let datestr = formater.string(from: date!)
                    data[3] = datestr
                case "gender":
                    if (item.value as! String) == "M" {
                        data[4] = "Male"
                    }
                    else {
                        data[4] = "Female"
                    }
                case "chamber":
                    if let str = item.value as? String {
                        data[5] = str.capitalized
                    }
                case "fax":
                    if let str = item.value as? String {
                        data[6] = str
                    }
                case "twitter_id":
                    if let str = item.value as? String {
                        data[7] = "https://twitter.com/" + str
                    }
                case "facebook_id":
                    if let str = item.value as? String {
                        data[8] = "https://www.facebook.com/" + str
                    }
                case "website":
                    if let str = item.value as? String {
                        data[9] = str
                    }
                case "office":
                    if let str = item.value as? String {
                        data[10] = str
                    }
                case "term_end":
                    if let str = item.value as? String {
                        let formater = DateFormatter()
                        formater.dateFormat = "yyyy-MM-dd"
                        let date = formater.date(from: str)
                        formater.dateFormat = "dd MMM yyyy"
                        let datestr = formater.string(from: date!)
                        data[11] = datestr
                    }
                default:
                    continue
                }
            }
        }
        else {
            for i in 0...11 {
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
        let entity = NSEntityDescription.entity(forEntityName: "FavLegi", in: context)
        let detail = NSManagedObject(entity: entity!, insertInto: context)
        let id = (dict["bioguide_id"] as? String)!
        detail.setValue(id, forKey: "legiBioid")
        for i in 0 ... 11 {
            detail.setValue(data[i], forKey: dbPrefix[i])
        }
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    func searchDetail() -> Bool {
        var tag = false
        for item in favLegi {
            if (item.value(forKey: "legiBioid") as! String) == bioid {
                tag = true
            }
        }
        return tag
    }
    
    func delDetail() {
        let context = getContext()
        for item in favLegi {
            if item.value(forKey: "legiBioid") as! String == bioid {
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
        let fetchRequest: NSFetchRequest<FavLegi> = FavLegi.fetchRequest()
        do {
            let res = try getContext().fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            favLegi = res as! [NSManagedObject]
//            for item in favLegi {
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
            let cell = tableViewDetail.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! LegiDetailCell
            cell.title?.text = prefix[indexPath.row]
            cell.detail?.text = data[indexPath.row]
            if indexPath.row == 7 {
                cell.loadButton()
            }
            else if indexPath.row == 8 {
                cell.loadButton()
            }
            else if indexPath.row == 9 {
                cell.loadButton()
            }
            else {
                cell.detail.isHidden = false
                cell.facebook.isHidden = true
                cell.twitter.isHidden = true
                cell.website.isHidden = true
            }
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
