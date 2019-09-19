//
//  ParentViewController.swift
//  Pager
//
//  Created by darys on 03.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Localize_Swift

class ParentViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0) //prawie czarnmy
    //let malinaColor = UIColor(red:216/255, green:67/255, blue:78/255, alpha:1.0)
    
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var menu_vc: MenuViewController!      //menu boczne
    
    var siec: Network?
    var reachability: Reachability?  //dostępność Internetu
    var memory1: [Memorydb]? = []         //filtry1 zapamiętane w bazie lokalnej
    var memory2: [Memorydb]? = []         //filtry2 zapamiętane w bazie lokalnej
    
    var activityIndicator = UIActivityIndicatorView() //wskaźnik aktywności
    
    override func viewDidLoad() {
        Shared.shared.temp = 0 //pierwsze ustawienie 'temp' - zezwolenie na wyświetlenie popupa z podkategoriami

        //ustawienia paska z kategoriami dań
        // change selected bar color
        //settings.style.buttonBarBackgroundColor = .blue //?
        settings.style.buttonBarItemBackgroundColor = Shared.shared.malinaColor //tło kategorii
        settings.style.selectedBarBackgroundColor = purpleInspireColor //prawie czarny
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .blue //?
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = self?.purpleInspireColor //czcionka kategorii
        }
       
        super.viewDidLoad()
        
        
        //przesuwanie ręczne menu bocznego
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        let swipeRight = UISwipeGestureRecognizer(target:self, action: #selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        let swipeLeft = UISwipeGestureRecognizer(target:self, action: #selector(self.respondToGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        //----- wskaźnik aktywności-----------
        activityIndicator.center = CGPoint.init(x: self.view.frame.size.width/2, y: 200)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        self.activityIndicator.stopAnimating()

    }
    
    //funkcja określająca aktualny identyfikator wybranej kategotii dań - wyswietlanej listy dań
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {

        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged && toIndex > -1 && toIndex < viewControllers.count {
            //print("New index: \(toIndex)")
            var temp = toIndex
            if toIndex == 0 {temp = 9} //dla "Sniadań" (potrzebne przy wyborze podkategorii)
            AppDelegate.which_page = temp
        }

    }
    
    
    //wywołanie popup'a z podkategoriami
   @IBAction func podkategorie(_ sender: Any) {
        if Shared.shared.temp == 0{
            let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpPodkategorie") as! PodkatViewController
            
            self.addChildViewController(popupVC)
            popupVC.view.frame = self.view.frame
            //popupVC.delegate = self  //1 utworzenie delegata w widoku z którego mają wrócić dane
            self.view.addSubview(popupVC.view)
            popupVC.didMove(toParentViewController: self)
            Shared.shared.temp = 1 //żeby powstało tylko jedno okno z podkategoriami
        }
 
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        if Shared.shared.lista == "1" {
            let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child11")
            let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child21")
            let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child31")
            let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child41")
            let child_5 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child51")
            let child_6 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child61")
            let child_7 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child71")
            let child_8 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child81")
            let child_9 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child91")
            return [child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8, child_9]
        }else {
            let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1")
            let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child2")
            let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child3")
            let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child4")
            let child_5 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child5")
            let child_6 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child6")
            let child_7 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child7")
            let child_8 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child8")
            let child_9 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child9")
            return [child_1, child_2, child_3, child_4, child_5, child_6, child_7, child_8, child_9]
        }
        
  
    }

    //-------------------------------------------------------
    //załadowanie danych z bazy lokalnej - odświeżenie widoku
    //-------------------------------------------------------
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
        print("wywołanie przeładowania głównego")

        AppDelegate.refresh_list_meal = false   //... i ustaw na 'false'
        var index_child = AppDelegate.which_page //index strony (kategorii dań)
        if AppDelegate.which_page == 9 { index_child = 0} //dla 'śniadań'
        moveToViewController(at: index_child ) //przejście do odpowiedniej kategorii dań

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //pobranie lokalizacji z tabeli 'memory->mem_lok' - pamięci ustawień z widoku ustawiania lokalizacji
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        
        //ustawienie tytułu w pasku nawigacji dla listy dań (nazwa miasta lub nazwa restauracji)
        if location![0].f == "00" { //"00" oznacza "Wszystkie"
            self.navigationItem.title = "\(location![0].d)" //miasto - jeżeli nie wybrano restauracji
        }else{
            self.navigationItem.title = "\(location![0].f)" //nazwa wybranej restauracji
        }
        
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież listę dań...
            if AppDelegate.lubienie_zmienione == true { //jeżeli zmieniono oceny składników
                close_menu()
                getDataFromServer()   //pobranie dań z serwera do bazy lokalnej
            }else{
                reloadPagerTabStripView()  //załadowanie danych z bazy lokalnej - odświeżenie widoku
            }
        }
    }
  

    //przejście z wyboru języka (z LangViewController)
    @IBAction func unwindToParentFromLang(segue: UIStoryboardSegue) {
        close_menu()
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież...
            reloadPagerTabStripView()
        }
    }
    
    //przejście po zalogowaniu (z LoginViewController)
    @IBAction func unwindToParentFromOnBoarding(segue: UIStoryboardSegue) {
        close_menu()
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież...
            reloadPagerTabStripView()
        }
    }
    
    //przejście po zalogowaniu (z LoginViewController)
    @IBAction func unwindToParentFromLogin(segue: UIStoryboardSegue) {
        close_menu()
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież...
            reloadPagerTabStripView()
        }
    }
    
    //przejście po wylogowaniu (z MenuViewController)
    @IBAction func unwindToParentFromMenu(segue: UIStoryboardSegue) {
        close_menu()
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież...
            reloadPagerTabStripView()
        }
    }
    
    //przejście z popapu wyboru podkategorii + odświeżenie
    @IBAction func unwindToParentFromPodkat(segue: UIStoryboardSegue) {
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież...
            reloadPagerTabStripView()
        }
    }
    
    //przejście wywoływane z QRLocationVC - po zdekodowaniu QR kodu
    @IBAction func unwindToParent(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        //print("unwindToParent")
    }
    
    //---------------------------------------
    //pobranie aktualnych danych z serwera
    //---------------------------------------
    func getDataFromServer(){
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            siec = Network()

            //----- wskaźnik aktywności-----------
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //-------------------------------------

//zaremowane bo nie zdąża załadować wszystkich resatauracji i wychodzi że wybranej resta nie ma
            //skasowanie wszystkich restauracji z tabeli 'restauracje'
 //           _ = StephencelisDB.instance.deleteRestauracjeAll()
            
            //wczytanie wszystkich restauracji
 //           siec!.importujRestauracje()
            
            //skasowanie wszystkich podkategorii z tabeli 'podkategorie'
 //           _ = StephencelisDB.instance.deletePodkategorieAll()
            
            //wczytanie wszystkich podkategorii
 //           siec!.importujPodkategorie()
            
            //wczytanie (update) aktualnych wartości filtrów z www
 //           siec!.importujFiltr()
            
            //skasowanie wszystkich dań z tabeli 'dania'
            _ = StephencelisDB.instance.deleteDaniaAll()
            
            
            //pobranie lokalizacji z tabeli 'memory->mem_lok'
            location = StephencelisDB.instance.getMemory(memo: "mem_lok")
            print("location=")
            print(location!)
            //== pobranie danych filtrów z tabeli 'memory'
            //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
            memory1 = StephencelisDB.instance.getMemory(memo: "mem_filtr1")
            //mem_filtr2 (a:cenamin, b:cenamax, c:dla
            memory2 = StephencelisDB.instance.getMemory(memo: "mem_filtr2")
            
            var res: Int //czy powiódł się import Dań
            //czy jest restauracja? bo jeśli nie to załaduj domyślne (wszystkie z Konina)
            if location![0].e != "0" { //jeżeli aktualnie nie są wybrane "Wszystkie" rest w mieście
                let czy_jest_rest = StephencelisDB.instance.czyRestauracja(rest: location![0].e)
            print ("czy jest = ")
                print (czy_jest_rest)
                if czy_jest_rest > 0{ //wybrana restauracja istnieje w bazie (czy_jest_rest = 1)
                    Shared.shared.liczDania = 0 //zerowanie licznika pobranych dań
                    res = (siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())"))!
                    //print("111")
                }else{ //restauracji nie ma już w bazie www (bo np. została usunięta) - ładuje domyślne
                    Shared.shared.liczDania = 0 //zerowanie licznika pobranych dań
                    res = (siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=14&mia_id=1&rest=31&lang=\(Localize.currentLanguage())"))!
                    //print("222") rest=31 - Siesta
                }
            }else{ //są wybrane "Wszystkie" w wybranym mieście
                Shared.shared.liczDania = 0 //zerowanie licznika pobranych dań
                //pobranie dań dla wszystkich restauracji w miescie (bez filtrów bo skasowane i uaktualnione)
                res = (siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())"))!
                //print("333")
            }
            
            if res == 1 {
                AppDelegate.lubienie_zmienione = false  //pobrano aktualne oceny składników - lubienie altualne
                
                //opóźnienie żeby zdążyło przeładować dane
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                   
                    //Zwłoka do czasu pobrania wszystkich dań z internetu do bazy lokalnej
                    var aaa = 0
                    while Shared.shared.ileDanJSON != aaa {
                        sleep(1) //opóźnienie = 1 sek.
                        aaa = Shared.shared.liczDania + 1 //ilość wczytanych dań - licznik w Network.swift
                        //print(aaa)
                    }
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.reloadPagerTabStripView() //załadowanie danych z bazy lokalnej - odświeżenie widoku
                }
            }
        
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
    
    }
    
    
    //===============================
    //obsługa bocznego menu
    //===============================
    @IBAction func menu_action(_ sender: UIBarButtonItem) {
        if AppDelegate.menu_bool{
            show_menu()
        }else{
            close_menu()
        }
    }
    
    //przesuwanie ręczne bocznego menu
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction{
        case UISwipeGestureRecognizerDirection.right:
            //print("Right swipe")
            show_menu()
        case UISwipeGestureRecognizerDirection.left:
            //print("Left swipe")
            close_on_swipe()
        default:
            break
        }
    }
    
    func close_on_swipe(){
        if AppDelegate.menu_bool{
            //show_menu()
        }else{
            close_menu()
        }
    }
    
    func show_menu(){
        UIView.animate(withDuration: 0.3) { () ->Void in
            self.menu_vc.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.addChildViewController(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            AppDelegate.menu_bool = false
        }
    }

    func close_menu(){
        UIView.animate(withDuration: 0.3, animations: { () ->Void in
            self.menu_vc.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 60, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }) {(finished) in
                self.menu_vc.view.removeFromSuperview()
                }
            AppDelegate.menu_bool = true
        //print ("refresh = \(AppDelegate.refresh_list_meal)")
        if AppDelegate.refresh_list_meal{   //jeżeli jest 'true' to odśwież...
            reloadPagerTabStripView()
            //AppDelegate.refresh_list_meal = false   //... i ustaw na 'false'
            //moveToViewController(at: AppDelegate.which_page ) //przejęcie do odpowiedniej kategorii dań
            //      print("ktOra strona = \(AppDelegate.which_page)")
        }
    }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
    }
    
}

