//
//  AppDelegate.swift
//  Pager
//
//  Created by darys on 03.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import Localize_Swift
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var siec: Network?
    static var menu_bool = true //true - menu boczne schowane, można je wysunąć (w ParentViewController)
    static var refresh_list_meal = true //false - nie potrzeba odświeżać listy dań (w ParentViewController)
    static var lubienie_zmienione = true //false - lubienie składników (oceny) nie zostały zmienione
    static var which_page = 4 //numer strony (index) kategorii dań do wyświetlenia
    static var wersja = ["1","0","15","08","08","2019"] //wersja aplikacji 1.0.0, data publikacji 25.02.2018 
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application,
            didFinishLaunchingWithOptions:launchOptions)
        
        // Override point for customization after application launch.
        //Dostosowywanie po uruchomieniu aplikacji.
        
       // _ = StephencelisDB.instance.dropDania()
       // _ = StephencelisDB.instance.dropRestauracje()
       // _ = StephencelisDB.instance.dropMemory()//
        //_ = StephencelisDB.instance.dropPodkategorie()
        
        UINavigationBar.appearance().barTintColor = Shared.shared.malinaColor //ustawienie koloru paska rodzajów dań
        UINavigationBar.appearance().tintColor = UIColor.white //kolor nazw rodzajów dań na pasku
        
        siec = Network()
        
        let czy_sa_dania = StephencelisDB.instance.czyDania()//jeżeli są dania tzn. że są bazy
        print("AppDelegate - ilość dań w bazie \(czy_sa_dania)")
        
        var nowa_bool = false  //czy nowa wersja apki
        if (czy_sa_dania != 0){ //jeżeli są bazy
            //sprawdzenie wersji zainstalowanej aplikacji i decyzja czy przeinstalować bazy
            var memory_ver: [Memorydb]? = []
            memory_ver = StephencelisDB.instance.getMemory(memo: "mem_ver")
            //  print("wersja apki0w bazie \(memory_ver![0].a).\(memory_ver![0].b).\(memory_ver![0].c)")
            if (memory_ver![0].c != AppDelegate.wersja[2]){
                nowa_bool = true  //czy nowa wersja apki
            }
        }
        
        if (czy_sa_dania == 0) || (nowa_bool == true){
            print("AppDelegate - budowanie tabel domyślnych")
            //kasowanie tabel w bazie (bo mogą być a wtedy dane się powielą)
            _ = StephencelisDB.instance.dropDania()
            _ = StephencelisDB.instance.dropRestauracje()
            _ = StephencelisDB.instance.dropMemory()
            _ = StephencelisDB.instance.dropPodkategorie()
            _ = StephencelisDB.instance.dropRodzaje()
            _ = StephencelisDB.instance.dropNazwy()
            _ = StephencelisDB.instance.dropFormy()

            //utworzenie tabel w bazie jeżeli ich nie ma
            _ = StephencelisDB.instance.createTableDania()
            _ = StephencelisDB.instance.createTableRestauracje()
            _ = StephencelisDB.instance.createTableMemory()
            _ = StephencelisDB.instance.createTablePodkategorie()
            _ = StephencelisDB.instance.createTableRodzaje()
            _ = StephencelisDB.instance.createTableNazwy()
            _ = StephencelisDB.instance.createTableFormy()
            
            Localize.setCurrentLanguage("") //ustawienie języka
             print ("aktualny0 = \(Localize.currentLanguage())")
            
            //wczytanie dań z domyśnej lokalizacji (dla Konina)
            //niepotrzebne bo sie dubluje bo wczytuje sie w ParentViewController w viewDidAppear
            //bo refresh_list_meal = true w AppDelegate
            //_ = siec!.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania1&uz=&woj_id=14&mia_id=1&rest=0&lang=\(Localize.currentLanguage())")
            
            //wczytanie wszystkich restauracji - funkcja w Network.swift
            siec!.importujRestauracje()
            
            //wczytanie wszystkich podkategorii - funkcja w Network.swift
            siec!.importujPodkategorie()
            
            //==utworzenie pamięci parametrów aplikacji w bazie lokalnej (bez wartości)
            //'mem_lok' lokalizacja(tu domyślna) (a:woj_id, b:woj, c:mia_id, d:miasto, e:re_id, f:rest)
            _ = StephencelisDB.instance.addMemory(mem: "mem_lok", a: "14", b: "wielkopolskie", c: "1", d: "Konin", e: "31", f: "Siesta") //"00" oznacza "Wszystkie" - e: "0", f: "00"
            
            //'mem_danie' (a: id dania klikniętego na liście dań dla wyświetlenia szczegółów, b: nazwa pliku foto, c: pierwszy alergen zalogowanego lub "brak", d: nazwa dania)
            _ = StephencelisDB.instance.addMemory(mem: "mem_danie", a: "", b: "", c: "", d: "", e: "", f: "")
            
            //'mem_app' (a:język,b:lista(1-z opisami),c:ostrzeżenia włacz.  )
            _ = StephencelisDB.instance.addMemory(mem: "mem_app", a: "", b: "1", c: "1", d: "", e: "", f: "")
            
            //'mem_user' (a:uz_id, b:uz_login, c:uz_email, d:uz_student, e:uz_au_id, f:uz_)
            _ = StephencelisDB.instance.addMemory(mem: "mem_user", a: "", b: "", c: "", d: "", e: "", f: "")
           
            //'mem_ver' (a:b:c: wersja apki,d:e:f: data publikacji  )
            _ = StephencelisDB.instance.addMemory(mem: "mem_ver", a: AppDelegate.wersja[0], b: AppDelegate.wersja[1], c: AppDelegate.wersja[2], d: AppDelegate.wersja[3], e: AppDelegate.wersja[4], f: AppDelegate.wersja[5])
            
            //parametry filtrów pobrane z www (parametry określają wartości graniczne filtrów)
            //mem_filtr1_0 (default) (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
            _ = StephencelisDB.instance.addMemory(mem: "mem_filtr1_0", a: "", b: "", c: "", d: "", e: "", f: "")
            //mem_filtr2_0 (default) (a:cenamin, b:cenamax, c:dla
            _ = StephencelisDB.instance.addMemory(mem: "mem_filtr2_0", a: "", b: "", c: "", d: "", e: "", f: "")
            //parametry filtrów ustawiane przez użytkownika apki
            //mem_filtr1 (a:czasmin, b:czasmax, c:wagamin, d:wagamax, e:kcalmin, f:kcalma)
            _ = StephencelisDB.instance.addMemory(mem: "mem_filtr1", a: "", b: "", c: "", d: "", e: "", f: "")
            //mem_filtr2 (a:cenamin, b:cenamax, c:dla
            _ = StephencelisDB.instance.addMemory(mem: "mem_filtr2", a: "", b: "", c: "", d: "", e: "", f: "")
            
            //wczytanie aktualnych wartości filtrów z www
            siec!.importujFiltr()
        
        }
        
        //ustawienie języka w apce. 
        var memory_app: [Memorydb]? = []
        memory_app = StephencelisDB.instance.getMemory(memo: "mem_app") //a:język,b:lista, c:ostrzeżenia,
        if Shared.shared.lang == nil {Shared.shared.lang = memory_app![0].a}  //jeżeli a:"" - domyślny
        if Shared.shared.lista == nil {Shared.shared.lista = memory_app![0].b} //1-opisy, 2-zdjęcia
        if Shared.shared.ostrzezenia == nil {Shared.shared.ostrzezenia = memory_app![0].c} //1-włacz, 2-wyłacz
        
        //utawienie opcji "mogę jeść" dla wybranej restauracji
/*        var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
        location = StephencelisDB.instance.getMemory(memo: "mem_lok")
        var restauracja: [Restaurantdb] = []  //dane restauracji wybranej w lokalizacji
        restauracja = StephencelisDB.instance.getRestaurant(res: location![0].f)
        if location![0].f == "00" { //"00" oznacza "Wszystkie"
            print("Wszystkie")
        }else{
//            Shared.shared.mogeJesc = restauracja[0].moge
        }
*/
        //zalogowanie usera jeżeli są dane w bazie mem_user (przepisanie danych do Shared)
        var memory_user: [Memorydb]? = []
        memory_user = StephencelisDB.instance.getMemory(memo: "mem_user") //a:uz_id, b:uz_login, c:uz_email
        if Shared.shared.uz_id == nil {Shared.shared.uz_id = memory_user![0].a}  //jeżeli a:"" - nie jest zalogowany
        if Shared.shared.uz_login == nil {Shared.shared.uz_login = memory_user![0].b}
        if Shared.shared.uz_email == nil {Shared.shared.uz_email = memory_user![0].c}
        print("uz_id=\(Shared.shared.uz_id!)")
        
        Localize.setCurrentLanguage("\(Shared.shared.lang!)") //ustawienie języka
        //print ("aktualny język = \(Localize.currentLanguage())")
        //print ("aktualny_ustawiony = \(Shared.shared.lang!)")
        //print ("lista = \(Shared.shared.lista!)")
        
        //zainicjowanie podkategorii pustym stringiem (czyli domyślnie - podkategorie wszystkie)
        Shared.shared.podkategoria = ""
        Shared.shared.strefa = 0 //0 - Strefa 1 - domyślne ustawienie strefy dostawy(również w Location i QRLocation)
        Shared.shared.platnosc = 0 //0 - brak danych - domyślne ustawienie sposobu płatności za dostawę
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //Aplikacja przechodzi w stan zatrzymania chwilowego.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        //Uaktywnienie aplikacji po wcześniejszym wstrzymaniu.
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //Zrestartuj wszystkie zadania, które zostały wstrzymane (lub jeszcze nie zostały uruchomione), gdy aplikacja była nieaktywna. Jeśli aplikacja była wcześniej w tle, opcjonalnie odśwież interfejs użytkownika.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

