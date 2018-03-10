//
//  MenuViewController.swift
//  SwiftAppTesting
//
//  Created by MMDC on 10/03/18.
//  Copyright © 2018 Muh.Yusuf. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    var isAlpha = true
    
    lazy private var backButton: UIButton = {
        let button = UIButton()
        return button
    }()
    lazy private var topImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    lazy private var alphaButton: UIButton = {
        let button = UIButton()
        return button
    }()
    lazy private var betaButton: UIButton = {
        let button = UIButton()
        return button
    }()
    lazy private var separatorView: UIView = {
        let view = UIView()
        return view
    }()
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setCollectionView()
    }

}

// MARK: Private

private extension MenuViewController {
    func initViews() {
        let screenSize = UIScreen.main.bounds
        topImage.frame = CGRect(x: 0 ,y: 0, width: screenSize.width, height: 110)
        topImage.image = UIImage(named: "bg")
        view.addSubview(topImage)
        
        separatorView.frame = CGRect(x: 0 ,y: 103, width: screenSize.width/2, height: 3)
        separatorView.backgroundColor = .white
        view.addSubview(separatorView)
        
        backButton.frame = CGRect(x: 30 ,y: 20, width: 30, height: 30)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(onBackClicked), for: .touchUpInside)
        
        alphaButton.frame = CGRect(x: 0 ,y: 60, width: screenSize.width/2, height: 50)
        alphaButton.setTitle("TAB ALPHA", for: .normal)
        view.addSubview(alphaButton)
        alphaButton.addTarget(self, action: #selector(onAlphaClicked), for: .touchUpInside)
        
        betaButton.frame = CGRect(x: screenSize.width/2 ,
                                  y: 60, width: screenSize.width/2, height: 50)
        betaButton.setTitle("TAB BETA", for: .normal)
        view.addSubview(betaButton)
        betaButton.addTarget(self, action: #selector(onBetaClicked), for: .touchUpInside)
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let screenSize = UIScreen.main.bounds
        collectionView = UICollectionView(frame: CGRect(x: 0, y:110,
                                                              width: screenSize.width,
                                                              height: screenSize.height - 110),
                                          collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuCollectionViewCell.self,
                                forCellWithReuseIdentifier: "menuItemCellIdentifier")
        collectionView.backgroundColor = .groupTableViewBackground
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
    }
    
    @objc func onBackClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onAlphaClicked() {
        let screenSize = UIScreen.main.bounds
        isAlpha = true
        collectionView.reloadData()
        UIView.animate(withDuration: 0.33) {
            self.separatorView.frame = CGRect(x: 0 ,y: 103, width: screenSize.width/2, height: 3)
        }
    }
    
    @objc func onBetaClicked() {
        let screenSize = UIScreen.main.bounds
        isAlpha = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.33) {
            self.separatorView.frame = CGRect(x:screenSize.width/2  ,y: 103,
                                              width: screenSize.width/2, height: 3)
        }
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "menuItemCellIdentifier", for: indexPath) as! MenuCollectionViewCell
        cell.backgroundColor = .groupTableViewBackground
        if isAlpha == true {
            cell.countItemLabel.text = "Alpha \(indexPath.row)"
        } else {
            cell.countItemLabel.text = "Beta \(indexPath.row)"
        }
        return cell;
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width;
        let cellWidth = screenWidth / 3.0;
        return CGSize(width:cellWidth - 10, height: cellWidth)
    }
}
