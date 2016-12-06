//
//  ComDetailCell.swift
//  Congress
//
//  Created by John Jiang on 2016/11/27.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit

class ComDetailCell: UITableViewCell {

    var title: UILabel!
    var detail: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadItem()
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

}
