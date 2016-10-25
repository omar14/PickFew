//
//  ViewController.swift
//  PickFew
//
//  Created by Omar Al-Essa on 10/21/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - UIOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var stepOne: UIImageView!
    @IBOutlet weak var stepTwo: UIImageView!
    @IBOutlet weak var stepThree: UIImageView!
    @IBOutlet weak var stepFour: UIImageView!
    

    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UICollectionView Stuff
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = (indexPath as NSIndexPath).row
        let stepCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCellId", for: indexPath) as! StepCell
        
        if index == 0 {
            stepCell.stepImage.image = #imageLiteral(resourceName: "bigIcon")
        }
        else if index == 1 {
            stepCell.stepImage.image = #imageLiteral(resourceName: "stepOneScreen")
        }
        else if index == 2 {
            stepCell.stepImage.image = #imageLiteral(resourceName: "stepTwoScreen")
        }
        else if index == 3 {
            stepCell.stepImage.image = #imageLiteral(resourceName: "stepThreeScreen")
        }
        else if index == 4 {
            stepCell.stepImage.image = #imageLiteral(resourceName: "stepFourScreen")
        }
        else {
            stepCell.stepImage.image = #imageLiteral(resourceName: "finalStep")
        }
        
        return stepCell
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        showTheThing()
    }
    
    
    func showTheThing(){
        let index = (myCollectionView.indexPathsForVisibleItems[0] as NSIndexPath).row
        
        if index == 0 {
            startBtn.setImage(UIImage(named: "heyImage"), for: UIControlState())
            stepOne.image = UIImage(named: "emptyStep")
            stepTwo.image = UIImage(named: "emptyStep")
            stepThree.image = UIImage(named: "emptyStep")
            stepFour.image = UIImage(named: "emptyStep")
            endBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
        }
        else if index == 1 {
            startBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
            stepOne.image = UIImage(named: "stepOneOval")
            stepTwo.image = UIImage(named: "emptyStep")
            stepThree.image = UIImage(named: "emptyStep")
            stepFour.image = UIImage(named: "emptyStep")
            endBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
        }
        else if index == 2 {
            startBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
            stepOne.image = UIImage(named: "emptyStep")
            stepTwo.image = UIImage(named: "stepTwoOval")
            stepThree.image = UIImage(named: "emptyStep")
            stepFour.image = UIImage(named: "emptyStep")
            endBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
        }
        else if index == 3 {
            startBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
            stepOne.image = UIImage(named: "emptyStep")
            stepTwo.image = UIImage(named: "emptyStep")
            stepThree.image = UIImage(named: "stepThreeOval")
            stepFour.image = UIImage(named: "emptyStep")
            endBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
        }
        else if index == 4 {
            startBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
            stepOne.image = UIImage(named: "emptyStep")
            stepTwo.image = UIImage(named: "emptyStep")
            stepThree.image = UIImage(named: "emptyStep")
            stepFour.image = UIImage(named: "stepFourOval")
            endBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
        }
        else {
            startBtn.setImage(UIImage(named: "lineImage"), for: UIControlState())
            stepOne.image = UIImage(named: "emptyStep")
            stepTwo.image = UIImage(named: "emptyStep")
            stepThree.image = UIImage(named: "emptyStep")
            stepFour.image = UIImage(named: "emptyStep")
            endBtn.setImage(UIImage(named: "endImage"), for: UIControlState())
        }
    }

}

