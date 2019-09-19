//
//  StephencelisDB.swift
//  Pager
//
//  Created by darys on 17.12.2017.
//  Copyright © 2017 darys. All rights reserved.
//
import SQLite
import SQLite3

class StephencelisDB {
   
    //zainicjowaie instancji klasy, używając wzorca "Singleton"
    static let instance = StephencelisDB()
    //deklaracja obiektu bazy danych typu Connection
    private let db: Connection?
    
    //===============================
    //deklaracja tabeli i jej kolumn
    //===============================
    private let dania = Table("dania")                            //tabela 'dania' w apce
    private let da_tid = Expression<Int64>("da_tid")              //id w tabeli 'dania'
    private let da_id = Expression<String>("da_id")               //da_id
    private let da_nazwa = Expression<String>("da_nazwa")         //da_nazwa
    private let da_opis = Expression<String>("da_opis")           //da_opis
    private let da_id_wer = Expression<String>("da_id_wer")       //da_id_wer
    private let da_wersja = Expression<String>("da_wersja")       //da_wersja
    private let da_foto = Expression<String>("da_foto")           //da_foto
    private let da_gdzie = Expression<String>("da_gdzie")         //da_gdzie
    private let da_kategoria = Expression<String>("da_kategoria") //da_kategoria
    private let da_podkat = Expression<String>("da_podkat")       //da_podkategoria
    private let da_srednia = Expression<String>("da_srednia")     //da_srednia
    private let da_alergeny = Expression<String>("da_alergeny")   //alergeny
    private let da_cena = Expression<String>("da_cena")           //cena
    private let da_czas = Expression<String>("da_czas")           //da_czas
    private let da_waga = Expression<String>("da_waga")           //waga
    private let da_kcal = Expression<String>("da_kcal")           //kcal
    private let da_lubi = Expression<String>("da_lubi")           //ud0_da_lubi
    private let da_fav = Expression<String>("da_fav")             //fav

    private let restauracje = Table("restauracje")
    private let re_tid = Expression<Int64>("re_tid")
    private let re_id = Expression<String>("re_id")
    private let re_nazwa = Expression<String>("re_nazwa")
    private let re_obiekt = Expression<String>("re_obiekt")
    private let re_adres = Expression<String>("re_adres")
    private let re_mia_id = Expression<String>("re_mia_id")
    private let re_miasto = Expression<String>("re_miasto")
    private let re_woj_id = Expression<String>("re_woj_id")
    private let re_woj = Expression<String>("re_woj")
    private let re_dostawy = Expression<String>("re_dostawy")
    private let re_opakowanie = Expression<String>("re_opakowanie")
    private let re_do_stolika = Expression<String>("re_do_stolika")
    private let re_rezerwacje = Expression<String>("re_rezerwacje")
    private let re_moge_jesc = Expression<String>("re_moge_jesc")
    
    private let memory = Table("memory")                  //nazwa pamięci:
    private let mem_tid = Expression<Int64>("lo_tid")//lokalizacji |dania    |apki   |user
    private let mem_name = Expression<String>("mem_name") //mem_lok|mem_danie|mem_app|mem_user
    private let mem_a = Expression<String>("mem_a")       //woj_id |daid     |język  |uz_id
    private let mem_b = Expression<String>("mem_b")       //woj    |foto     |lista  |uz_login
    private let mem_c = Expression<String>("mem_c")       //mia_id |alergeny |       |uz_email
    private let mem_d = Expression<String>("mem_d")       //mia    |                 |uz_student
    private let mem_e = Expression<String>("mem_e")       //rest   |                 |uz_au_id
    private let mem_f = Expression<String>("mem_f")       //resta  |                 |uz_???
   
    private let podkategorie = Table("podkategorie")
    private let pk_tid = Expression<Int64>("pk_tid")
    private let pk_id = Expression<String>("pk_id")
    private let pk_kolejnosc = Expression<String>("pk_kolejnosc")
    private let pk_ka_id = Expression<String>("pk_ka_id")
    private let pk_nazwa = Expression<String>("pk_nazwa")
    
    private let rodzaje = Table("rodzaje") //rodzaje/karegorie składników
    private let rd_tid = Expression<Int64>("rd_tid")
    private let rd_id = Expression<Int>("rd_id")
    private let rd_rodzaj = Expression<String>("rd_rodzaj")
    private let total = Expression<Int>("total")
    private let do_oceny = Expression<Int>("do_oceny")
    private let o01 = Expression<Int>("o01")
    private let o02 = Expression<Int>("o02")
    private let o03 = Expression<Int>("o03")
    private let o04 = Expression<Int>("o04")
    private let o05 = Expression<Int>("o05")
    private let o06 = Expression<Int>("o06")
    private let o07 = Expression<Int>("o07")
    private let o08 = Expression<Int>("o08")
    private let o09 = Expression<Int>("o09")
    private let o10 = Expression<Int>("o10")
    private let rd_ocena = Expression<Int>("rd_ocena")
    
    private let nazwy = Table("nazwy") //nazwy składników
    private let nd_tid = Expression<Int64>("nd_tid")
    private let nd_id = Expression<Int>("nd_id")
    private let nd_nazwa = Expression<String>("nd_nazwa")
    private let nd_total = Expression<Int>("nd_total")
    private let nd_do_oceny = Expression<Int>("nd_do_oceny")
    private let no01 = Expression<Int>("no01")
    private let no02 = Expression<Int>("no02")
    private let no03 = Expression<Int>("no03")
    private let no04 = Expression<Int>("no04")
    private let no05 = Expression<Int>("no05")
    private let no06 = Expression<Int>("no06")
    private let no07 = Expression<Int>("no07")
    private let no08 = Expression<Int>("no08")
    private let no09 = Expression<Int>("no09")
    private let no10 = Expression<Int>("no10")
    private let nd_ocena = Expression<Int>("nd_ocena")
    
    private let formy = Table("formy") //formy składników
    private let fd_tid = Expression<Int64>("fd_tid")
    private let fd_id = Expression<Int>("fd_id")
    private let fd_forma = Expression<String>("fd_forma")
    private let do_id = Expression<Int>("do_id")
    private let do_kcal100 = Expression<Int>("do_kcal100")
    private let ud_lubi = Expression<Int>("ud_lubi")
    
    // Konstruktor
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Stephencelis.sqlite3") //otworzenie połączenia z bazą
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        //dropDania()
        //deleteDaniaAll()
        //dropRestauracje()

        
        createTableDania()  //utworzenie tabeli 'dania' jeżeli jej nie ma
        createTableRestauracje()
        createTableMemory()
        createTablePodkategorie()
        createTableRodzaje()
        createTableNazwy()
        createTableFormy()
    }
    
    //== FORMY SKŁADNIKÓW =========================================================
    //============================================
    //tworzenie tabeli 'formy' jeżeli jej nie ma
    //============================================
    func createTableFormy() {
        do {
            try db!.run(formy.create(ifNotExists: true) { table in
                table.column(fd_tid, primaryKey: true)
                table.column(fd_id, unique: true)
                table.column(fd_forma)
                table.column(do_id)
                table.column(do_kcal100)
                table.column(ud_lubi)
            })
        } catch {
            print("Unable to create table 'formy'")
        }
    }
    
    //============================
    //dodawanie do tabeli 'formy'
    //============================
    func addFormy(fdid: Int, forma: String, doid: Int, dokcal: Int, udlubi: Int) -> Int64? {
        do {
            let insert = formy.insert(fd_id <- fdid, fd_forma <- forma, do_id <- doid, do_kcal100 <- dokcal, ud_lubi <- udlubi )
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert 'formy' failed")
            return -1
        }
    }
    
    //============================
    //update oceny wybranej formy fd_id w tabeli 'formy'
    //============================
    func updateFormy(fdid: Int, doid: Int, udlubi: Int){
        do{
            try db!.run(formy.filter(fd_id == fdid).update(do_id <- doid, ud_lubi <- udlubi))
        }catch {
            print("Update 'formy' failed")
        }
    }
    
    
    //===========================
    //pobieranie formy składników z tabeli 'formy'
    //===========================
    func getFormy() -> [FormaSk] {
        var forma = [FormaSk]()
        
        do {
            for fs in try db!.prepare(self.formy) {
                forma.append(FormaSk(
                    fd_id: fs[fd_id],
                    fd_forma: fs[fd_forma],
                    do_id: fs[do_id],
                    do_kcal100: fs[do_kcal100],
                    ud_lubi: fs[ud_lubi]))
            }
        } catch {
            print("Select 'forma' failed")
        }
        return forma
    }
    
    //***********************************
    //usunięcie danych z tabeli 'formy' - dla "Zaktualizuj dane" ???
    //***********************************
    func deleteFormyAll() -> Bool{
        do {
            try db!.run(formy.delete())
            return true
        } catch {
            print("Delete all data in table 'formy' failed")
        }
        return false
    }
    
    //*********************************
    //usunięcie tabeli 'formy'
    //*********************************
    func dropFormy() -> Bool{
        do {
            try db!.run(formy.drop())
            return true
        } catch {
            print("Drop table 'formy' failed")
        }
        return false
    }
    
    
    
    //== NAZWY SKŁADNIKÓW =========================================================
    //============================================
    //tworzenie tabeli 'nazwy' jeżeli jej nie ma
    //============================================
    func createTableNazwy() {
        do {
            try db!.run(nazwy.create(ifNotExists: true) { table in
                table.column(nd_tid, primaryKey: true)
                table.column(nd_id, unique: true)
                table.column(nd_nazwa)
                table.column(nd_total)
                table.column(nd_do_oceny)
                table.column(no01)
                table.column(no02)
                table.column(no03)
                table.column(no04)
                table.column(no05)
                table.column(no06)
                table.column(no07)
                table.column(no08)
                table.column(no09)
                table.column(no10)
                table.column(nd_ocena)
            })
        } catch {
            print("Unable to create table 'nazwy'")
        }
    }
    
    //============================
    //dodawanie do tabeli 'nazwy'
    //============================
    func addNazwy(ndid: Int, nazwa: String, tot: Int, dooceny: Int, b01: Int, b02: Int, b03: Int, b04: Int, b05: Int, b06: Int, b07: Int, b08: Int, b09: Int, b10: Int, ndocena: Int) -> Int64? {
        do {
            let insert = nazwy.insert(nd_id <- ndid, nd_nazwa <- nazwa, nd_total <- tot, nd_do_oceny <- dooceny, no01 <- b01, no02 <- b02, no03 <- b03, no04 <- b04, no05 <- b05, no06 <- b06, no07 <- b07, no08 <- b08, no09 <- b09, no10 <- b10, nd_ocena <- ndocena )
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert 'nazwy' failed")
            return -1
        }
    }
    
    //============================
    //update oceny wybranej nazwy nd_id w tabeli 'nazwy'
    //============================
    func updateNazwy(ndid: Int, dooceny: Int, b01: Int, b02: Int, b03: Int, b04: Int, b05: Int, b06: Int, b07: Int, b08: Int, b09: Int, b10: Int, ndocena: Int){
        do{
            try db!.run(nazwy.filter(nd_id == ndid).update(nd_do_oceny <- dooceny, no01 <- b01, no02 <- b02, no03 <- b03,  no04 <- b04,  no05 <- b05,  no06 <- b06,  no07 <- b07,  no08 <- b08,  no09 <- b09,  no10 <- b10, nd_ocena <- ndocena))
        }catch {
            print("Update 'nazwy' failed")
        }
    }
    
    
    //===========================
    //pobieranie nazwy składników z tabeli 'nazwy'
    //===========================
    func getNazwy() -> [NazwaSk] {
        var nazwa = [NazwaSk]()
        
        do {
            for ns in try db!.prepare(self.nazwy) {
                nazwa.append(NazwaSk(
                    nd_id: ns[nd_id],
                    nd_nazwa: ns[nd_nazwa],
                    nd_total: ns[nd_total],
                    nd_do_oceny: ns[nd_do_oceny],
                    no01: ns[no01],
                    no02: ns[no02],
                    no03: ns[no03],
                    no04: ns[no04],
                    no05: ns[no05],
                    no06: ns[no06],
                    no07: ns[no07],
                    no08: ns[no08],
                    no09: ns[no09],
                    no10: ns[no10],
                    nd_ocena: ns[nd_ocena]))
            }
        } catch {
            print("Select nazwa failed")
        }
        return nazwa
    }
    
    //***********************************
    //usunięcie danych z tabeli 'nazwy' - dla "Zaktualizuj dane" ???
    //***********************************
    func deleteNazwyAll() -> Bool{
        do {
            try db!.run(nazwy.delete())
            return true
        } catch {
            print("Delete all data in table 'nazwy' failed")
        }
        return false
    }
    
    //*********************************
    //usunięcie tabeli 'nazwy'
    //*********************************
    func dropNazwy() -> Bool{
        do {
            try db!.run(nazwy.drop())
            return true
        } catch {
            print("Drop table 'nazwy' failed")
        }
        return false
    }
    
    
    
    //== RODZAJE SKŁADNIKÓW =========================================================
    //============================================
    //tworzenie tabeli 'rodzaje' jeżeli jej nie ma
    //============================================
    func createTableRodzaje() {
        do {
            try db!.run(rodzaje.create(ifNotExists: true) { table in
                table.column(rd_tid, primaryKey: true)
                table.column(rd_id, unique: true)
                table.column(rd_rodzaj)
                table.column(total)
                table.column(do_oceny)
                table.column(o01)
                table.column(o02)
                table.column(o03)
                table.column(o04)
                table.column(o05)
                table.column(o06)
                table.column(o07)
                table.column(o08)
                table.column(o09)
                table.column(o10)
                table.column(rd_ocena)
            })
        } catch {
            print("Unable to create table 'rodzaje'")
        }
    }
    
    //============================
    //dodanie kategorii do tabeli 'rodzaje'
    //============================
    func addRodzaje(rdid: Int, rodzaj: String, tot: Int, dooceny: Int, b01: Int, b02: Int, b03: Int, b04: Int, b05: Int, b06: Int, b07: Int, b08: Int, b09: Int, b10: Int, rdocena: Int) -> Int64? {
        do {
            let insert = rodzaje.insert(rd_id <- rdid, rd_rodzaj <- rodzaj, total <- tot, do_oceny <- dooceny, o01 <- b01, o02 <- b02, o03 <- b03, o04 <- b04, o05 <- b05, o06 <- b06, o07 <- b07, o08 <- b08, o09 <- b09, o10 <- b10, rd_ocena <- rdocena )
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert 'rodzaje' failed")
            return -1
        }
    }
    
    //============================
    //update oceny wybranej kategorii rd_id w tabeli 'rodzaje'
    //============================
    func updateRodzaje(rdid: Int, dooceny: Int, b01: Int, b02: Int, b03: Int, b04: Int, b05: Int, b06: Int, b07: Int, b08: Int, b09: Int, b10: Int, rdocena: Int){
        do{
            try db!.run(rodzaje.filter(rd_id == rdid).update(do_oceny <- dooceny, o01 <- b01, o02 <- b02, o03 <- b03,  o04 <- b04,  o05 <- b05,  o06 <- b06,  o07 <- b07,  o08 <- b08,  o09 <- b09,  o10 <- b10, rd_ocena <- rdocena))
        }catch {
            print("Update 'rodzaje' failed")
        }
    }
    
    
    //===========================
    //pobieranie kategorii składników z tabeli 'rodzaje'
    //===========================
    func getRodzaje() -> [RodzajSk] {
        var rodzaj = [RodzajSk]()
        
        do {
            for rs in try db!.prepare(self.rodzaje) {
                rodzaj.append(RodzajSk(
                    rd_id: rs[rd_id],
                    rd_rodzaj: rs[rd_rodzaj],
                    total: rs[total],
                    do_oceny: rs[do_oceny],
                    o01: rs[o01],
                    o02: rs[o02],
                    o03: rs[o03],
                    o04: rs[o04],
                    o05: rs[o05],
                    o06: rs[o06],
                    o07: rs[o07],
                    o08: rs[o08],
                    o09: rs[o09],
                    o10: rs[o10],
                    rd_ocena: rs[rd_ocena]))
            }
        } catch {
            print("Select restaurant failed")
        }
        return rodzaj
    }
    
    //***********************************
    //usunięcie danych z tabeli 'rodzaje' - dla "Zaktualizuj dane" ???
    //***********************************
    func deleteRodzajeAll() -> Bool{
        do {
            try db!.run(rodzaje.delete())
            return true
        } catch {
            print("Delete all data in table 'rodzaje' failed")
        }
        return false
    }
    
    //*********************************
    //usunięcie tabeli 'rodzaje'
    //*********************************
    func dropRodzaje() -> Bool{
        do {
            try db!.run(rodzaje.drop())
            return true
        } catch {
            print("Drop table 'rodzaje' failed")
        }
        return false
    }
    
    
    //== PODKATEGORIE ===================================================================
    //============================================
    //tworzenie tabeli 'podkategorie' jeżeli jej nie ma
    //============================================
    func createTablePodkategorie() {
        do {
            try db!.run(podkategorie.create(ifNotExists: true) { table in
                table.column(pk_tid, primaryKey: true)
                table.column(pk_id, unique: true)
                table.column(pk_kolejnosc)
                table.column(pk_ka_id)
                table.column(pk_nazwa)
            })
        } catch {
            print("Unable to create table 'podkategorie'")
        }
    }
    
    //============================
    //dodawanie do tabeli 'podkategorie'
    //============================
    func addPodkategorie(pkid: String, kolejnosc: String, kaid: String, nazwa: String) -> Int64? {
        do {
            let insert = podkategorie.insert(pk_id <- pkid, pk_kolejnosc <- kolejnosc, pk_ka_id <- kaid, pk_nazwa <- nazwa)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert 'podkategorie' failed")
            return -1
        }
    }
    
    //===========================
    //pobieranie nazw podkategorii dla wybranej kategorii z tabeli 'podkategorie'
    //===========================
    func getPodkategorie(kaid: String) -> [String] {
        var podkat = [String]()
        
        do {
            podkat.append("00")
            for podk in try db!.prepare(self.podkategorie.where(pk_ka_id == kaid)) {
                
                podkat.append(podk[pk_nazwa])
            }
        } catch {
            print("Select restaurants failed")
        }
        return podkat
    }
   
    //===========================
    //pobieranie pk_id podkategorii na podstawie jej nazwy z tabeli 'podkategorie'
    //===========================
    func getPodkategoriaId(nazwa: String) -> [Podkategoriedb] {
        var podkat = [Podkategoriedb]()
        
        do {
            for pk in try db!.prepare(self.podkategorie.filter(pk_nazwa == nazwa)) {
                podkat.append(Podkategoriedb(
                    id: pk[pk_tid],
                    pkid: pk[pk_id],
                    kolejnosc: pk[pk_kolejnosc],
                    kaid: pk[pk_ka_id],
                    nazwa: pk[pk_nazwa])!)
            }
        } catch {
            print("Select podkategorie failed")
        }
        return podkat
    }
 
    //***********************************
    //usunięcie danych z tabeli 'podkategorie' - dla "Zaktualizuj dane"
    //***********************************
    func deletePodkategorieAll() -> Bool{
        do {
            try db!.run(podkategorie.delete())
            return true
        } catch {
            print("Delete all data in table 'podkategorie' failed")
        }
        return false
    }
    
    //*********************************
    //usunięcie tabeli 'restauracje'
    //*********************************
    func dropPodkategorie() -> Bool{
        do {
            try db!.run(podkategorie.drop())
            return true
        } catch {
            print("Drop table 'podkategorie' failed")
        }
        return false
    }
    
    
    
    //== MEMORY ===================================================================
    //============================================
    //tworzenie tabeli 'memory' jeżeli jej nie ma
    //============================================
    func createTableMemory() {
        do {
            try db!.run(memory.create(ifNotExists: true) { table in
                table.column(mem_tid, primaryKey: true)
                table.column(mem_name, unique: true)  //nazwa pamięci lokalizacji musi być unikalna
                table.column(mem_a)
                table.column(mem_b)
                table.column(mem_c)
                table.column(mem_d)
                table.column(mem_e)
                table.column(mem_f)
            })
        } catch {
            print("Unable to create table 'memory'")
        }
    }

    //============================
    //dodawanie do tabeli 'memory'
    //============================
    func addMemory(mem: String, a: String, b: String, c: String, d: String, e: String, f: String) -> Int64? {
        do {
            let insert = memory.insert( mem_name <- mem, mem_a <- a, mem_b <- b, mem_c <- c, mem_d <- d,  mem_e <- e,  mem_f <- f)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert 'memory' failed")
            return -1
        }
    }
    
    //============================
    //update id dania tzn. rekordu gdzie mem_name == 'mem_danie' w tabeli 'memory'
    //============================
    func updateMemory(mem: String, a: String, b: String, c: String, d: String, e: String, f: String){
        do{
            try db!.run(memory.filter(mem_name == mem).update(mem_a <- a, mem_b <- b, mem_c <- c, mem_d <- d,  mem_e <- e,  mem_f <- f))
        }catch {
            print("Update 'memory' failed")
        }
    }
    
    
    //===========================
    //pobieranie z tabeli 'memory'
    //===========================
    func getMemory(memo: String) -> [Memorydb] {
        var meee = [Memorydb]()
        
        do {
            for lok in try db!.prepare(self.memory.where(mem_name == memo)) {
                meee.append(Memorydb(
                    id: lok[mem_tid],
                    mem: lok[mem_name],
                    a: lok[mem_a],
                    b: lok[mem_b],
                    c: lok[mem_c],
                    d: lok[mem_d],
                    e: lok[mem_e],
                    f: lok[mem_f])!)
            }
        } catch {
            print("Get 'memory' failed")
        }
        return meee
    }

    //*********************************
    //usunięcie tabeli 'memory'
    //*********************************
    func dropMemory() -> Bool{
        do {
            try db!.run(memory.drop())
            return true
        } catch {
            print("Drop table 'memory' failed")
        }
        return false
    }
    
    //== RESTAURACJE ==============================================================
    //============================================
    //tworzenie tabeli 'restauracje' jeżeli jej nie ma
    //============================================
    func createTableRestauracje() {
        do {
            try db!.run(restauracje.create(ifNotExists: true) { table in
                table.column(re_tid, primaryKey: true)
                table.column(re_id)
                table.column(re_nazwa)
                table.column(re_obiekt)
                table.column(re_adres)
                table.column(re_mia_id)
                table.column(re_miasto)
                table.column(re_woj_id)
                table.column(re_woj)
                table.column(re_dostawy)
                table.column(re_opakowanie)
                table.column(re_do_stolika)
                table.column(re_rezerwacje)
                table.column(re_moge_jesc)
            })
        } catch {
            print("Unable to create table 'restauracje'")
        }
    }
    
    //============================
    //dodawanie do tabeli 'restauracje'
    //============================
    func addRestauracje(reid: String, nazwa: String, obiekt: String, adres: String, mia_id: String, miasto: String, woj_id: String, woj: String, dos: String, opak: String, do_st: String, rez: String, moge: String) -> Int64? {
        do {
            let insert = restauracje.insert(re_id <- reid, re_nazwa <- nazwa, re_obiekt <- obiekt, re_adres <- adres, re_mia_id <- mia_id,  re_miasto <- miasto,  re_woj_id <- woj_id, re_woj <- woj, re_dostawy <- dos, re_opakowanie <- opak, re_do_stolika <- do_st, re_rezerwacje <- rez, re_moge_jesc <- moge)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert 'restauracje' failed")
            return -1
        }
    }
    
    //===========================
    //pobieranie danych restauracji o określonej nazwie z tabeli 'restauracje'
    //===========================
    func getRestaurant(res: String) -> [Restaurantdb] {
        var resta = [Restaurantdb]()
        
        do {
            for re in try db!.prepare(self.restauracje.where(re_nazwa == res)) {
                resta.append(Restaurantdb(
                    id: re[re_tid],
                    reid: re[re_id],
                    nazwa: re[re_nazwa],
                    obiekt: re[re_obiekt],
                    adres: re[re_adres],
                    mia_id: re[re_mia_id],
                    miasto: re[re_miasto],
                    woj_id: re[re_woj_id],
                    woj: re[re_woj],
                    dos: re[re_dostawy],
                    opak: re[re_opakowanie],
                    do_st: re[re_do_stolika],
                    rez: re[re_rezerwacje],
                    moge: re[re_moge_jesc]
                    )!)
            }
        } catch {
            print("Select restaurant failed")
        }
        return resta
    }
    
    //===========================
    //pobieranie danych restauracji o określonym id z tabeli 'restauracje' ( w QRLocationVC)
    //===========================
    func getRestaurantWithId(res: String) -> [Restaurantdb] {
        var resta = [Restaurantdb]()
        
        do {
            for re in try db!.prepare(self.restauracje.where(re_id == res)) {
                resta.append(Restaurantdb(
                    id: re[re_tid],
                    reid: re[re_id],
                    nazwa: re[re_nazwa],
                    obiekt: re[re_obiekt],
                    adres: re[re_adres],
                    mia_id: re[re_mia_id],
                    miasto: re[re_miasto],
                    woj_id: re[re_woj_id],
                    woj: re[re_woj],
                    dos: re[re_dostawy],
                    opak: re[re_opakowanie],
                    do_st: re[re_do_stolika],
                    rez: re[re_rezerwacje],
                    moge: re[re_moge_jesc]
                    )!)
            }
        } catch {
            print("Select restaurant failed")
        }
        return resta
    }
    
    //*********************************
    //czy jest w tabeli 'restauracje' restauracja o podanym re_id - użyte w "MenuViewController", "LoginViewController" (działa prawidłowo jeżeli restauracje zdążą sie pobrać przez internet)
    //*********************************
    func czyRestauracja(rest: String) -> Int{
        //print("rest-")
        //print(rest)
        var resta = "0"
        var czy = 0
        do {
            for re in try db!.prepare(self.restauracje.where(re_id == rest)) {
                resta = re[re_id]
            }
        } catch {
            print("czyRestauracja - failed")
        }
        
        if rest == resta { czy = 1 }   //jeżeli jest restauracja to czy=1
        
        return czy
        
        /*            "scalar" z "count" NIE DZIAŁA !!!!!!
        let czy = 0
        do {
            let czy = try db!.scalar(restauracje.filter(re_id == rest).count) //ilość rekordów
            print("czy_rest=")
            print(czy)
            return czy
        } catch {
            print("czyRestauracja - failed")
        }
 */
        
    }
    
    //*********************************
    //czy jest w tabeli 'restauracje' miasto o podanym mia_id - użyte w "MenuViewController"
    //*********************************
    func czyMiasto(miaid: String) -> Int{
        print("miaid-")
        print(miaid)
        var miasto = "0"
        var czy = 0
        do {
            for mia in try db!.prepare(self.restauracje.where(re_mia_id == miaid)) {
                miasto = mia[re_mia_id]
            }
        } catch {
            print("czyRestauracja - failed")
        }
        
        if miaid == miasto { czy = 1 }   //jeżeli jest miasto to czy=1
        
        return czy
        
/*        //print("rest-")
        //print(rest)
        do {
            let czy = try db!.scalar(restauracje.filter(re_mia_id == miaid).count) //ilość rekordów
            print("czy miasto=")
            print(czy)
            return czy
        } catch {
            print("Czy miasto -  failed")
        }
        return 0
 */   }
    
    //===========================
    //pobranie danych restauracji z tabeli 'restauracje' dla wybranej lokalizacji
    //pobranie danych dowolnej restauracji (1 rekord) z tabeli 'restauracje' (kiedy wybrano restauracje 'Wszystkie') dla określenia miasta i woj w LocationVC.swift
    //===========================
    func getMiasto(mia: String) -> [Restaurantdb] {
        var resta = [Restaurantdb]()
        
        do {
            for re in try db!.prepare(self.restauracje.where(re_miasto == mia).limit(1)) {
                resta.append(Restaurantdb(
                    id: re[re_tid],
                    reid: re[re_id],
                    nazwa: re[re_nazwa],
                    obiekt: re[re_obiekt],
                    adres: re[re_adres],
                    mia_id: re[re_mia_id],
                    miasto: re[re_miasto],
                    woj_id: re[re_woj_id],
                    woj: re[re_woj],
                    dos: re[re_dostawy],
                    opak: re[re_opakowanie],
                    do_st: re[re_do_stolika],
                    rez: re[re_rezerwacje],
                    moge: re[re_moge_jesc]
                    )!)
            }
        } catch {
            print("Select restaurant failed")
        }
        return resta
    }
    
/*  //===========================
    //pobieranie z tabeli 'restauracje'
    //===========================
    func getRestInCity(miaid: String) -> [RestInCitydb] {
        var resta = [RestInCitydb]()
        
        do {
            for re in try db!.prepare(self.restauracje.where(re_mia_id == miaid)) {
                resta.append(RestInCitydb(
                    id: re[re_tid],
                    reid: re[re_id],
                    nazwa: re[re_nazwa])!)
            }
        } catch {
            print("Select restaurant failed")
        }
        return resta
    }
  */
    //===========================
    //pobieranie nazw województw z tabeli 'restauracje' - użyte w LocationVC
    //===========================
    func getDistrict() -> [String] {
        var districts = [String]()

        do {
            //for wojtwa in try db!.prepare(self.restauracje.select(distinct:re_woj).where(re_woj_id != "0")) {
            
            for wojtwa in try db!.prepare(self.restauracje.select(distinct:re_woj)) {
                districts.append(wojtwa[re_woj])
            }
        } catch {
            print("Select districts failed")
        }
        return districts
    }
    
    //===========================
    //pobieranie nazw miast w województwie z tabeli 'restauracje'- użyte w LocationVC
    //===========================
    func getCity(wojid: String) -> [String] {
        var citys = [String]()
        
        do {
            for miasta in try db!.prepare(self.restauracje.select(distinct:re_miasto).where(re_woj == wojid)) {
       
                citys.append(miasta[re_miasto])
            }
        } catch {
            print("Select citys failed")
        }
        return citys
    }
    
    //===========================
    //pobieranie nazw restauracji w mieście z tabeli 'restauracje' - użyte w LocationVC
    //===========================
    func getRestaurants(miaid: String) -> [String] {
        var restaurants = [String]()
        
        do {
            restaurants.append("00")
            for resta in try db!.prepare(self.restauracje.where(re_miasto == miaid)) {
                
                restaurants.append(resta[re_nazwa])
            }
        } catch {
            print("Select restaurants failed")
        }
        return restaurants
    }
    
    //***********************************
    //usunięcie danych z tabeli 'restauracja' - dla "Zaktualizuj dane"
    //***********************************
    func deleteRestauracjeAll() -> Bool{
        do {
            try db!.run(restauracje.delete())
            return true
        } catch {
            print("Delete all data in table 'restauracje' failed")
        }
        return false
    }
    
    //*********************************
    //usunięcie tabeli 'restauracje'
    //*********************************
    func dropRestauracje() -> Bool{
        do {
            try db!.run(restauracje.drop())
            return true
        } catch {
            print("Drop table 'restauracje' failed")
        }
        return false
    }
    
    //== DANIA ==========================================================================
    //============================================
    //tworzenie tabeli 'dania' jeżeli jej nie ma
    //============================================
    func createTableDania() {
        do {
            try db!.run(dania.create(ifNotExists: true) { table in
                table.column(da_tid, primaryKey: true)
                table.column(da_id)
                table.column(da_nazwa)
                table.column(da_opis)
                table.column(da_id_wer)
                table.column(da_wersja)
                table.column(da_foto)
                table.column(da_gdzie)
                table.column(da_kategoria)
                table.column(da_podkat)
                table.column(da_srednia)
                table.column(da_alergeny)
                table.column(da_cena) //, unique: true
                table.column(da_czas)
                table.column(da_waga)
                table.column(da_kcal)
                table.column(da_lubi)
                table.column(da_fav)
            })
        } catch {
            print("Unable to create table 'dania'")
        }
    }
    
    //============================
    //dodawanie do tabeli 'dania'
    //============================
    func addDania(daid: String, nazwa: String, opis: String, idwer: String, wersja: String, foto: String, gdzie: String, kategoria: String, podkat: String, srednia: String, alergeny: String, cena: String, czas: String, waga: String, kcal: String, lubi: String, fav: String ) -> Int64? {
        do {
            let insert = dania.insert(da_id <- daid, da_nazwa <- nazwa, da_opis <- opis, da_id_wer <- idwer, da_wersja <- wersja, da_foto <- foto, da_gdzie <- gdzie, da_kategoria <- kategoria, da_podkat <- podkat,  da_srednia <- srednia,  da_alergeny <- alergeny, da_cena <- cena, da_czas <- czas, da_waga <- waga, da_kcal <- kcal, da_lubi <- lubi, da_fav <- fav)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert 'dania' failed")
            return -1
        }
    }
    
    //============================
    //update polubienia fav w tabeli 'dania' (dla jednego dania)
    //============================
    func updateFavDania(daid: String, fav: String){
        do{
            try db!.run(dania.filter(da_id == daid).update(da_fav <- fav))
        }catch {
            print("Update 'dania' failed")
        }
    }
    
    //===========================
    //pobieranie dań określonej kategorii z tabeli 'dania' (nie pobiera wersji tego samego dania)
    //===========================
    func getDania(kat: String) -> [Mealdb] {
        var dania = [Mealdb]()

        do {
            for danie in try db!.prepare(self.dania.where((da_kategoria == kat)&&(da_id_wer == "0"))) {
                dania.append(Mealdb(
                    id: danie[da_tid],
                    daid: danie[da_id],
                    nazwa: danie[da_nazwa],
                    opis: danie[da_opis],
                    idwer: danie[da_id_wer],
                    wersja: danie[da_wersja],
                    foto: danie[da_foto],
                    gdzie: danie[da_gdzie],
                    kategoria: danie[da_kategoria],
                    podkat: danie[da_podkat],
                    srednia: danie[da_srednia],
                    alergeny: danie[da_alergeny],
                    cena: danie[da_cena],
                    czas: danie[da_czas],
                    waga: danie[da_waga],
                    kcal: danie[da_kcal],
                    lubi: danie[da_lubi],
                    fav: danie[da_fav])!)
            }
        } catch {
            print("Select failed")
        }
        return dania
    }
    
    //===========================
    //pobieranie dania o określonym id z tabeli 'dania'
    //===========================
    func getDanie(id: String) -> [Mealdb] {
        var dania = [Mealdb]()
        
        do {
            for danie in try db!.prepare(self.dania.where(da_id == id)) {
                dania.append(Mealdb(
                    id: danie[da_tid],
                    daid: danie[da_id],
                    nazwa: danie[da_nazwa],
                    opis: danie[da_opis],
                    idwer: danie[da_id_wer],
                    wersja: danie[da_wersja],
                    foto: danie[da_foto],
                    gdzie: danie[da_gdzie],
                    kategoria: danie[da_kategoria],
                    podkat: danie[da_podkat],
                    srednia: danie[da_srednia],
                    alergeny: danie[da_alergeny],
                    cena: danie[da_cena],
                    czas: danie[da_czas],
                    waga: danie[da_waga],
                    kcal: danie[da_kcal],
                    lubi: danie[da_lubi],
                    fav: danie[da_fav])!)
            }
        } catch {
            print("Select failed")
        }
        return dania
    }
    
    //===========================
    //pobieranie dań ulubionych z tabeli 'dania'
    //===========================
    func getDaniaFav() -> [Mealdb] {
        var dania = [Mealdb]()
        
        do {
            for danie in try db!.prepare(self.dania.where(da_fav == "1")) {
                dania.append(Mealdb(
                    id: danie[da_tid],
                    daid: danie[da_id],
                    nazwa: danie[da_nazwa],
                    opis: danie[da_opis],
                    idwer: danie[da_id_wer],
                    wersja: danie[da_wersja],
                    foto: danie[da_foto],
                    gdzie: danie[da_gdzie],
                    kategoria: danie[da_kategoria],
                    podkat: danie[da_podkat],
                    srednia: danie[da_srednia],
                    alergeny: danie[da_alergeny],
                    cena: danie[da_cena],
                    czas: danie[da_czas],
                    waga: danie[da_waga],
                    kcal: danie[da_kcal],
                    lubi: danie[da_lubi],
                    fav: danie[da_fav])!)
            }
        } catch {
            print("Select failed")
        }
        return dania
    }
    
    //===========================
    //pobieranie dań określonej kategorii i podkategorii z tabeli 'dania' (nie pobiera wersji tego samego dania)
    //===========================
    func getDaniaPodkat(kat: String, pod: String) -> [Mealdb] {
        var dania = [Mealdb]()
        
        do {
            for danie in try db!.prepare(self.dania.where((da_kategoria == kat)&&(da_id_wer == "0")).filter(da_podkat.like(pod))) {
                dania.append(Mealdb(
                    id: danie[da_tid],
                    daid: danie[da_id],
                    nazwa: danie[da_nazwa],
                    opis: danie[da_opis],
                    idwer: danie[da_id_wer],
                    wersja: danie[da_wersja],
                    foto: danie[da_foto],
                    gdzie: danie[da_gdzie],
                    kategoria: danie[da_kategoria],
                    podkat: danie[da_podkat],
                    srednia: danie[da_srednia],
                    alergeny: danie[da_alergeny],
                    cena: danie[da_cena],
                    czas: danie[da_czas],
                    waga: danie[da_waga],
                    kcal: danie[da_kcal],
                    lubi: danie[da_lubi],
                    fav: danie[da_fav])!)
            }
        } catch {
            print("Select failed podkategorie")
        }
        return dania
    }
    
    //===========================
    //pobieranie wszystkich dań z tabeli 'dania' - dla wyszukiwarki - bez wersji tego samego dania
    //===========================
    func getDaniaAll() -> [Mealdb] {
        var dania = [Mealdb]()
        
        do {
            for danie in try db!.prepare(self.dania.where(da_id_wer == "0")) {
                dania.append(Mealdb(
                    id: danie[da_tid],
                    daid: danie[da_id],
                    nazwa: danie[da_nazwa],
                    opis: danie[da_opis],
                    idwer: danie[da_id_wer],
                    wersja: danie[da_wersja],
                    foto: danie[da_foto],
                    gdzie: danie[da_gdzie],
                    kategoria: danie[da_kategoria],
                    podkat: danie[da_podkat],
                    srednia: danie[da_srednia],
                    alergeny: danie[da_alergeny],
                    cena: danie[da_cena],
                    czas: danie[da_czas],
                    waga: danie[da_waga],
                    kcal: danie[da_kcal],
                    lubi: danie[da_lubi],
                    fav: danie[da_fav])!)
            }
        } catch {
            print("Select all meal failed")
        }
        return dania
    }
    
    //***********************************
    //usunięcie danych z tabeli 'dania'
    //***********************************
    func deleteDaniaAll() -> Bool{
        do {
            try db!.run(dania.delete())
            return true
        } catch {
            print("Delete all data in table 'dania' failed")
        }
        return false
    }
    
    //*********************************
    //usunięcie tabeli 'dania'
    //*********************************
    func dropDania() -> Bool{
        do {
            try db!.run(dania.drop())
            return true
        } catch {
            print("Drop table 'dania' failed")
        }
        return false
    }
    
    //*********************************
    //ilość dań w tabeli 'dania' - użyte w AppDelegate do sprawdzenia czy są jakieś dana w tabeli dania
    //*********************************
    func czyDania() -> Int{
        let czy = 0
        do {
            let czy = try db!.scalar(dania.count)
            return czy
        } catch {
            print("czyDania table 'dania' failed")
        }
        return czy
    }
}

