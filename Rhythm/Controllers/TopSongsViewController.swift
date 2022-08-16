//
//  TopSongsViewController.swift
//  Rhythm
//
//  Created by Parth Antala on 2022-07-22.
//

import UIKit

class TopSongsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    //topTracksList array would have all top track list details
    var topTracksList:Summary = Summary()
    
    @IBOutlet weak var sufflePlayView: UIView!
    @IBOutlet weak var songCount: UILabel!
    @IBOutlet weak var topSongsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var storyboardTitle: String? = "Top Songs"
    var APIURL: String? = "https://api.napster.com/v2.2/tracks/top?apikey=YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4&limit=50"
    
//    var songsArray = [UIImage(named: "weekend"),UIImage(named: "drake"),UIImage(named: "AnneMarie")]
//    var songTitleArr = ["Blinding Lights","God's Plan","FRIENDS"]
//    var artistNameArr = ["The Weekend","Drake","Anne-Marie"]
    
    
    private func animateTopSingsLabel() {
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 400))
        containerView.backgroundColor = UIColor.white
        let offset = CGPoint(x: 0, y: -containerView.frame.maxY)
        let x: CGFloat = 0, y: CGFloat = 0
        topSongsLabel.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        topSongsLabel.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.topSongsLabel.transform = .identity
                self.topSongsLabel.alpha = 1
        })
        
        topSongsLabel.alpha = 0
        topSongsLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 2, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.topSongsLabel.transform = .identity
                self.topSongsLabel.alpha = 1
        }, completion: nil)
        
        songCount.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        songCount.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.songCount.transform = .identity
                self.songCount.alpha = 1
        })
        
        songCount.alpha = 0
        songCount.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 2, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.songCount.transform = .identity
                self.songCount.alpha = 1
        }, completion: nil)
        
        
        
    }
    
    private func animateSufflePlayImage(){
        sufflePlayView.alpha = 0
        sufflePlayView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 2, delay: 0.5, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.sufflePlayView.transform = .identity
                self.sufflePlayView.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topSongsLabel.text = storyboardTitle
        
        getTopTracks()
        
        songCount.text  =  "\(topTracksList.tracks!.count) Songs"
        // Do any additional setup after loading the view.
    }
    
    //To get all top track details
    func getTopTracks() {
        
        //Networking service method would be called to get all top tracks
        NetworkingService.Shared.getTracksFromURL(url: APIURL!) { result in
            switch result {
            case .success(let topTracks) :
                
                //main thread
                DispatchQueue.main.async {
                    //Store Top tracks array to showResult array and reload the table
                    self.topTracksList = topTracks
//                    print(topTracksList.tracks![0])
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        animateTopSingsLabel()
        animateSufflePlayImage()
    }

    //Table Properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        songsArray.count
        return topTracksList.tracks!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topSongsTableViewCell", for: indexPath) as! TopSongsTableViewCell
        
//        cell.songImage.image = songsArray[indexPath.row]
//        cell.songImage.image = UIImage(named: "weekend")
        
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    // MARK: - Navigation

     //prepare before going to the now playing view and send the song track details for selected song row
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toNowPlaying"){
            let showVC = segue.destination as! NowPlayingViewController
            
            showVC.tracksList = topTracksList
            showVC.currentTrackIndex = tableView.indexPathForSelectedRow!.row
            showVC.trackName = "\(String(describing: topTracksList.tracks![tableView.indexPathForSelectedRow!.row].name!))"
            showVC.artistTitle = "\(String(describing: topTracksList.tracks![tableView.indexPathForSelectedRow!.row].artistName!))"
            showVC.albumId = "\(String(describing: topTracksList.tracks![tableView.indexPathForSelectedRow!.row].albumId!))"
            showVC.previewUrl = "\(String(describing: topTracksList.tracks![tableView.indexPathForSelectedRow!.row].previewURL!))"
            showVC.id = "\(String(describing: topTracksList.tracks![tableView.indexPathForSelectedRow!.row].id!))"
            
        }
    }

}
