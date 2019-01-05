//
//  ViewController.swift
//  Movies
//
//  Created by Admin on 1/2/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit
import SDWebImage

class HomeMoviesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    

    var searchActive : Bool = false
    var discoverArray : [Result] = []
    var searchArray : [SResult] = []
    var genresArray: [Genre] = []
    var casts: [Cast] = []
    var pageNum = 0
    var searchPage = 1
    //////////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.done
        getDataDiscover()
        requsetData(apirequest: UserServices.geners(), parameter: [:], decodingType: Geners.self) {
            (response) in
            print(response)
            self.genresArray = response.genres
            self.tableView.reloadData()
        }
        tableView.reloadData()
      
    }
    
    //////////////////////////////////////////////////////
    // method make request to get latest movie by date
    func getDataDiscover(){
        pageNum += 1
        requsetData(apirequest: UserServices.discover(page: pageNum), parameter: [:], decodingType: Discover.self) { (response) in
            print(response)
            for i in response.results{
                self.discoverArray.append(i)
            }
            self.tableView.reloadData()
        }
    }
    ///////////////////////////////////////////////////////////
     // method make request to get searched movie by text
    func getSearchedData(){
        self.searchArray = []
        self.tableView.reloadData()
        searchActive = true
        var searchWord = self.searchBar.text ?? ""
        requsetData(apirequest: UserServices.search(text: searchWord, page: searchPage), parameter: [:], decodingType: Search.self) { (response) in
            print(response)
            self.searchArray = response.results
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Search Bar Delegate Method
    /************************************/

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text == nil || self.searchBar.text == ""{
            searchActive = false
            self.searchBar.endEditing(true)
            self.tableView.reloadData()
        }
        else{
            getSearchedData()
        }
    }
    

    //MARK: - TableView Delegate Method
    /************************************/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMoviesTableViewCell") as! HomeMoviesTableViewCell

        if searchActive{
            if indexPath.row == searchArray.count - 1{
                searchPage += 1
                getSearchedData()
            }else{
                if searchArray.count != 0{
                    cell.imaveView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500"+"\(self.searchArray[indexPath.row].posterPath ?? "")"), placeholderImage: UIImage(named: "movie")) 
                    cell.MovieName.text = searchArray[indexPath.row].originalTitle
                    cell.MovieDescription.text = searchArray[indexPath.row].overview
                    var geners = ""
                    if searchArray[indexPath.row].genreIDS.count != 0{
                        for index in 0...searchArray[indexPath.row].genreIDS.count-1{
                            for j in 0..<genresArray.count  {
                                if searchArray[indexPath.row].genreIDS[index] == genresArray[j].id{
                                    geners += " \(genresArray[j].name) |"
                                }
                            }
                        }
                        cell.MovieGeners.text = geners
                    }
                }
            }
        }
        else{
            if indexPath.row == discoverArray.count - 1{
                getDataDiscover()
            }else{
                cell.imaveView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500"+"\(self.discoverArray[indexPath.row].posterPath ?? "")"), placeholderImage: UIImage(named: "movie"))
                cell.MovieName.text = discoverArray[indexPath.row].originalTitle
                cell.MovieDescription.text = discoverArray[indexPath.row].overview
                var geners = ""
               if discoverArray[indexPath.row].genreIDS.count != 0{
                    for index in 0...discoverArray[indexPath.row].genreIDS.count-1{
                        for j in 0..<genresArray.count  {
                            if discoverArray[indexPath.row].genreIDS[index] == genresArray[j].id{
                                geners += " \(genresArray[j].name) |"
                            }
                        }
                    }
                    cell.MovieGeners.text = geners
               }
            }
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoverArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let VC = mainStoryboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        if searchActive {
            if searchArray.count != 0{
                VC.movieId  = self.searchArray[indexPath.row].id
                VC.name = self.searchArray[indexPath.row].originalTitle
                VC.overView = self.searchArray[indexPath.row].overview
                var geners = ""
                if searchArray[indexPath.row].genreIDS.count != 0{
                    for index in 0...searchArray[indexPath.row].genreIDS.count-1{
                        for j in 0...genresArray.count - 1 {
                            if searchArray[indexPath.row].genreIDS[index] == genresArray[j].id{
                                geners += " \(genresArray[j].name) |"
                            }
                        }
                    }
                    VC.gener = geners
                }
                VC.pictureURL = "https://image.tmdb.org/t/p/w500"+"\(self.searchArray[indexPath.row].posterPath ?? "")"
                
            }

        }
        else{
            VC.movieId  = self.discoverArray[indexPath.row].id
            VC.name = self.discoverArray[indexPath.row].originalTitle
            VC.overView = self.discoverArray[indexPath.row].overview
            var geners = ""
            if discoverArray[indexPath.row].genreIDS.count != 0{
                for index in 0...discoverArray[indexPath.row].genreIDS.count-1{
                    for j in 0...genresArray.count - 1 {
                        if discoverArray[indexPath.row].genreIDS[index] == genresArray[j].id{
                            geners += " \(genresArray[j].name) |"
                        }
                    }
                }
                VC.gener = geners
            }
            VC.pictureURL = "https://image.tmdb.org/t/p/w500"+"\(self.discoverArray[indexPath.row].posterPath ?? "")"
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func favoritBtnPressed(_ sender: UIBarButtonItem) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = mainStoryboard.instantiateViewController(withIdentifier: "FavoritsViewController") as! FavoritsViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

@IBDesignable extension UINavigationController {
    @IBInspectable var barTintColor: UIColor? {
        set {
            navigationBar.barTintColor = newValue
        }
        get {
            guard  let color = navigationBar.barTintColor else { return nil }
            return color
        }
    }
    
    @IBInspectable var tintColor: UIColor? {
        set {
            navigationBar.tintColor = newValue
        }
        get {
            guard  let color = navigationBar.tintColor else { return nil }
            return color
        }
    }
    
    @IBInspectable var titleColor: UIColor? {
        set {
            guard let color = newValue else { return }
            navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: color]
        }
        get {
            return navigationBar.titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor
        }
    }
}
@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}


