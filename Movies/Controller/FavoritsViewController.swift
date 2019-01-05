//
//  FavoritsViewController.swift
//  Movies
//
//  Created by Admin on 1/2/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import UIKit
import RealmSwift
class FavoritsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoritData : [MovieModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        let realm = try! Realm()
        let result = realm.objects(MovieModel.self)
        favoritData = Array(result)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView Delegate Method
    /************************************/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMoviesTableViewCell") as! HomeMoviesTableViewCell
        cell.MovieName.text = favoritData[indexPath.row].name
        cell.MovieDescription.text = favoritData[indexPath.row].overView
        cell.MovieGeners.text = favoritData[indexPath.row].geners
        cell.imaveView.sd_setImage(with: URL(string: favoritData[indexPath.row].picture), placeholderImage: UIImage(named: "movie"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // delete from realm
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        var obj : MovieModel = MovieModel()
        obj = favoritData[indexPath.row]
        try! realm.write {
            realm.delete(obj)
        }
        let result = realm.objects(MovieModel.self)
        favoritData = Array(result)
        self.tableView.reloadData()
    }
}
