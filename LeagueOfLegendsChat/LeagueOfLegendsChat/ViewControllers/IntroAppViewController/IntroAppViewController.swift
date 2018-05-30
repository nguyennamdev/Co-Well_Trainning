//
//  IntroAppViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/29/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
class IntroAppViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var pageControl: UIPageControl!
    var introList: [Introduction]!
    var currentPageIsShowing = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init default intro list
        introList = [Introduction(title: "WelcomeApp".localized, backgroundImage: #imageLiteral(resourceName: "background"), contentImage: #imageLiteral(resourceName: "league-legends"), contentText: "Content First Intro".localized),
                     Introduction(title: "App features".localized, backgroundImage: #imageLiteral(resourceName: "background2"), contentImage: #imageLiteral(resourceName: "ahri-love-charm"), contentText: "Content Second Intro".localized),
                     Introduction(title: "Information about the app".localized, backgroundImage: #imageLiteral(resourceName: "background3"), contentImage: #imageLiteral(resourceName: "yasuo"), contentText: "Content Third Intro".localized)
        ]
        setupPageControl()
      
    }
    // MARK:- Private instance methods
    private func setupPageControl(){
        // setup page control
        pageControl.defersCurrentPageDisplay = false
        pageControl.numberOfPages = introList.count
        pageControl.currentPage = 0
        pageControl.isSelected = false
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        handleLoadIntro()
    }
    
    private func handleLoadIntro(){
        let introduction = self.introList[currentPageIsShowing]
        titleLabel.text = introduction.title
        contentTextView.text = introduction.contentText
        contentImageView.image = introduction.contentImage
        backgroundImageView.image = introduction.backgroundImage
    }
    
    // MARK:- Actions
    @IBAction func nextPage(_ sender: UIButton) {
        currentPageIsShowing += 1
        if currentPageIsShowing > introList.count - 1{
            // dismiss to show login vc
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                UserDefaults.standard.setIsShowedIntroduct(value: true)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let customTabbarViewController = storyboard.instantiateViewController(withIdentifier: "customTabbar") as! CustomTabbarViewController
                appDelegate.window?.rootViewController = customTabbarViewController
            }
        }else{
            handleLoadIntro()
            pageControl.currentPage = currentPageIsShowing
        }
    }
    
    @IBAction func previousPage(_ sender: UIButton) {
        currentPageIsShowing -= 1
        if currentPageIsShowing < 0 {
            currentPageIsShowing = 0
        }
        handleLoadIntro()
        pageControl.currentPage = currentPageIsShowing
    }
}
