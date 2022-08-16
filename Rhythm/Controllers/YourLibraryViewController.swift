//
//  YourLibraryViewController.swift
//  Rhythm
//
//  Created by Parth Antala on 2022-07-22.
//

import UIKit

class YourLibraryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    var songsArray = [UIImage(named: "weekend"),UIImage(named: "drake"),UIImage(named: "AnneMarie")]
    var songTitleArr = ["Blinding Lights","God's Plan","FRIENDS"]
    var artistNameArr = ["The Weekend","Drake","Anne-Marie"]
    
    @IBOutlet var listButtons: [UIButton]!
    
    
    @IBOutlet weak var recentActivityCollection: UICollectionView!
    
    @IBOutlet weak var listButtonsView: UIView!
    @IBOutlet weak var recentActivtiyView: UIStackView!
    @IBOutlet weak var YourLibraryLabel: UILabel!
    
    private func animateYourLibraryLabel() {
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 400))
        containerView.backgroundColor = UIColor.white
        let offset = CGPoint(x: 0, y: -containerView.frame.maxY)
        let x: CGFloat = 0, y: CGFloat = 0
        YourLibraryLabel.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        YourLibraryLabel.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 1, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.YourLibraryLabel.transform = .identity
                self.YourLibraryLabel.alpha = 1
        })
        
        YourLibraryLabel.alpha = 0
        YourLibraryLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 2, delay: 1, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.YourLibraryLabel.transform = .identity
                self.YourLibraryLabel.alpha = 1
        }, completion: nil)

        
    }
    
    private func animateListButtons(){
        listButtonsView.alpha = 0
        listButtonsView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: 2, delay: 0.5, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.listButtonsView.transform = .identity
                self.listButtonsView.alpha = 1
        }, completion: nil)
    }
    
    private func animateCategoryView() {
        let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 400))
        containerView.backgroundColor = UIColor.white
        
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        recentActivityCollection.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        recentActivityCollection.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.recentActivityCollection.transform = .identity
                self.recentActivityCollection.alpha = 1
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentActivityCollection.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        self.recentActivityCollection.alpha = 0
        animateYourLibraryLabel()
        animateListButtons()
        animateCategoryView()
    }
    
    //Recent Activity Collection Properties
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == recentActivityCollection){
            return songsArray.count
        }
        return songsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == recentActivityCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentActivityCollectionViewCell", for: indexPath) as! SongsCollectionVCell
            
            cell.songImage.image = songsArray[indexPath.row]
        
            cell.songTitle.text = "\(songTitleArr[indexPath.row])"
                
            cell.artistName.text = "\(artistNameArr[indexPath.row])"
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentActivityCollectionViewCell", for: indexPath) as! SongsCollectionVCell
            
            cell.songImage.image = songsArray[indexPath.row]
        
            cell.songTitle.text = "\(songTitleArr[indexPath.row])"
                
            cell.artistName.text = "\(artistNameArr[indexPath.row])"
            
            return cell
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
