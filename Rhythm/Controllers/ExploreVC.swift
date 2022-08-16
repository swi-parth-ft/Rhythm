//
//  ExploreVC.swift
//  Rhythm
//
//  Created by Vrushank on 2022-07-22.
//

import UIKit

class ExploreVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var GenreList:Genre = Genre()
    
    var albumsList:Albums = Albums()
    
    var fetchAlbumsURL:String = "https://api.napster.com/v2.2/albums/new?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=15"
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    //Genres Collection
    
    var genresBackgroundImageArray = [UIImage(named: "rectangle123"),UIImage(named: "rectangle125"),UIImage(named: "rectangle124")]
    
    var genres = ["Hip-Hop","Dance / Electronic","Pop"]
    
    
    //Albums Collection
    
    var albumsArray = [UIImage(named: "weekend"),UIImage(named: "drake"),UIImage(named: "AnneMarie")]
    var albumsTitleArr = ["Blinding Lights","God's Plan","FRIENDS"]
    var albumsArtistNameArr = ["The Weekend","Drake","Anne-Marie"]
    
    private func animateCategoryView() {
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 400))
        containerView.backgroundColor = UIColor.white
        
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        genresCollectionView.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        genresCollectionView.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.genresCollectionView.transform = .identity
                self.genresCollectionView.alpha = 1
        })
        
        albumsCollectionView.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        albumsCollectionView.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0.8, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.albumsCollectionView.transform = .identity
                self.albumsCollectionView.alpha = 1
        })
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        self.genresCollectionView.alpha = 0
        self.albumsCollectionView.alpha = 0
        animateCategoryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGenres()
        getNewAlbums()
        
        searchBar.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "searchIcon")
        imageView.image = image
        searchBar.leftView = imageView
    }
    
    //MARK: - To get all genres details
    func getGenres() {
        //Networking service method would be called to get all top tracks
        NetworkingService.Shared.getGenresFromURL() { result in
            switch result {
            case .success(let genres) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store  Genres array to showResult array and reload the collection
                    self.GenreList = genres
//                    print(topTracksList.tracks![0])
                    self.genresCollectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    
    //MARK: - To get all new albums details
    func getNewAlbums() {
        //Networking service method would be called to get all top tracks
        NetworkingService.Shared.getAlbumsFromURL(url:fetchAlbumsURL) { result in
            switch result {
            case .success(let albums) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store  Genres array to showResult array and reload the collection
                    self.albumsList = albums
//                    print(topTracksList.tracks![0])
                    self.albumsCollectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    
    //UICollection Properties
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Number of items in genresCollectionView
        if (collectionView == self.genresCollectionView){
            return GenreList.genres!.count
        }
        else{ //Number of items in albumsCollectionView
            return albumsList.albums!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Set up cell for  genresCollectionView
        if(collectionView == self.genresCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genresCollection", for: indexPath) as! genresCollectionViewCell
            
            cell.bImage.image = genresBackgroundImageArray[Int.random(in:0...2)]
            
            cell.genreLabel.text = "\(String(describing: GenreList.genres![indexPath.row].name!))"
            
            return cell
        }
        else{ //Set up cell for albumsCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumsCollectionVCell", for: indexPath) as! SongsCollectionVCell
            
//            cell.songImage.image = albumsArray[indexPath.row]
//
//            cell.songTitle.text = "\(albumsTitleArr[indexPath.row])"
//
//            cell.artistName.text = "\(albumsArtistNameArr[indexPath.row])"
            
            if(albumsList.albums![indexPath.row].id != ""){
                NetworkingService.Shared.getImage(albumId:albumsList.albums![indexPath.row].id!)
                {
                    result in
                    switch result{
                    case .success(let imageFromURL):
                        DispatchQueue.main.async{
                            cell.songImage.image = imageFromURL
                        }
                        break
                    case .failure(_):
                        break
                    }
                    
                }
            }else{
                cell.songImage.image = UIImage(named: "weekend")
            }
        
            cell.songTitle.text = "\(String(describing: albumsList.albums![indexPath.row].name!))"
                
            cell.artistName.text = "\(String(describing: albumsList.albums![indexPath.row].artistName!))"
            
            return cell
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "newAlbumsToTracksList"){
            let tracksListVC = segue.destination as! TopSongsViewController
            let cell = sender as! UICollectionViewCell
            
            let CVPath = self.albumsCollectionView!.indexPath(for: cell)!.item
           
            tracksListVC.storyboardTitle = albumsList.albums![CVPath].name!
            tracksListVC.APIURL = "https://api.napster.com/v2.2/albums/\(albumsList.albums![CVPath].id!)/tracks?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4"
        }
        else if(segue.identifier == "genresToTracksList"){
            let tracksListVC = segue.destination as! TopSongsViewController
            let cell = sender as! UICollectionViewCell
            
            let CVPath = self.genresCollectionView!.indexPath(for: cell)!.item
           
            tracksListVC.storyboardTitle = "\(GenreList.genres![CVPath].name!) Songs"
            tracksListVC.APIURL = "https://api.napster.com/v2.2/genres/\(GenreList.genres![CVPath].id!)/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50"
        }
        else if(segue.identifier == "displayMoreAlbumsToTracksList"){
            let tracksListVC = segue.destination as! TopSongsViewController
           
            tracksListVC.storyboardTitle = "New albums and singles"
            tracksListVC.APIURL = "https://api.napster.com/v2.2/albums/new?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50"
        }
    }
}
