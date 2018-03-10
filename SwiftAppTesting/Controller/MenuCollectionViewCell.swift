//
//  MenuCollectionViewCell.swift
//  SwiftAppTesting
//
//  Created by MMDC on 10/03/18.
//  Copyright © 2018 Muh.Yusuf. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    lazy var countItemLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0,
                             width: contentView.frame.size.width,
                             height: contentView.frame.size.height);
        label.font = UIFont.systemFont(ofSize: 16);
        label.textColor = .black;
        label.textAlignment = .center;
        contentView.addSubview(label)
        return label
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 10, y: 1,
                            width: contentView.frame.size.width - 20,
                            height: contentView.frame.size.height - 2)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        contentView.addSubview(view)
        return view
    }()
    
}
