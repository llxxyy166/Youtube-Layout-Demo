//
//  ViewController.swift
//  YoutubeDemo
//
//  Created by xinye lei on 16/3/10.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


struct Video {
    let title: String
    let author: String
    let subs: Int
    let publishedDate: String
    let description: String
    let category: String
    let license: String
    let numberOfViews: Int
    let thumbUp: Int
    let thumbDown: Int
}

func demoVideo() -> Video {
    let title = "Title Title Title Title Title Title Title Title Title Title Title Title Title aaa"
    let author = "Xinye Lei"
    let publishDate = "July 02, 1991"
    let description = "DemoDemoDemoDemoDemoDemo\nDemoDemoDemoDemoDemoDemoDemoDemo\nDemoDemoDemo \ndadsdsadasdsadsdasdasdasdasdas\nasdasdas\nleilei\naasdsadasdadsadasdasdasdasdas\nsadjasd1231231\nasdsdsdasdasdsadsadasdasdsadasdasdasdasdasdasdasdasdasdasdads"
    let category = "Demo Category"
    let license = "Standard XinyeLei License"
    let numberOfViews = Int(arc4random_uniform(10000))
    let thumbUp = Int(arc4random_uniform(1000))
    let thumbDown = Int(arc4random_uniform(1000))
    let subs = Int(arc4random_uniform(10000))
    return Video(title: title, author: author, subs: subs, publishedDate: publishDate, description: description, category: category, license: license, numberOfViews: numberOfViews, thumbUp: thumbUp, thumbDown: thumbDown)
}


class VideoPlayingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var relatedVideos = [Video]()
    
    var video: Video?
    var authorView: UIView = UIView()
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserverForName("titleHeight", object: nil, queue: nil) { (notification) -> Void in
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.collectionView.collectionViewLayout.invalidateLayout()
            })
        }
    }
    
    func setAuthorView(){
        let authorLabel = UILabel()
        authorLabel.frame.size.width = self.view.bounds.width
        authorLabel.numberOfLines = 1
        authorLabel.text = video!.author
        authorLabel.sizeToFit()
        let subscribLabel = UILabel()
        subscribLabel.frame.size.width = self.view.bounds.width
        subscribLabel.numberOfLines = 1
        subscribLabel.text = "\(video!.subs) subscribers"
        subscribLabel.sizeToFit()
        let height = authorLabel.frame.height + subscribLabel.frame.height
        authorView.frame.size.width = self.view.bounds.width
        authorView.frame.size.height = height
        authorView.addSubview(authorLabel)
        authorView.addSubview(subscribLabel)
        authorLabel.frame.origin = CGPoint(x: 40, y: 0)
        subscribLabel.frame.origin = CGPoint(x: 40, y: authorLabel.frame.height)
        
        let subscribeSymbol = UILabel()
        subscribeSymbol.frame = CGRect(x: authorView.bounds.width - 100, y: 0, width: 100, height: authorView.bounds.height)
        subscribeSymbol.text = "Subscribe"
        subscribeSymbol.textAlignment = .Center
        subscribeSymbol.textColor = UIColor.redColor()
        authorView.addSubview(subscribeSymbol)
        
        let icon = UIImageView(frame: authorView.bounds)
        icon.frame.size.width = 40
        icon.image = UIImage(named: "author")
        authorView.addSubview(icon)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        for _ in 0...29 {
            relatedVideos.append(demoVideo())
        }
        video = demoVideo()
        setTitleView()
        setAuthorView()
        print(authorView)
        // Do any additional setup after loading the view.
    }
    
    var titleView: VideoTitleView = VideoTitleView()
    
    func setTitleView() {
        titleView.frame = self.view.bounds
        titleView.video = video
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destinationViewController as! AVPlayerViewController
        let url = NSBundle.mainBundle().URLForResource("moments", withExtension: "mp4")
        vc.player = AVPlayer(URL: url!)
    }
}

extension VideoPlayingViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return 0;
        }
        if (section == 1) {
            return relatedVideos.count
        }
        return 0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        cell.addSubview(imageView)
        imageView.image = UIImage(named: "videoImage")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let reuseView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
        if (indexPath.section == 0) {
            titleView.frame = reuseView.bounds
            reuseView.addSubview(titleView)
        }
        if (indexPath.section == 1) {
            authorView.frame.origin = CGPoint(x: 0, y: 0)
            reuseView.addSubview(authorView)
        }
        return reuseView
    }
}

extension VideoPlayingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSize(width: self.view.frame.width, height: titleView.currentHeight)
        }
        if (section == 1) {
            return authorView.frame.size
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 3.5, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
}
