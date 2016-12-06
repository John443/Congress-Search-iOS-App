//
//  ComTableViewCell.swift
//  Congress
//
//  Created by John Jiang on 2016/11/26.
//  Copyright © 2016 John Jiang. All rights reserved.
//

import UIKit

class ComTableViewCell: UITableViewCell {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
        self.title = UILabel(frame: CGRect(x: 10, y: 5, width: screenWidth, height: 20))
        self.title.font = UIFont(name: "Helvetica", size: 15)
        self.title.textAlignment = .left
        self.title.text = "XXXX"
        self.addSubview(title)
        
        self.subTitle = UILabel(frame: CGRect(x: 10, y: 26, width: 200, height: 10))
        self.subTitle.font = UIFont(name: "Helvetica", size: 13)
        self.subTitle.textAlignment = .left
        self.subTitle.text = "XXXX"
        self.addSubview(subTitle)
    }


}
