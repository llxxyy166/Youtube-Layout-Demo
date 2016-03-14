//
//  VideoTitleView.swift
//  YoutubeDemo
//
//  Created by xinye lei on 16/3/13.
//  Copyright © 2016年 xinye lei. All rights reserved.
//

import UIKit

class VideoTitleView: UIView {
    
    var currentHeight: CGFloat = 0
    var finalHeight: CGFloat? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("titleHeight", object: currentHeight)
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            if (isExpanded) {
                indicator.text = "▲"
            }
            else {
                indicator.text = "▼"
            }
        }
    }
    
    var video: Video? {
        didSet {
            setUp()
            setUpGesture()
            shrinkLayout()
        }
    }
    
    func setUpGesture() {
        let view = UIView(frame: titleLabel.frame)
        view.frame.size.width = self.frame.width
        view.backgroundColor = UIColor.clearColor()
        self.addSubview(view)
        let gesture = UITapGestureRecognizer(target: self, action: "handTap")
        view.addGestureRecognizer(gesture)
    }
    
    func handTap() {
        finalHeight = currentHeight
        if (!isExpanded) {
            isExpanded = true
            expandedLayout()
        }
        else {
            isExpanded = false
            shrinkLayout()
        }
    }
    
    
    var titleLabel = UILabel()
    var numOfViewLabel = UILabel()
    var indicator = UILabel()
    var descriptionLabel = UILabel()
    var miscLabel = UILabel()
    var upVote = UIButton()
    var downVote = UIButton()
    
    func setUp() {
        setDescriptionLabel()
        setMiscLabel()
        addTitleLabel()
        addVoteButtons()
    }
    
    func setDescriptionLabel() {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        descriptionLabel.frame = frame
        descriptionLabel.text = "Published on \(video!.publishedDate) \(video!.description)"
        descriptionLabel.lineBreakMode = .ByWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
    }
    
    func setMiscLabel() {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        miscLabel.frame = frame
        miscLabel.text = "Category:   \(video!.category)\nLicense:   \(video!.license)"
        miscLabel.lineBreakMode = .ByWordWrapping
        miscLabel.numberOfLines = 0
        miscLabel.sizeToFit()
    }
    
    func addTitleLabel() {
        var titleFrame = self.bounds
        titleFrame.size.height = 0
        titleFrame.size.width *= 0.95
        titleFrame.origin.y += 8
        titleLabel.frame = titleFrame
        titleLabel.text = video!.title
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        currentHeight += 8 + titleLabel.frame.height
        
        var numOfViewsFrame = titleLabel.frame
        numOfViewsFrame.origin.y += titleLabel.frame.size.height
        numOfViewsFrame.size.height = 10
        numOfViewLabel.frame = numOfViewsFrame
        numOfViewLabel.text = "\(video!.numberOfViews) views"
        numOfViewLabel.sizeToFit()
        self.addSubview(numOfViewLabel)
        currentHeight += numOfViewLabel.frame.height
        
        let indicatorFrame = CGRect(x: 0.95 * bounds.width, y: titleFrame.origin.y, width: 0.05 * bounds.width, height: 15)
        indicator.frame = indicatorFrame
        indicator.text = "▼"
        indicator.textAlignment = .Center
        self.addSubview(indicator)
    }
    
    func addVoteButtons() {
        let size = CGSize(width: 80, height: 20)
        upVote.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        downVote.frame = CGRect(x: 0 + size.width + 10, y: 0, width: size.width, height: size.height)
        upVote.setTitle("👍🏿 \(video!.thumbUp)", forState: .Normal)
        downVote.setTitle("👎🏿 \(video!.thumbDown)", forState: .Normal)
        upVote.setTitleColor(UIColor.grayColor(), forState: .Normal)
        downVote.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.addSubview(upVote)
        self.addSubview(downVote)
    }
    
    func shrinkLayout() {
        if (miscLabel.superview != nil) {
            miscLabel.removeFromSuperview()
        }
        if (descriptionLabel.superview != nil) {
            descriptionLabel.removeFromSuperview()
        }
        currentHeight = titleLabel.frame.height + numOfViewLabel.frame.height + 8
        upVote.frame.origin.y = currentHeight + 8
        downVote.frame.origin.y = currentHeight + 8
        currentHeight += 20 + 8
    }
    
    func expandedLayout() {
        currentHeight -= 20 + 8
        descriptionLabel.frame.origin.y = currentHeight + 8
        currentHeight += descriptionLabel.frame.height + 8
        miscLabel.frame.origin.y = currentHeight + 8
        currentHeight += miscLabel.frame.height + 8
        upVote.frame.origin.y = currentHeight + 8
        downVote.frame.origin.y = currentHeight + 8
        currentHeight += upVote.frame.height + 8
        self.addSubview(descriptionLabel)
        self.addSubview(miscLabel)
    }
    
}
