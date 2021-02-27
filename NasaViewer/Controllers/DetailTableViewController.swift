//
//  MainTableViewController.swift
//  NasaViewer
//
//  Created by Кирилл Дутов on 27.02.2021.
//

import UIKit
import SwiftyJSON
import SDWebImage

class DetailTableViewController: UIViewController {
    
    // MARK: - Set labels and outlets
    
    var textViewText: String!
    var dataCreatedText: String!
    var titleText: String!
    
    var imageURL: String!
    var photographerText: String!
    var locationText: String!
    
    var nasaIDText: String!
    var centerText: String!
    var keywordsTextArray: [String]!
    
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailDataCreatedLabel: UILabel!
    
    @IBOutlet weak var detailNASAIdLabel: UILabel!
    @IBOutlet weak var detailPhotographerLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    
    @IBOutlet weak var detailDescriptionTextView: UITextView!
    @IBOutlet weak var centerTextLabel: UILabel!
    @IBOutlet weak var keywordsTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setShadowForImageView()
        
        receiveDataForTitle()
        receiveDataForDataCreated()
        receiveDataForNasaId()
        receiveDataForPhotographer()
        receiveDataForDescription()
        receiveDataForCenter()
        receiveDataForKeywords()
        receiveDataForLocation()
        
        receiveDataForDetailImage()
    }
    
    // MARK: - Set image shadow
    
    fileprivate func setShadowForImageView() {
        
        detailImageView.clipsToBounds = false
        detailImageView.layer.shadowColor = UIColor.black.cgColor
        detailImageView.layer.shadowOpacity = 1
        
        detailImageView.layer.shadowOffset = CGSize.zero
        detailImageView.layer.shadowRadius = 10
        detailImageView.layer.shadowPath = UIBezierPath(roundedRect: detailImageView.bounds, cornerRadius: 10).cgPath
    }
    
    // MARK: - Receive data and logic
    
    func receiveDataForTitle() {
        guard let detailTitleLabel = detailTitleLabel else {return}
        
        detailTitleLabel.text = titleText
    }
    
    func receiveDataForDataCreated() {
        guard let detailDataCreatedLabel = detailDataCreatedLabel else {
            print("detailDataCreatedLabel failed guard verification")
            return
        }
        
        if dataCreatedText == "" {
            detailDataCreatedLabel.text = "Date of created: n/a"
        } else {
            detailDataCreatedLabel.text = "Date of created: " + dataCreatedText
        }
    }
    
    func receiveDataForNasaId() {
        guard let detailNASAIdLabel = detailNASAIdLabel else {
            print("detailNASAIdLabel failed guard verification")
            return
        }
        
        if nasaIDText == "" {
            detailNASAIdLabel.text = "NASA ID: n/a"
        } else {
            detailNASAIdLabel.text = "NASA ID: " + nasaIDText
        }
    }
    
    func receiveDataForPhotographer() {
        guard let detailPhotographerLabel = detailPhotographerLabel else {
            print("detailPhotographerLabel failed guard verification")
            return
        }
        
        if photographerText == "" {
            detailPhotographerLabel.text = "Photo by: n/a"
        } else {
            detailPhotographerLabel.text = "Photo by: " + photographerText
        }
    }
    
    func receiveDataForDescription() {
        guard let detailDescriptionTextView = detailDescriptionTextView else { print("detailDescriptionTextView failed guard verification")
            return
        }
        
        if textViewText == "" {
            detailDescriptionTextView.text = "Description for the photo is not provided by the photographer."
        } else {
            detailDescriptionTextView.text = textViewText
        }
    }
    
    func receiveDataForLocation() {
        guard let detailLocationLabel = detailLocationLabel else {
            print("detailLocationLabel failed guard verification")
            return
        }
        
        if locationText == "" {
            detailLocationLabel.text = "Location: n/a"
        } else {
            detailLocationLabel.text = "Location: " + locationText
        }
    }
    
    func receiveDataForCenter() {
        guard let centerTextLabel = centerTextLabel else {
            print("centerTextLabel failed guard verification")
            return
        }
        
        if centerText == "" {
            centerTextLabel.text = "Center: n/a"
        } else {
            centerTextLabel.text = "Center: " + centerText
        }
    }
    
    func receiveDataForKeywords() {
        guard let keywordsTextLabel = keywordsTextLabel else {
            print("keywordsTextLabel failed guard verification")
            return
        }
        
        if keywordsTextArray == [""] {
            keywordsTextLabel.text = "Keywords: n/a"
        } else {
            keywordsTextLabel.text = "Keywords: " + keywordsTextArray.joined(separator:" ")
        }
    }
    
    func receiveDataForDetailImage() {
        self.detailImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder.png"), options: SDWebImageOptions(), completed: { (image, error, cacheType, imageURL) -> Void in
            print("loaded")
        })
    }
}

