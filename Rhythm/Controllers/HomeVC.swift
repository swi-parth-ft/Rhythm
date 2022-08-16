//
//  HomeVC.swift
//  Rhythm
//
//  Created by Vrushank on 2022-07-21.
//

import UIKit
import Firebase

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var usernameLabel: UILabel!
    
    let ref = Database.database().reference(withPath: "user")
    
    var users : [UserDetails] = [];
    //topTracksList array would have all top track list details
    var topTracksList:Summary = Summary()
    
    var biggestHitsTracksList:Summary = Summary()
    
    var newReleasesTracksList:Summary = Summary()
    
    var topSongsURL :String = "https://api.napster.com/v2.2/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=15"
    
    var biggestHitsURL :String = "https://api.napster.com/v2.2/genres/g.146/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=15"
    
    var newReleasesURL :String = "https://api.napster.com/v2.2/genres/g.71/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=15"
    
    @IBOutlet weak var topSongsCollectionView: UICollectionView!
    
    @IBOutlet weak var hitSongsCollectionView: UICollectionView!
    
    @IBOutlet weak var topArtistsCollectionView: UICollectionView!
    
    var songsArray = [UIImage(named: "weekend"),UIImage(named: "drake"),UIImage(named: "AnneMarie")]
    var songTitleArr = ["Blinding Lights","God's Plan","FRIENDS"]
    var artistNameArr = ["The Weekend","Drake","Anne-Marie"]

    private func animateCategoryView() {
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 400))
        containerView.backgroundColor = UIColor.white
        
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        topSongsCollectionView.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        topSongsCollectionView.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.topSongsCollectionView.transform = .identity
                self.topSongsCollectionView.alpha = 1
        })
        
        hitSongsCollectionView.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        hitSongsCollectionView.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0.8, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.hitSongsCollectionView.transform = .identity
                self.hitSongsCollectionView.alpha = 1
        })
        
        topArtistsCollectionView.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        topArtistsCollectionView.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 1.1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.topArtistsCollectionView.transform = .identity
                self.topArtistsCollectionView.alpha = 1
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        self.topSongsCollectionView.alpha = 0
        self.hitSongsCollectionView.alpha = 0
        self.topArtistsCollectionView.alpha = 0
        animateCategoryView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userEmail = NetworkingService.Shared.getUserEmail()
        
//        print("User Email: \(NetworkingService.Shared.getUserEmail())")
        
        
        for user in users{
            if user.email == userEmail{
                usernameLabel.text = "Hello, \(user.name)"
                print(user)
            }
        }
        
        getTopTracks()
        getBiggestHitsTracks()
        getNewReleasesTracks()
        
      
    }
    
    //MARK: - To get all top track details
    func getTopTracks() {
        //Networking service method would be called to get all top tracks
        NetworkingService.Shared.getTracksFromURL(url:topSongsURL) { result in
            switch result {
            case .success(let topTracks) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store Top tracks array to showResult array and reload the table
                    self.topTracksList = topTracks
//                    print(topTracksList.tracks![0])
                    self.topSongsCollectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getBiggestHitsTracks() {
       
        //Networking service method would be called to get all top tracks
        NetworkingService.Shared.getTracksFromURL(url:biggestHitsURL) { result in
            switch result {
            case .success(let biggestHitsTracks) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store Top tracks array to showResult array and reload the table
                    self.biggestHitsTracksList = biggestHitsTracks
//                    print(self.biggestHitsTracksList.tracks![0])
                    
                    self.hitSongsCollectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getNewReleasesTracks() {
       
        //Networking service method would be called to get all top tracks
        NetworkingService.Shared.getTracksFromURL(url:newReleasesURL) { result in
            switch result {
            case .success(let newReleasesTracks) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store Top tracks array to showResult array and reload the table
                    self.newReleasesTracksList = newReleasesTracks
//                    print(self.biggestHitsTracksList.tracks![0])
                    
                    self.topArtistsCollectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    
    
    //UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Number of items in topSongsCollectionView
        if (collectionView == self.topSongsCollectionView){
            return topTracksList.tracks!.count
        }
        else if(collectionView == self.hitSongsCollectionView){
            return biggestHitsTracksList.tracks!.count
        }else{
            return newReleasesTracksList.tracks!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Set Up cell for collectionViews
        if (collectionView == self.topSongsCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "songsCollectionVCell", for: indexPath) as! SongsCollectionVCell
            
            if(topTracksList.tracks![indexPath.row].albumId != ""){
                NetworkingService.Shared.getImage(albumId:topTracksList.tracks![indexPath.row].albumId!)
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
        
            cell.songTitle.text = "\(String(describing: topTracksList.tracks![indexPath.row].name!))"
                
            cell.artistName.text = "\(String(describing: topTracksList.tracks![indexPath.row].artistName!))"
            
            return cell
        }else if(collectionView == self.hitSongsCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hitSongsCollectionVCell", for: indexPath) as! SongsCollectionVCell
            
            
            if(biggestHitsTracksList.tracks![indexPath.row].albumId != ""){
                NetworkingService.Shared.getImage(albumId:biggestHitsTracksList.tracks![indexPath.row].albumId!)
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
        
            cell.songTitle.text = "\(String(describing: biggestHitsTracksList.tracks![indexPath.row].name!))"
                
            cell.artistName.text = "\(String(describing: biggestHitsTracksList.tracks![indexPath.row].artistName!))"
            
            return cell
        }else{
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topArtistsCollectionVCell", for: indexPath) as! SongsCollectionVCell
                
            if(newReleasesTracksList.tracks![indexPath.row].albumId != ""){
                NetworkingService.Shared.getImage(albumId:newReleasesTracksList.tracks![indexPath.row].albumId!)
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
        
            cell.songTitle.text = "\(String(describing: newReleasesTracksList.tracks![indexPath.row].name!))"
                
            cell.artistName.text = "\(String(describing: newReleasesTracksList.tracks![indexPath.row].artistName!))"
            
            return cell
        }
    }
    
    //    prepare before going to the now playing view and send the song track details for selected song row
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "topSongsToNowPlaying"){
                let showVC = segue.destination as! NowPlayingViewController
                
                let cell = sender as! UICollectionViewCell
                
                let CVPath = self.topSongsCollectionView!.indexPath(for: cell)!.item
                
                print("cv index: \(String(describing: CVPath))")
                
                showVC.tracksList = topTracksList
                showVC.currentTrackIndex = CVPath
                
                showVC.trackName = "\(String(describing: topTracksList.tracks![CVPath].name!))"
                    showVC.artistTitle = "\(String(describing: topTracksList.tracks![CVPath].artistName!))"
                    showVC.albumId = "\(String(describing: topTracksList.tracks![CVPath].albumId!))"
                    showVC.previewUrl = "\(String(describing: topTracksList.tracks![CVPath].previewURL!))"
                    showVC.id = "\(String(describing: topTracksList.tracks![CVPath].id!))"
            }
            else if(segue.identifier == "bigHitsToNowPlaying"){
                let showVC = segue.destination as! NowPlayingViewController
                
                let cell = sender as! UICollectionViewCell
                
                let CVPath = self.hitSongsCollectionView!.indexPath(for: cell)!.item
                print("cv index: \(String(describing: CVPath))")
                
                showVC.tracksList = biggestHitsTracksList
                showVC.currentTrackIndex = CVPath
                showVC.trackName = "\(String(describing: biggestHitsTracksList.tracks![CVPath].name!))"
                showVC.artistTitle = "\(String(describing: biggestHitsTracksList.tracks![CVPath].artistName!))"
                showVC.albumId = "\(String(describing: biggestHitsTracksList.tracks![CVPath].albumId!))"
                showVC.previewUrl = "\(String(describing: biggestHitsTracksList.tracks![CVPath].previewURL!))"
                showVC.id = "\(String(describing: biggestHitsTracksList.tracks![CVPath].id!))"
            }
            else if(segue.identifier == "newReleasesToNowPlaying"){
                let showVC = segue.destination as! NowPlayingViewController
                
                let cell = sender as! UICollectionViewCell
                
                let CVPath = self.topArtistsCollectionView!.indexPath(for: cell)!.item
                print("cv index: \(String(describing: CVPath))")
                
                showVC.tracksList = newReleasesTracksList
                showVC.currentTrackIndex = CVPath
                showVC.trackName = "\(String(describing: newReleasesTracksList.tracks![CVPath].name!))"
                showVC.artistTitle = "\(String(describing: newReleasesTracksList.tracks![CVPath].artistName!))"
                showVC.albumId = "\(String(describing: newReleasesTracksList.tracks![CVPath].albumId!))"
                showVC.previewUrl = "\(String(describing: newReleasesTracksList.tracks![CVPath].previewURL!))"
                showVC.id = "\(String(describing: newReleasesTracksList.tracks![CVPath].id!))"
            }
            else if(segue.identifier == "TopSongsToTracksList"){
                let tracksListVC = segue.destination as! TopSongsViewController
                tracksListVC.storyboardTitle = "Top Songs"
                tracksListVC.APIURL = "https://api.napster.com/v2.2/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50"
            }
            else if(segue.identifier == "bigHitsToTracksList"){
                let tracksListVC = segue.destination as! TopSongsViewController
                tracksListVC.storyboardTitle = "Biggest Hits"
                tracksListVC.APIURL = "https://api.napster.com/v2.2/genres/g.146/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50"
            }else if(segue.identifier == "newReleasesToTracksList"){
                let tracksListVC = segue.destination as! TopSongsViewController
                tracksListVC.storyboardTitle = "New Releases"
                tracksListVC.APIURL = "https://api.napster.com/v2.2/genres/g.71/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50"
            }
            
        }

}
