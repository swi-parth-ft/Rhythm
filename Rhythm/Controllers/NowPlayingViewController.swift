//
//  NowPlayingViewController.swift
//  Rhythm
//
//  Created by Parth Antala on 2022-07-22.
//

import UIKit
import AVFoundation
import MediaPlayer

class NowPlayingViewController: UIViewController {
    
    var tracksList:Summary = Summary()
    
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var playerControlView: UIStackView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var suffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var playerController: UIButton!
    
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentPlayerTime: UILabel!
    
    var currentTrackIndex = 0
    var trackName: String = ""
    var artistTitle: String = ""
    var albumId: String = ""
    var id: String = ""
    var rhythmAudioPlayer: AVPlayer? = AVPlayer()
    
    var isTrackPlaying = true
    
    var previewUrl:String = ""
    
    private func playTrack(trackUrl:String) {
        var songUrl :String? = "";
        if(trackUrl != ""){
            songUrl = trackUrl
        }
        else{
            let defaultUrl = "https://listen.hs.llnwd.net/g3/prvw/4/1/3/9/5/2578459314.mp3"
            songUrl = defaultUrl
        }
        let trackPreviewUrl = URL(string: songUrl!)!
            do {
                let playerItem = AVPlayerItem(url:trackPreviewUrl)
                self.rhythmAudioPlayer = try AVPlayer(playerItem: playerItem)
                rhythmAudioPlayer!.volume = 1.0
                rhythmAudioPlayer!.play()
                
               
    //            guard let rhythmAudioPlayer = rhythmAudioPlayer else { return }
                
            } catch let error as NSError{
                self.rhythmAudioPlayer = nil
                print(error.localizedDescription)
            }
       
    }
    
    func setNowPlayingInfo()
        {
            let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
            var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()

            let title = trackName
            let album = artistTitle
            let image = albumArt.image
            let artwork = MPMediaItemArtwork(boundsSize: image!.size, requestHandler: {  (_) -> UIImage in
                return image!
            })

            nowPlayingInfo[MPMediaItemPropertyTitle] = title
            nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = album
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork

            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        }
    
    
    
    func setTrackInfo(){
        self.songTitle.text = trackName;
        
        self.artistName.text = artistTitle;
        
        if(albumId != ""){
            NetworkingService.Shared.getImage(albumId:albumId)
            {
                result in
                switch result{
                case .success(let imageFromURL):
                    DispatchQueue.main.async{
                        self.albumArt.image = imageFromURL
                    }
                    break
                case .failure(_):
                    break
                }
                
            }
        }
    }
    
    
    
    private func animateAlbumArt() {
      let options: UIView.AnimationOptions = [.curveEaseInOut,
                                              .repeat,
                                              .autoreverse]


        UIView.animate(withDuration: 1.5,
                     delay: 0,
                     options: options,
                     animations: { [weak self] in
          self?.albumArt.frame.size.height *= 1.05
                      self?.albumArt.frame.size.width *= 1.05
      }, completion: nil)
    }
    
    private func stopAnimateAlbumArt() {
      let options: UIView.AnimationOptions = []


        UIView.animate(withDuration: 0,
                     delay: 0,
                     options: options,
                     animations: { [weak self] in
          self?.albumArt.frame.size.height *= 1
                      self?.albumArt.frame.size.width *= 1
      }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumArt.layer.masksToBounds = true
        albumArt.layer.cornerRadius = albumArt.bounds.width/2
        
        albumArt.clipsToBounds = true
        
        self.setTrackInfo()
        
        self.setNowPlayingInfo()
        
        playerSlider.maximumValue = 30
        
        var Timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
        
        playTrack(trackUrl:previewUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        animateAlbumArt()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //stop playing songs and deallocate player
        self.rhythmAudioPlayer!.pause()
        self.rhythmAudioPlayer!.replaceCurrentItem(with: nil)
        
        self.setTrackInfo()
        
        self.setNowPlayingInfo()
        
        playTrack(trackUrl:previewUrl)
    }
    
    @IBAction func controlPlayer(_ sender: Any) {
        if(isTrackPlaying){
            rhythmAudioPlayer!.pause()
            isTrackPlaying = false
            
            let playBtnImage = UIImage(named: "play") as UIImage?
            playerController.setImage(playBtnImage, for: .normal)
            stopAnimateAlbumArt()
        }else{
            rhythmAudioPlayer!.play()
            isTrackPlaying = true
            let pauseBtnImage = UIImage(named: "pause") as UIImage?
            playerController.setImage(pauseBtnImage, for: .normal)
            animateAlbumArt()
        }
    }
    
    @IBAction func controlSlider(_ sender: Any) {
        //stop playing songs and deallocate player
        self.rhythmAudioPlayer!.pause()
        self.rhythmAudioPlayer!.replaceCurrentItem(with: nil)
        
        playTrack(trackUrl:previewUrl)

        rhythmAudioPlayer?.currentItem?.seek(to: CMTimeMakeWithSeconds(Float64(playerSlider.value), preferredTimescale: (rhythmAudioPlayer?.currentItem?.currentTime().timescale)!))
    }
    
    @objc func updateSlider (){
        
        currentPlayerTime.text = String(format:"0: %02.0f",(Float(CMTimeGetSeconds((rhythmAudioPlayer?.currentItem?.currentTime())!))))
        playerSlider.value = Float(CMTimeGetSeconds((rhythmAudioPlayer?.currentItem?.currentTime())!))
    }
    
    @IBAction func playNextSong(_ sender: Any) {
        //stop playing songs and deallocate player
        self.rhythmAudioPlayer!.pause()
        self.rhythmAudioPlayer!.replaceCurrentItem(with: nil)
        
        if(tracksList.tracks!.count - 1 != currentTrackIndex){
            currentTrackIndex += 1
        }else{
            currentTrackIndex = 0
        }
        
        trackName = "\(String(describing: tracksList.tracks![currentTrackIndex].name!))"
        artistTitle = "\(String(describing: tracksList.tracks![currentTrackIndex].artistName!))"
        albumId = "\(String(describing: tracksList.tracks![currentTrackIndex].albumId!))"
        previewUrl = "\(String(describing: tracksList.tracks![currentTrackIndex].previewURL!))"
        id = "\(String(describing: tracksList.tracks![currentTrackIndex].id!))"
        
        
        //setTrackInfo and labels

        setTrackInfo()
        self.setNowPlayingInfo()
        playTrack(trackUrl:previewUrl)
    }
    
    @IBAction func playPreviousSong(_ sender: Any) {
        
        //stop playing songs and deallocate player
        self.rhythmAudioPlayer!.pause()
        self.rhythmAudioPlayer!.replaceCurrentItem(with: nil)
        
        if(currentTrackIndex == 0){
            currentTrackIndex = tracksList.tracks!.count - 1
        }else{
            currentTrackIndex -= 1
        }
        
        trackName = "\(String(describing: tracksList.tracks![currentTrackIndex].name!))"
        artistTitle = "\(String(describing: tracksList.tracks![currentTrackIndex].artistName!))"
        albumId = "\(String(describing: tracksList.tracks![currentTrackIndex].albumId!))"
        previewUrl = "\(String(describing: tracksList.tracks![currentTrackIndex].previewURL!))"
        id = "\(String(describing: tracksList.tracks![currentTrackIndex].id!))"
        
        
        
        //setTrackInfo and labels
        setTrackInfo()
        self.setNowPlayingInfo()
        playTrack(trackUrl:previewUrl)
    }
    
    @IBAction func shuffleSong(_ sender: Any) {
        tracksList.tracks!.shuffle()
        currentTrackIndex = 0
        trackName = "\(String(describing: tracksList.tracks![currentTrackIndex].name!))"
        artistTitle = "\(String(describing: tracksList.tracks![currentTrackIndex].artistName!))"
        albumId = "\(String(describing: tracksList.tracks![currentTrackIndex].albumId!))"
        previewUrl = "\(String(describing: tracksList.tracks![currentTrackIndex].previewURL!))"
        id = "\(String(describing: tracksList.tracks![currentTrackIndex].id!))"
        
        //stop playing songs and deallocate player
        self.rhythmAudioPlayer!.pause()
        self.rhythmAudioPlayer!.replaceCurrentItem(with: nil)
        
        //setTrackInfo and labels
        setTrackInfo()
        self.setNowPlayingInfo()
        playTrack(trackUrl:previewUrl)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toComments"){
            let commentVC = segue.destination as! CommentsVC
            
            commentVC.id = id
            commentVC.albumArt = albumArt.image
            commentVC.track = trackName
            commentVC.artist = artistTitle
            
        }
    }

}
