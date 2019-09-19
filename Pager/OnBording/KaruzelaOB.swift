//
//  KaruzelaOB.swift
//  Pager
//
//  Created by darys on 28/08/2019.
//  Copyright © 2019 darys. All rights reserved.
//

import Foundation

class KaruzelaOB: UIViewController, UIScrollViewDelegate{
  
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var Zakoncz: UIButton!
    @IBOutlet weak var zakoncz: UIButton!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0
    
    //data for the slides
    var titles = ["L_OB0_T1".localized(),"L_OB1_T1".localized(),"L_OB2_T1".localized(),"L_OB3_T1".localized(),"L_OB4_T1".localized()]
    var descs = ["L_OB0_T2".localized(), "L_OB1_T2".localized(),"L_OB2_T2".localized(), "L_OB3_T2".localized(), "L_OB4_T2".localized()]
    var imgs = ["0","1","2","3","4"]
    
    //uzyskaj dynamiczną szerokość i wysokość widoku przewijania i zapisz go
    override func viewDidLayoutSubviews() {
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      self.navigationController?.isNavigationBarHidden = true
       // Zakoncz.setTitle("Zakończ", for: .normal)
        zakoncz.setTitle("L_ZAKONCZ".localized(), for: .normal)
        
        self.view.layoutIfNeeded()
        //wywołać viewDidLayoutSubviews () i uzyskać dynamiczną szerokość i wysokość widoku przewijania
        
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        //utworz slajdy i dodaj je
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slide = UIView(frame: frame)
            
            //subviews
            
            
            
            let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
            //imageView.frame = CGRect(x:0,y:0,width:300,height:300)
            //imageView.frame = CGRect(x:0,y:0,width:300,height:350)
            imageView.frame = CGRect(x:10,y:0,width:scrollWidth - 20,height:scrollWidth + 50)
            imageView.contentMode = .scaleAspectFit
            //imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)
            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 35)
            
            //let txt1 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+30,width:scrollWidth-64,height:30))
            //print("wymiary")
            //print(scrollHeight)
            //print(scrollWidth)
            
            let txt1 = UILabel.init(frame:CGRect(x:32,y:(scrollHeight-scrollWidth)/2/2-30,width:scrollWidth-64,height:60))
            txt1.textAlignment = .center
            txt1.numberOfLines = 2
            txt1.font = UIFont.boldSystemFont(ofSize: 24.0)
            txt1.text = titles[index]
            print(txt1.frame.minY)
            
            //let txt2 = UILabel.init(frame: CGRect(x:32,y:txt1.frame.maxY+10,width:scrollWidth-64,height:50))
            let txt2 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY-30,width:scrollWidth-64,height:95))
            txt2.textAlignment = .center
            txt2.font = UIFont.systemFont(ofSize: 16.0)
            txt2.text = descs[index]
            txt2.numberOfLines = 0
            txt2.sizeToFit()
            slide.addSubview(imageView)
            slide.addSubview(txt1)
            slide.addSubview(txt2)
            scrollView.addSubview(slide)
            
        }
        
        //ustaw szerokość widoku przewijania, aby pomieścić wszystkie slajdy
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
        
        //wyłącz przewijanie / odbijanie w pionie
        self.scrollView.contentSize.height = 1.0
        
        //stan początkowy
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
        
    }
    
    //indicator
    @IBAction func pageChanged(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }
    
    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
    
    @IBAction func zakoncz_ob(_ sender: UIButton) {
        //przejście do listy dań
        self.performSegue(withIdentifier: "unwindToParentFromOnBoarding", sender: self)
       
    }
   
    /*
    var images: [String] = ["0", "1", "2"]
    var frame = CGRect(x:0, y:0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = images.count
        
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
        }
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    //Scrollview Metod
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
 */
}
