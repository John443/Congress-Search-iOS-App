//
//  ComHouseViewController.swift
//  Congress
//
//  Created by John Jiang on 2016/11/25.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ComSenateViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var navMain: UINavigationBar!
    var tableViewCom: UITableView!
    var filtButton: UIButton!
    var uiviewTabView: UIView!
    var textView: UITextView!
    var leftWindow: UIView!
    var table: UITableView!
    var dimBackGround: UIButton!
    var startImg: UIImageView!
    var titleView: UITextView!
    
    var searchBar: UISearchBar!
    var cancelButton: UIButton!
    
    var arrRes = [[String:AnyObject]]()
    var searchRes = [[String:AnyObject]]()
    let menu = ["Legislator", "Bills", "Committee", "Favorite", "About"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
        loadDataFromNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show(duration: 1.0, title: "Fetching Data...")
    }
    
    func loadItem() {
        self.title = "Committees"
        
        navMain = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 70))
        navMain.backgroundColor = UIColor.white
        self.view.addSubview(navMain)
        
        let menuButton = UIButton(frame: CGRect(x: 20, y: 30, width: 20, height: 20))
        let menuIcon = UIImage(named: "Menu Filled-20")
        menuButton.setImage(menuIcon, for: .normal)
        menuButton.addTarget(self, action: #selector(self.clickOnIt(_:)), for: .touchUpInside)
        self.navMain.addSubview(menuButton)
        
        textView = UITextView(frame: CGRect(x: screenWidth / 2 - 60, y: 20, width: 120, height: 30))
        textView.backgroundColor = UIColor.init(white: 1.0, alpha: 0)
        textView.text = "Committees"
        textView.font = UIFont(name: "Helvetica", size: 20)
        self.navMain.addSubview(textView)
        
        filtButton = UIButton(frame: CGRect(x: screenWidth - 40, y: 30, width: 20, height: 20))
        let filtIcon = UIImage(named: "Search-20")
        filtButton.setImage(filtIcon, for: .normal)
        filtButton.addTarget(self, action: #selector(self.filterButton(_:)), for: .touchUpInside)
        self.navMain.addSubview(filtButton)
        
        searchBar = UISearchBar(frame: CGRect(x: 60, y: 30, width: screenWidth - 120, height: 20))
        self.searchBar.delegate = self
        self.navMain.addSubview(searchBar)
        searchBar.isHidden = true
        
        cancelButton = UIButton(frame: CGRect(x: screenWidth - 40, y: 30, width: 20, height: 20))
        let cancelIcon = UIImage(named: "Cancel-20")
        cancelButton.setImage(cancelIcon, for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelIt(_:)), for: .touchUpInside)
        self.navMain.addSubview(cancelButton)
        cancelButton.isHidden = true
        
        tableViewCom = UITableView(frame: CGRect(x: 0, y: 70, width: screenWidth, height: screenHeight - 120))
        tableViewCom.delegate = self
        tableViewCom.dataSource = self
        tableViewCom.register(ComTableViewCell.self, forCellReuseIdentifier: "comCell")
        self.view.addSubview(self.tableViewCom)
        
        uiviewTabView = UIView(frame: CGRect(x: 0, y: screenHeight - 50, width: screenWidth, height: 50))
        uiviewTabView.backgroundColor = UIColor.white
        self.view.addSubview(uiviewTabView)
        
        let firstButton = UIButton(frame: CGRect(x: 10, y: 15, width: 80, height: 20))
        firstButton.setTitle("House", for: .normal)
        firstButton.setTitleColor(UIColor.gray, for: .normal)
        firstButton.addTarget(self, action: #selector(self.firstBtn(_:)), for: .touchUpInside)
        self.uiviewTabView.addSubview(firstButton)
        
        let secondButton = UIButton(frame: CGRect(x: screenWidth / 2 - 40, y: 15, width: 80, height: 20))
        secondButton.setTitle("Senate", for: .normal)
        secondButton.setTitleColor(UIColor.init(red: 52 / 255.0, green: 152 / 255.0, blue: 219 / 255.0, alpha: 1.0), for: .normal)
        secondButton.addTarget(self, action: #selector(self.secondBtn(_:)), for: .touchUpInside)
        self.uiviewTabView.addSubview(secondButton)
        
        let thirdButton = UIButton(frame: CGRect(x: screenWidth - 100, y: 15, width: 80, height: 20))
        thirdButton.setTitle("Joint", for: .normal)
        thirdButton.setTitleColor(UIColor.gray, for: .normal)
        thirdButton.addTarget(self, action: #selector(self.thirdBtn(_:)), for: .touchUpInside)
        self.uiviewTabView.addSubview(thirdButton)
        
        dimBackGround = UIButton(frame: self.view.bounds)
        dimBackGround.backgroundColor = UIColor.init(red: 127 / 255, green: 127 / 255, blue: 127 / 255, alpha: 0.5)
        dimBackGround.addTarget(self, action: #selector(self.hideMenu(_:)) , for: .touchUpInside)
        dimBackGround.isHidden = true
        self.view.addSubview(dimBackGround)
        dimBackGround.layer.zPosition = 10
        
        leftWindow = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth*3/4, height: screenHeight))
        leftWindow.backgroundColor = UIColor.init(red: 213 / 255, green: 213 / 255, blue: 213 / 255, alpha: 0.8)
        leftWindow.center.x -= leftWindow.frame.size.width
        self.view.addSubview(leftWindow)
        leftWindow.layer.zPosition = 30
        
        startImg = UIImageView(frame: CGRect(x: 30, y: 20, width: screenWidth*3/4 - 60, height: 80))
        let strUrl = "http://cs-server.usc.edu:45678/hw/hw8/images/logo.png"
        addRemoteImage(img: startImg, strUrl: strUrl)
        leftWindow.addSubview(startImg)
        
        titleView = UITextView(frame: CGRect(x: 30, y: 110, width: screenWidth*3/4 - 60, height: 40))
        titleView.backgroundColor = UIColor.init(white: 1.0, alpha: 0)
        titleView.text = "Congress API"
        titleView.font = UIFont(name: "Helvetica", size: 20)
        leftWindow.addSubview(titleView)
        
        table = UITableView(frame: CGRect(x: 0, y: 180, width: screenWidth*3/4, height: screenHeight - 180))
        table.backgroundColor = UIColor.init(red: 229 / 255, green: 235 / 255, blue: 222 / 255, alpha: 0.8)
        table.delegate = self
        table.dataSource = self
        table.register(BaseTableViewCell.self, forCellReuseIdentifier: "baseCell")
        leftWindow.addSubview(table)
    }
    
    func clickOnIt(_ sender: UIButton) {
        dimBackGround.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.leftWindow.center.x += self.leftWindow.frame.size.width
        }
    }
    
    func hideMenu(_ sender: UIButton) {
        dimBackGround.isHidden = true
        UIView.animate(withDuration: 0.2) {
            self.leftWindow.center.x -= self.leftWindow.frame.size.width
        }
    }
    
    func filterButton(_ sender: UIButton) {
        cancelButton.isHidden = false
        searchBar.isHidden = false
        filtButton.isHidden = true
    }
    
    func cancelIt(_ sender: UIButton) {
        cancelButton.isHidden = true
        searchBar.isHidden = true
        filtButton.isHidden = false
        searchBar.text = ""
        self.tableViewCom.reloadData()
    }
    
    func firstBtn(_ sender: UIButton) {
        let comHouseVC = ComHouseViewController()
        self.present(comHouseVC, animated: true, completion: nil)
    }
    
    func secondBtn(_ sender: UIButton) {
        let comSenateVC = ComSenateViewController()
        self.present(comSenateVC, animated: true, completion: nil)
    }
    
    func thirdBtn(_ sender: UIButton) {
        let comJointVC = ComJointViewController()
        self.present(comJointVC, animated: true, completion: nil)
    }
    
    func loadDataFromNetwork() {
        let url:String = "http://app12016-env.us-west-1.elasticbeanstalk.com/loadData.php/"
        Alamofire.request(url, parameters: ["key": "committees"]).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let resData = swiftyJsonVar["results"].arrayObject {
                    //print(resData)
                    let result = resData as! [[String: AnyObject]]
                    var items = [[String: AnyObject]]()
                    for item in result {
                        if (item["chamber"] as! String) == "senate" {
                            items.append(item)
                        }
                    }
                    self.arrRes = items
                }
                if self.arrRes.count > 0 {
                    self.tableViewCom.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tableViewCom {
            if searchBar.isHidden {
                return arrRes.count
            }
            else {
                return searchRes.count
            }
        }
        else if tableView == table {
            return menu.count
        }
        else {
            return 0
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.searchRes = self.arrRes
        }
        else {
            self.searchRes = [[String:AnyObject]]()
            for item in arrRes {
                let fname = (item["name"] as? String)!
                if fname.lowercased().contains(searchText.lowercased()) {
                    searchRes.append(item)
                }
            }
        }
        self.tableViewCom.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewCom {
            let cell = tableViewCom.dequeueReusableCell(withIdentifier: "comCell", for: indexPath) as! ComTableViewCell
            var dict = [String:AnyObject]()
            if searchBar.isHidden {
                dict = arrRes[indexPath.row]
            }
            else {
                dict = searchRes[indexPath.row]
            }
            cell.title.text = (dict["name"] as? String)!
            cell.subTitle.text = (dict["committee_id"] as? String)!
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
            
            return cell
        }
        else if tableView == table {
            let cell = table.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! BaseTableViewCell
            cell.title.text = menu[indexPath.row]
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
            return cell
        }
        else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewCom {
            tableViewCom.deselectRow(at: indexPath, animated: true)
            let detailVC = ComDetailVC()
            var dict = [String:AnyObject]()
            if searchBar.isHidden {
                dict = arrRes[indexPath.row]
            }
            else {
                dict = searchRes[indexPath.row]
            }
            detailVC.dict = dict
            detailVC.name = (dict["name"] as? String)!
            detailVC.comID = (dict["committee_id"] as? String)!
            self.present(detailVC, animated: true, completion: nil)
        }
        else if tableView == table {
            table.deselectRow(at: indexPath, animated: true)
            switch indexPath.row {
            case 0:
                let legiVC = LegiViewController()
                self.present(legiVC, animated: true, completion: nil)
            case 1:
                let billVC = BillActViewController()
                self.present(billVC, animated: true, completion: nil)
            case 2:
                let comVC = ComSenateViewController()
                self.present(comVC, animated: true, completion: nil)
            case 3:
                let favVC = FavorViewController()
                self.present(favVC, animated: true, completion: nil)
            case 4:
                let aboutVC = AboutViewController()
                self.present(aboutVC, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
