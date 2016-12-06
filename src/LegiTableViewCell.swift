//
//  LegiTableViewCell.swift
//  Congress
//
//  Created by John Jiang on 2016/11/23.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit

class LegiTableViewCell: UITableViewCell {

    var imageAvatar: UIImageView!
    var title: UILabel!
    var subTitle: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadItem() {
        self.imageAvatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.imageAvatar.contentMode = .scaleAspectFit
        self.addSubview(imageAvatar)
        
        self.title = UILabel(frame: CGRect(x: 60, y: 5, width: 200, height: 20))
        self.title.font = UIFont(name: "Helvetica", size: 15)
        self.title.textAlignment = .left
        self.title.text = "XXXX"
        self.addSubview(title)
        
        self.subTitle = UILabel(frame: CGRect(x: 60, y: 24, width: 200, height: 15))
        self.subTitle.font = UIFont(name: "Helvetica", size: 13)
        self.subTitle.textAlignment = .left
        self.subTitle.text = "XXXX"
        self.addSubview(subTitle)
    }
    
}
