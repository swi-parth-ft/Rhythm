//
//  CommentsVC.swift
//  Rhythm
//
//  Created by Vrushank on 2022-07-21.
//

import UIKit
import Firebase

class CommentsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var user: User!
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var track:String = ""
    var artist:String = ""
    let ref = Database.database().reference(withPath: "comments")
    var refObservers: [DatabaseHandle] = []
    var handle: AuthStateDidChangeListenerHandle?
    var comments: [Comments] = []
    var commentsTemp: [Comments] = []
    var id: String = ""
    var commentId: Int = 0
    var albumArt: UIImage?
    var profiles = [UIImage(named: "woman"),UIImage(named: "profile"),UIImage(named: "gamer"),UIImage(named: "man")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for cmt in comments{
            if cmt.trackId == "demo"{
                commentsTemp.append(cmt)
            }
        }
        let backgroundImage = albumArt
            let backgroundImageView = UIImageView.init(frame: self.view.frame)

            backgroundImageView.image = backgroundImage
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.alpha = 0.1

            self.view.insertSubview(backgroundImageView, at: 0)
        
        tableView.allowsMultipleSelectionDuringEditing = false
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bohemianRhapsody")!)
        
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        songName.text = track
        artistName.text = artist
        
        let commentColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00);
        
        commentTextField.layer.borderColor = commentColor.cgColor
        
        commentTextField.layer.borderWidth = 1.0
        
        commentTextField.layer.cornerRadius = 10
        
        
    }
    
    @IBAction func sendComment(_ sender: Any) {
        let comment = commentTextField.text!
       
        let commentItem = Comments(comment: comment, trackId: id,id: commentId)
        commentId += 1
        //MARK: - Ref to snapshot of grocery list
        let commentItemRef = self.ref.child(comment.lowercased())
        
        commentItemRef.setValue(commentItem.toAnyObject())
        commentTextField.text = ""
        self.tableView.reloadData()
    }
    
    
    //TableView Properties
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(comments.count)
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentBox", for: indexPath) as! CommentsTableViewCell
        let commenItem = comments[indexPath.row]
//        cell.profileIcon.image = profiles[indexPath.row]
        cell.profileIcon.image = profiles[Int.random(in:0...3)]
        
        cell.comment.text = "  \(commenItem.comment)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        ref.observe(.value, with: { snapshot in
          print(snapshot.value as Any)
        })
        
        let completed = ref
            .queryOrdered(byChild: "id")
          .observe(.value) { snapshot in
            var newItems: [Comments] = []
            for child in snapshot.children {
              if
                let snapshot = child as? DataSnapshot,
                let groceryItem = Comments(snapshot: snapshot) {
                  if groceryItem.trackId == self.id{
                newItems.append(groceryItem)
                  }
              }
            }
            self.comments = newItems
            self.tableView.reloadData()
          }
        refObservers.append(completed)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        refObservers.forEach(ref.removeObserver(withHandle:))
        refObservers = []

    }


}
