//
//  DetailsViewController.swift
//  Movies
//
//  Created by Admin on 1/2/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
class DetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var addToFavoritActivate: UIButton!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieGeners: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    @IBOutlet weak var similarCollectionView: UICollectionView!
     var pageNum = 0
    var similarArray : [SimilarResult] = []
    var name : String = ""
    var overView : String = ""
    var gener: String = ""
    var cast : [String] = []
    var castID : [Int] = []
    var casts: [Cast] = []
    var pictureURL = ""
    var movieId = 0
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        let result = realm.objects(MovieModel.self).filter("id = '\(movieId)' ")
        if result.isEmpty{
            self.addToFavoritActivate.isEnabled = true
            self.addToFavoritActivate.backgroundColor = UIColor(red: 164/255, green: 19/255, blue: 25/255, alpha: 1)
            self.addToFavoritActivate.setTitle("Add To Favorit", for: .normal)
        }
        else{
            self.addToFavoritActivate.isEnabled = false
            self.addToFavoritActivate.backgroundColor = .gray
            self.addToFavoritActivate.setTitle("Added", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = .white
        
        
        // method make request to get cast names of movie by movie id
        requsetData(apirequest: UserServices.moviecast(id: movieId), parameter: [:], decodingType: MovieCast.self) {
            (response) in
            print(response)
            self.casts = response.cast
            for item in 0..<self.casts.count{
                self.cast.append(self.casts[item].name)
                self.castID.append(self.casts[item].id)
                    }
            self.castCollectionView.reloadData()
        }
        
        // method make request to get similar movies of movie by movie id
        pageNum += 1
        requsetData(apirequest: UserServices.similarMovie(id: movieId, page: pageNum), parameter: [:], decodingType: SimilarMovie.self) {
            (response) in
            print(response)
            for i in response.results{
                self.similarArray.append(i)
            }
            self.similarCollectionView.reloadData()

        }
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        movieName.text = self.name
        movieGeners.text = gener
        
        movieDescription.text = self.overView
        
        movieImage.sd_setImage(with: URL(string: self.pictureURL), placeholderImage: UIImage(named: "movie"))
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // check movie in favorites or not
        let realm = try! Realm()
        let result = realm.objects(MovieModel.self).filter("id = '\(movieId)' ")
        if result.isEmpty{
            self.addToFavoritActivate.isEnabled = true
            self.addToFavoritActivate.backgroundColor = UIColor(red: 164/255, green: 19/255, blue: 25/255, alpha: 1)
            self.addToFavoritActivate.setTitle("Add To Favorit", for: .normal)
        }
        else{
            self.addToFavoritActivate.isEnabled = false
            self.addToFavoritActivate.backgroundColor = .gray
            self.addToFavoritActivate.setTitle("Added", for: .normal)
        }

    }
    
    //MARK: - CollectionView Delegate Method
    /*****************************************/
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case castCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCollectionViewCell", for: indexPath) as! DetailsCollectionViewCell
            cell.StarNameLabel.text = cast[indexPath.row]
               return cell
        case similarCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCollectionViewCell", for: indexPath) as! similarCollectionViewCell
            cell.movieName.text = similarArray[indexPath.row].originalTitle
            cell.movieImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500"+"\(self.similarArray[indexPath.row].posterPath ?? "")"), placeholderImage: UIImage(named: "movie"))
               return cell
        default:
            return UICollectionViewCell()
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case castCollectionView:
            return cast.count
        case similarCollectionView:
            return similarArray.count
        default:
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case castCollectionView:
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = mainStoryboard.instantiateViewController(withIdentifier: "StarViewController") as! StarViewController
            VC.starID = self.castID[indexPath.row]
            self.navigationController?.pushViewController(VC, animated: true)
        default:
            break
        }
        


    }
    @IBAction func favoritPressed(_ sender: UIBarButtonItem) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = mainStoryboard.instantiateViewController(withIdentifier: "FavoritsViewController") as! FavoritsViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    @IBAction func addFavoritPressed(_ sender: UIButton) {
        let movieObjc = MovieModel()
        movieObjc.id = "\(self.movieId)"
        movieObjc.name = self.name
        movieObjc.overView = self.overView
        movieObjc.geners = self.gener
        movieObjc.picture = self.pictureURL
        self.createItem(obj: movieObjc)
        self.addToFavoritActivate.isEnabled = false
        self.addToFavoritActivate.backgroundColor = .gray
        self.addToFavoritActivate.setTitle("Added", for: .normal)
    }
    // MARK: - Realm
    /***************/
    // metho for creat to add in realm
    func createItem(obj : MovieModel){
        let realm = try! Realm()
        try! realm.write{
            realm.add(obj)
        print(obj.id)
        }
    }
}
