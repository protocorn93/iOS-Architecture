//
//  PhotoListTableViewCell.swift
//  MVVM
//
//  Created by 이동건 on 29/06/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setupViews(viewModel: PhotoListCellViewModel) {
        nameLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descText
        dateLabel.text = viewModel.dateText
        mainImageView.sd_setImage(with: URL(string: viewModel.imageUrl), completed: nil
        )
    }
}
