//
//  OptionCell.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OptionCell: UITableViewCell {
    
    var optionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var iconImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        return imageView
    }()
    
    private var disposeBag: DisposeBag? = DisposeBag()
    
    var viewModel:OptionCellModel? {
        didSet{
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            optionLabel.text = viewModel.optionName
            iconImage.image = UIImage(named: viewModel.icon)
            self.contentView.backgroundColor = (viewModel.isDisabled) ? UIColor.lightGray : .white
            self.isUserInteractionEnabled = (viewModel.isDisabled) ? false : true
            self.accessoryType = (viewModel.isSelected) ? .checkmark : .none
            
            self.disposeBag = disposeBag
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(optionLabel)
        contentView.addSubview(iconImage)
        NSLayoutConstraint.activate(
            [optionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
             iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
             iconImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
             iconImage.widthAnchor.constraint(equalToConstant: 40),
             iconImage.heightAnchor.constraint(equalToConstant: 40),
             optionLabel.leftAnchor.constraint(equalTo: iconImage.rightAnchor, constant: 20),
             optionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        viewModel = nil
        disposeBag = nil
    }
}
