//
//  PhotoCell.swift
//  ImageList
//
//  Created by Sankaranarayana Settyvari on 01/07/20.
//  Copyright © 2020 Sankaranarayana Settyvari. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    var photo:Photo? {
        didSet {
            guard let photoItem = photo else {return}
            if let urlString = photoItem.imageURL {
                
                let url = URL(string: urlString as String)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        if(data != nil)
                        {
                            self.profileImageView.image = UIImage(data: data!)
                        }
                        else
                        {
                            self.profileImageView.image = UIImage(named: "No_image")
                        }
                    }
                }
            }
            if let title = photoItem.title {
                titleLabel.text = " \(title) "
            }
            
            if let description = photoItem.titleDescription {
                descriptionLabel.text = " \(description) "
            }
            
        }
    }
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 25
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor =  .black
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = self.contentView.layoutMarginsGuide
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
    profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        //set your cell's state to default here
        
        self.profileImageView.image =  nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }
}
