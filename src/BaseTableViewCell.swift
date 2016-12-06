//
//  BaseTableViewCell.swift
//  Congress
//
//  Created by John Jiang on 2016/11/25.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var title: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadCellContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCellContent() {
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        self.title = UILabel(frame: CGRect(x: 30, y: 10, width: 200, height: 20))
        self.title.font = UIFont(name: "Helvetica-Oblique", size: 15)
        self.title.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
        self.title.textAlignment = .left
        self.title.textColor = UIColor.gray
        self.title.text = "XXXX"
        self.addSubview(title)
    }
    
}
