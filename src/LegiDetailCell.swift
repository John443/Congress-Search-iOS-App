//
//  detailCell.swift
//  Congress
//
//  Created by John Jiang on 2016/11/27.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit

class LegiDetailCell: UITableViewCell {

    var title: UILabel!
    var detail: UILabel!
    var facebook: UIButton!
    var twitter: UIButton!
    var website: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadItem()
        loadButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadItem() {
        
        self.title = UILabel(frame: CGRect(x: 15, y: 15, width: 105, height: 20))
        self.title.font = UIFont(name: "Helvetica", size: 15)
        self.title.textAlignment = .left
        self.addSubview(title)
        
        self.detail = UILabel(frame: CGRect(x: 120, y: 15, width: 300, height: 20))
        self.detail.font = UIFont(name: "Helvetica", size: 15)
        self.detail.textAlignment = .left
        self.addSubview(detail)
        
    }
    
    func loadButton() {
        
        self.facebook = UIButton(frame: CGRect(x: 110, y: 20, width: 150, height: 10))
        self.facebook.setTitle("Facebook Link", for: .normal)
        self.facebook.setTitleColor(UIColor.init(red: 52 / 255.0, green: 152 / 255.0, blue: 219 / 255.0, alpha: 1.0), for: .normal)
        self.facebook.addTarget(self, action: #selector(self.link(_:)), for: .touchUpInside)
        if self.title.text == "Facebook" && self.detail.text != "N.A." {
            self.addSubview(facebook)
            self.twitter.isHidden = true
            self.website.isHidden = true
            self.detail.isHidden = true
        }
        else {
            self.facebook.isHidden = true
        }
        
        self.twitter = UIButton(frame: CGRect(x: 100, y: 20, width: 150, height: 10))
        self.twitter.setTitle("Twitter Link", for: .normal)
        self.twitter.setTitleColor(UIColor.init(red: 52 / 255.0, green: 152 / 255.0, blue: 219 / 255.0, alpha: 1.0), for: .normal)
        self.twitter.addTarget(self, action: #selector(self.link(_:)), for: .touchUpInside)
        if self.title.text == "Twitter" && self.detail.text != "N.A." {
            self.addSubview(twitter)
            self.facebook.isHidden = true
            self.website.isHidden = true
            self.detail.isHidden = true
        }
        else {
            self.twitter.isHidden = true
        }
        
        self.website = UIButton(frame: CGRect(x: 100, y: 20, width: 150, height: 10))
        self.website.setTitle("Website Link", for: .normal)
        self.website.setTitleColor(UIColor.init(red: 52 / 255.0, green: 152 / 255.0, blue: 219 / 255.0, alpha: 1.0), for: .normal)
        self.website.addTarget(self, action: #selector(self.link(_:)), for: .touchUpInside)
        if self.title.text == "Website" && self.detail.text != "N.A." {
            self.addSubview(website)
            self.facebook.isHidden = true
            self.twitter.isHidden = true
            self.detail.isHidden = true
        }
        else {
            self.website.isHidden = true
        }
    }
    
    func link(_ sender: UIButton) {
        let url = URL(string: detail.text!)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}
