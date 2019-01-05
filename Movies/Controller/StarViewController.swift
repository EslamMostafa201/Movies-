//
//  StarViewController.swift
//  Movies
//
//  Created by BRANDS BOOM on 1/4/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit

class StarViewController: UIViewController {
    @IBOutlet weak var starNameLabel: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var starBiography: UILabel!
    @IBOutlet weak var birthDayLabel: UILabel!
    @IBOutlet weak var placeOfBirth: UILabel!
    var starID : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = .white

        print(starID)
        // make request to get star details by id
        requsetData(apirequest: UserServices.people(id: self.starID), parameter: [:], decodingType: People.self) {
            (response) in
            print(response)
            self.starImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500"+"\(String(describing: response.profilePath ?? ""))"), placeholderImage: UIImage(named: "movie"))
            self.starNameLabel.text = response.name
            self.starBiography.text = response.biography
            self.birthDayLabel.text = "BirthDay : "+"\(response.birthday ?? "")"
            self.placeOfBirth.text = "Place Of Birth : "+"\(response.placeOfBirth ?? "")"
        }

        // Do any additional setup after loading the view.
    }
    

}
