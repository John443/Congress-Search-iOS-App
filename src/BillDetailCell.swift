//
//  BillDetailCell.swift
//  Congress
//
//  Created by John Jiang on 2016/11/27.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit

class BillDetailCell: UITableViewCell {

    var title: UILabel!
    var detail: UILabel!
    var pdf: UIButton!
    
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
        
        self.pdf = UIButton(frame: CGRect(x: 100, y: 20, width: 150, height: 10))
        self.pdf.setTitle("PDF Link", for: .normal)
        self.pdf.setTitleColor(UIColor.init(red: 52 / 255.0, green: 152 / 255.0, blue: 219 / 255.0, alpha: 1.0), for: .normal)
        self.pdf.addTarget(self, action: #selector(self.link(_:)), for: .touchUpInside)
        if self.title.text == "PDF" && self.detail.text != "N.A." {
            self.addSubview(pdf)
            self.detail.isHidden = true
        }
        else {
            self.pdf.isHidden = true
        }
        
    }
    
    func link(_ sender: UIButton) {
        let url = URL(string: detail.text!)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }


}
