//
//  Network.swift
//  Pager
//
//  Created by darys on 22.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import UIKit
import RestEssentials
import Localize_Swift

class Network: NSObject {
    
    //=======================================
    //pobranie danych wszystkich dań z serwera www do lokalnej bazy danych - do tabeli "dania"
    //=======================================
    func importujDania(link: String)->Int {
       // print("start")
//print("link w importujDania= \(link)")
        guard let rest = RestController.make(urlString: link) else {
            print("Bad URL")
            return 0
        }
        
        rest.get(withDeserializer: JSONDeserializer()) { result, httpResponse in
            
            do {
                let json = try result.value()
                //print(json)
                //print(json["dania"][1]["da_nazwa"])
                let total = json["total"].int!
                Shared.shared.ileDanJSON = total //żeby sprawdzać czy już wszystkie pobrane do bazy
                let czy_rest = json["czy_rest"].int!
                Shared.shared.czy_rest = czy_rest //0-dania dla miasta, 1- dania dla restauracji
                                                    //użyte tylko w LocationVC
                for i in 0..<total {
                    Shared.shared.liczDania = i //licznik pobranych dań używany w LocationVC, ParentVC
//print ("liczDania=")
//print(Shared.shared.liczDania)
                    let daid = json["dania"][i]["da_id"].string!
                    let nazwa = json["dania"][i]["da_nazwa"].string!
                    let opis = json["dania"][i]["da_opis"].string!
                    let idwer = json["dania"][i]["da_id_wer"].string!
                    let wersja = json["dania"][i]["da_wersja"].string!
                    let foto = json["dania"][i]["da_foto"].string!
                    let gdzie = json["dania"][i]["da_gdzie"].string!
                    let kategoria = json["dania"][i]["da_kategoria"].string!
                    let podkat = json["dania"][i]["da_podkategoria"].string!
                    let srednia = json["dania"][i]["da_srednia"].string!
                    let alergeny = json["dania"][i]["alergeny"].string!
                    let cena = json["dania"][i]["cena"].string!
                    let czas = json["dania"][i]["da_czas"].string!
                    let waga = json["dania"][i]["waga"].string!
                    let kcal = json["dania"][i]["kcal"].string!
                    let lubi = json["dania"][i]["ud0_da_lubi"].string!
                    let fav = json["dania"][i]["fav"].string!
                    
                    //można 'let id = ' zamiast '_'  - zwróci id zapisanego rekordu do bazy 'da_tid'
                    _ = StephencelisDB.instance.addDania(daid: daid, nazwa: nazwa, opis: opis, idwer: idwer, wersja: wersja, foto: foto, gdzie: gdzie, kategoria: kategoria, podkat: podkat, srednia: srednia, alergeny: alergeny, cena: cena, czas: czas, waga: waga, kcal: kcal, lubi: lubi, fav: fav)// {
                    //let danie = Mealdb(id: id, daid: daid, nazwa: nazwa, foto: foto, kategoria: kategoria, podkat: podkat, srednia: srednia, cena: cena, czas: czas, waga: waga, kcal: kcal, lubi: lubi)
                    //self.listaDan.append(danie!)
                    //działa tylko w ChildViewController1
                    //  DispatchQueue.main.async { //umożliwia wywołanie funkcji która powinna być w wątku głównym
                    //      tableView1.insertRows(at: [NSIndexPath(row: self.dania.count-1, section: 0) as IndexPath], with: .fade)
                    //  }
                    //}
                    
                }
            
            } catch {
                print("Error performing GET: \(error)")
            }
        }//rest.get
       return 1 
    }  //importujDania()
    
    //=======================================
    //pobranie danych wszystkich restauracji z serwera www do lokalnej bazy danych - do tabeli "restauracje"
    //Używane w: AppDelegate
    //=======================================
    func importujRestauracje() {
     //print("restauracje start")
        guard let rest = RestController.make(urlString: "http://www.cobytu.com/cbt.php?d=ios_restauracje") else {
            print("Bad URL")
            return
        }
       //print(rest)
        rest.get(withDeserializer: JSONDeserializer()) { result, httpResponse in
            
            do {
                let json = try result.value()
                //print(json)
                //print(json["dania"][1]["da_nazwa"])
                let total = json["total"].int!
                Shared.shared.ileRestaJSON = total //ilość restauracji
                
                for i in 0..<total {
                    Shared.shared.liczResta = i //licznik pobranych restauracji używany w ParentVC

                    let reid = json["restauracje"][i]["re_id"].string!
                    let nazwa = json["restauracje"][i]["re_nazwa"].string!
                    let obiekt = json["restauracje"][i]["re_obiekt"].string!
                    let adres = json["restauracje"][i]["re_adres"].string!
                    let mia_id = json["restauracje"][i]["re_mia_id"].string!
                    let miasto = json["restauracje"][i]["re_miasto"].string!
                    let woj_id = json["restauracje"][i]["re_woj_id"].string!
                    let woj = json["restauracje"][i]["re_woj"].string!
                    let dos = json["restauracje"][i]["re_dostawy"].string!
                    let opak = json["restauracje"][i]["re_opakowanie"].string!
                    let do_st = json["restauracje"][i]["re_do_stolika"].string!
                    let rez = json["restauracje"][i]["re_rezerwacje"].string!
                    let moge = json["restauracje"][i]["re_moge_jesc"].string!
    //print(reid)
                    
                    _ = StephencelisDB.instance.addRestauracje(reid: reid, nazwa: nazwa, obiekt: obiekt, adres: adres, mia_id: mia_id, miasto: miasto, woj_id: woj_id, woj: woj, dos: dos, opak: opak, do_st: do_st, rez: rez, moge: moge)
                }
            } catch {
                print("Error performing GET: \(error)")
            }
        }//rest.get
    }//importujRestauracje()
    
    //=======================================
    //pobranie wartości filtrów z serwera www do tabeli "memory" (mem_filtr1_0 i mem_filtr2_0) - zakres od min do max
    //=======================================
    func importujFiltr() {
        
        guard let rest = RestController.make(urlString: "https://www.cobytu.com/cbt_ios_filter_settings.php") else {
            print("Bad URL")
            return
        }
        
        rest.get(withDeserializer: JSONDeserializer()) { result, httpResponse in
            
            do {
                let json = try result.value()
                //print(json)
                //print(json["filter"][0]["cena_max0"])
                //let total = json["total"].int!  // bo jest tylko jeden rekord
                
                //for i in 0..<total {
                    let dla = json["filter"][0]["dla0"].string!
                    let czas_min = json["filter"][0]["czas_min0"].string!
                    let czas_max = json["filter"][0]["czas_max0"].string!
                    let cena_min = json["filter"][0]["cena_min0"].string!
                    let cena_max = json["filter"][0]["cena_max0"].string!
                    let waga_min = json["filter"][0]["waga_min0"].string!
                    let waga_max = json["filter"][0]["waga_max0"].string!
                    let kcal_min = json["filter"][0]["kcal_min0"].string!
                    let kcal_max = json["filter"][0]["kcal_max0"].string!
                    
                    _ = StephencelisDB.instance.updateMemory(mem: "mem_filtr1_0", a: czas_min, b: czas_max, c: waga_min, d: waga_max, e: kcal_min, f: kcal_max)
                    
                    _ = StephencelisDB.instance.updateMemory(mem: "mem_filtr2_0", a: cena_min, b: cena_max, c: dla, d: "", e: "", f: "")
                
                    _ = StephencelisDB.instance.updateMemory(mem: "mem_filtr1", a: czas_min, b: czas_max, c: waga_min, d: waga_max, e: kcal_min, f: kcal_max)
                
                    _ = StephencelisDB.instance.updateMemory(mem: "mem_filtr2", a: cena_min, b: cena_max, c: dla, d: "", e: "", f: "")
                    
               // }
            } catch {
                print("Error performing GET: \(error)")
            }
        }//rest.get
    }//importujFiltr()
    
    //=======================================
    //pobranie danych wszystkich podkategorii z serwera www do lokalnej bazy danych - do tabeli "podkategorie"
    //=======================================
    func importujPodkategorie() {
        
        guard let rest = RestController.make(urlString: "https://www.cobytu.com/cbt.php?d=ios_podkategorie&lang=\(Localize.currentLanguage())") else {
            print("Bad URL")
            return
        }
        
        rest.get(withDeserializer: JSONDeserializer()) { result, httpResponse in
            
            do {
                let json = try result.value()
                //print(json)
                //print(json["dania"][1]["da_nazwa"])
                let total = json["total"].int!
                
                for i in 0..<total {
                    let pkid = json["podkategorie"][i]["pk_id"].string!
                    let kolejnosc = json["podkategorie"][i]["pk_kolejnosc"].string!
                    let kaid = json["podkategorie"][i]["pk_ka_id"].string!
                    let nazwa = json["podkategorie"][i]["pk_nazwa"].string!
                    
                    
                    _ = StephencelisDB.instance.addPodkategorie(pkid: pkid, kolejnosc: kolejnosc, kaid: kaid, nazwa: nazwa)
                }
            } catch {
                print("Error performing GET: \(error)")
            }
        }//rest.get
    }//importujPodkategorie()
    

    
    //=============================================
    //pobieranie zdjęć wyświetlanych w liście dań
    //=============================================
    func getPictureFromServer(imageName:String, callback: @escaping (UIImage)->Void){
        let address = "https://www.cobytu.com/foto/\(imageName)"
    //print(imageName)
        let url = NSURL(string: address)
        let request = NSURLRequest(url: url! as URL)
        
        let ses = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data,response,_)->Void in
            callback(UIImage(data: data!)!)
        })
        ses.resume()
    }


}
