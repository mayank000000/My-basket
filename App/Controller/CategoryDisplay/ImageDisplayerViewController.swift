//
import UIKit

import SDWebImage
import SwiftIcons
import SwiftyJSON
import RealmSwift
import Realm
import SYPhotoBrowser

class ImageDisplayerViewController: BaseVC,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var titleArray = ["DAIRY PRODUCTS", "DRINKS","FROZEN ITEMS","LAUNDARY","SNACKS","VEGETABLES"]
    var imageArray = ["dairy","softdrinks","frozenfood","laundary","snacks","vegetables"]
    
    var arrayPhotoURL = [String]()
    
    @IBOutlet weak var collectionViewGallery: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewGallery.delegate = self
        collectionViewGallery.dataSource = self
        
        collectionViewGallery.backgroundColor = CLEAR_COLOR;
        
        let spacingCell : CGFloat = 8.0
        let cellSize : CGFloat = (SCREENWIDTH() - spacingCell*3)/2
        let collectionViewLayout: UICollectionViewFlowLayout = (collectionViewGallery!.collectionViewLayout as! UICollectionViewFlowLayout)
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(spacingCell, spacingCell, spacingCell, spacingCell)
        collectionViewLayout.minimumInteritemSpacing = spacingCell
        collectionViewLayout.itemSize = CGSize(width: cellSize, height: cellSize*0.8)
        collectionViewLayout.scrollDirection = .vertical
        
        collectionViewGallery.showsHorizontalScrollIndicator = false
        collectionViewGallery.showsVerticalScrollIndicator = false
        
        collectionViewGallery.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
     
        collectionViewGallery.reloadData()
       
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
           self.navigationController?.setNavigationBarHidden (false, animated: false)
           self.setNavigationbarleft_imagename(left_icon_Name:nil, left_action: nil,
                                               right_icon_Name:IoniconsType.logOut,
                                               right_action: #selector(self.btnBackHandle(_:)),
                                               title: "Browse Catagories")
    }
    //MARK: - Colllectionview Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell",for:indexPath) as! ImageCollectionViewCell
      // let img = indexPath.row + 1
        let img = imageArray[indexPath.row]
        cell.imageViewGallery.image = UIImage(named: "\(img)")
        cell.setCornerRadius(radius: 13)
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.backgroundColor = APP_WHITE_COLOR
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let homeVC = loadVC(storyboardMain, "ListViewController") as! ListViewController
        homeVC.categoryIndex = indexPath.row
        homeVC.category =  titleArray[indexPath.row]
                                  self.navigationController?.pushViewController(homeVC, animated: true)
                              
        
    }
    //MARK: - custom method
    
}
