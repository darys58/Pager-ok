//
//  ListaDan.swift
//  Pager
//
//  Created by darys on 21.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//

import Foundation
import RestEssentials

class ListaDan {
   
    var listaDan = [Mealdb]()

    func dodaj() {
        
        
        guard let rest = RestController.make(urlString: "http://www.cobytu.com/cbt.php?d=ios_dania&uz=Darek&woj_id=14&mia_id=1&re=1") else {
            print("Bad URL")
            return
        }
        
        rest.get(withDeserializer: JSONDeserializer()) { result, httpResponse in
            
            do {
                // var nazwa = "Test nazwy."
                //let cena = "test ceny"
                let photo = "test foto"
                
                let json = try result.value()
                //print(json)
                print(json["dania"][1]["da_nazwa"])
                
                //var daid = json["dania"][0]["da_id"]
                let nazwa = json["dania"][3]["da_nazwa"].string!
                let cena = json["dania"][3]["cena"].string!
                print(nazwa)
                
                
                
                if let id = StephencelisDB.instance.addDania(nazwa: nazwa, cena: cena, photo: photo) {
                    let danie = Mealdb(id: id, nazwa: nazwa, cena: cena, photo: photo)
                    self.listaDan.append(danie!)
                    //tu chyba niepotrzebne bo nie ma uaktualniania poszczególnych dań
                    //  DispatchQueue.main.async { //umożliwia wywołanie funkcji która powinna być w wątku głównym
                    //      tableView1.insertRows(at: [NSIndexPath(row: self.dania.count-1, section: 0) as IndexPath], with: .fade)
                    //  }
                }
                /*      var foto = json["dania"][0]["da_foto"]
                 var kategoria = json["dania"][0]["da_kategoria"]
                 var podkat = json["dania"][0]["da_podkategoria"]
                 var srednia = json["dania"][0]["da_srednia"]
                 var cena = json["dania"][0]["cena"]
                 var czas = json["dania"][0]["da_czas"]
                 var waga = json["dania"][0]["waga"]
                 var kcal = json["dania"][0]["kcal"]
                 var lubi = json["dania"][0]["ud0_da_lubi"]
                 */    /*            if let id = StephencelisDB.instance.insDania( daid: daid, nazwa: nazwa, foto: foto, kategoria: kategoria, podkat: podkat, srednia: srednia, cena: cena, czas: czas, waga: waga, kcal: kcal, lubi: lubi) {
                 let danie = Mealdb(id: id, daid: daid, nazwa: nazwa, foto: foto, kategoria: kategoria, podkat: podkat, srednia: srednia, cena: cena, czas: czas, waga: waga, kcal: kcal, lubi: lubi)
                 dania.append(danie!)
                 }
                 */
                
            } catch {
                print("Error performing GET: \(error)")
            }
        }
    }
    
    
    


}
