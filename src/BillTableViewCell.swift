//
//  LegiTableViewCell.swift
//  Congress
//
//  Created by John Jiang on 2016/11/23.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    
    var id: UILabel!
    var title: UILabel!
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadItem() {
        
        self.id = UILabel(frame: CGRect(x: 10, y: 10, width: screenWidth - 20, height: 20))
        self.id.font = UIFont(name: "Helvetica-Bold", size: 15)
        self.id.textAlignment = .left
        self.id.numberOfLines = 0
        self.id.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.id.text = "XXXX"
        self.addSubview(id)
        self.id.layer.zPosition = 11
        
        self.title = UILabel(frame: CGRect(x: 10, y: 20, width: screenWidth - 20, height: 80))
        self.title.font = UIFont(name: "Helvetica", size: 15)
        self.title.textAlignment = .left
        self.title.numberOfLines = 0
        self.title.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.title.text = "XXXX"
        self.addSubview(title)
    }
    
}
