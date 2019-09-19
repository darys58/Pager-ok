//
//  ProfilViewController.swift
//  Pager
//
//  Created by darys on 28.06.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import UIKit
import DLRadioButton
import Localize_Swift

class ProfilViewController: UIViewController, BEMCheckBoxDelegate {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    
    var zboza_opis = UILabel()
    var skorupiaki_opis = UILabel()
    var jaja_opis = UILabel()
    var ryby_opis = UILabel()
    var ziemne_opis = UILabel()
    var soja_opis = UILabel()
    var mleko_opis = UILabel()
    var orzechy_opis = UILabel()
    var seler_opis = UILabel()
    var gorczyca_opis = UILabel()
    var sezam_opis = UILabel()
    var siarczany_opis = UILabel()
    var lubin_opis = UILabel()
    var mieczaki_opis = UILabel()
    let box = BEMCheckBox()
    var activityIndicator = UIActivityIndicatorView()
    var location: [Memorydb]? = []        //lokalizacja zapamiętana w bazie lokalnej
    var siec: Network?
    var reachability: Reachability?  //dostępność Internetu
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titlelabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titlelabel1
        titlelabel1.textAlignment = .center
        titlelabel1.text = "L_PROFIL".localized()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "L_ZAPISZ".localized(), style: .plain, target: self, action: #selector(zapisTapped))

        emailLabel.text = "L_EMAIL".localized()
        emailField.text = Shared.shared.user[0].uz_email
        
        //checkbox student
        //let box = BEMCheckBox(frame: CGRect(x: 40, y: 100, width: 20, height: 20))
        box.frame = CGRect(x: 40, y: 100, width: 20, height: 20)
        box.minimumTouchSize = CGSize(width: 600, height: 20)
        box.boxType = BEMBoxType.square
        box.animationDuration = 0.5
        box.onAnimationType = BEMAnimationType.fill
        box.offAnimationType = BEMAnimationType.fill
        box.onFillColor = UIColor.red
        box.onTintColor = UIColor.red
        box.onCheckColor = UIColor.white
        box.tag = 1 //tag = 1 oznacza checkbox student
        box.delegate = self
        if Shared.shared.user[0].uz_student == "1" {box.on = true}
        self.myScrollView.addSubview(box)
        //label student
        let text = UILabel(frame: CGRect(x: 70, y: 95, width: 350, height: 30))
        text.font = UIFont(name: "Arial", size: 14)
        text.textColor = UIColor.gray
        text.text = "L_STUDENT".localized()
        self.myScrollView.addSubview(text)
        
        //przepisanie danych z sieci do pamięci tymczasowej
        Shared.shared.alergik_temp[0] = Shared.shared.user[0].au_zboza
        Shared.shared.alergik_temp[1] = Shared.shared.user[0].au_skorupiaki
        Shared.shared.alergik_temp[2] = Shared.shared.user[0].au_jaja
        Shared.shared.alergik_temp[3] = Shared.shared.user[0].au_ryby
        Shared.shared.alergik_temp[4] = Shared.shared.user[0].au_o_ziemne
        Shared.shared.alergik_temp[5] = Shared.shared.user[0].au_soja
        Shared.shared.alergik_temp[6] = Shared.shared.user[0].au_mleko
        Shared.shared.alergik_temp[7] = Shared.shared.user[0].au_orzechy
        Shared.shared.alergik_temp[8] = Shared.shared.user[0].au_seler
        Shared.shared.alergik_temp[9] = Shared.shared.user[0].au_gorczyca
        Shared.shared.alergik_temp[10] = Shared.shared.user[0].au_sezam
        Shared.shared.alergik_temp[11] = Shared.shared.user[0].au_siarczany
        Shared.shared.alergik_temp[12] = Shared.shared.user[0].au_lubin
        Shared.shared.alergik_temp[13] = Shared.shared.user[0].au_mieczaki
        
        
        let linia = UIView(frame: CGRect(x: 16, y: 140, width: Int(self.view.frame.size.width - 32), height: 1))
        linia.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia)

        //Reakcja na alergeny
        let reakcja = UILabel(frame: CGRect(x: 20, y: 145, width: Int(self.view.frame.size.width - 40), height: 30))
        reakcja.text = "L_REAKCJA_ALERGENY".localized()
        reakcja.textColor = UIColor.darkGray
        reakcja.font = UIFont.systemFont(ofSize: 16)
        reakcja.textAlignment = .center
        self.myScrollView.addSubview(reakcja)
        
        let linia1 = UIView(frame: CGRect(x: 16, y: 180, width: Int(self.view.frame.size.width - 32), height: 1))
        linia1.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia1)
        
        //=================== zboża (0) =============================
        //radiobatony
        let firstRadioButton01 = createRadioButton0(frame: CGRect(x: view.frame.size.width - 120, y: 190, width: 25, height: 25), index: 0)
        //other buttons
        var otherButtons01 : [DLRadioButton] = [];
        let radioButton01 = createRadioButton0(frame: CGRect(x: view.frame.size.width - 80, y: 190, width: 25, height: 25), index: 1);
            otherButtons01.append(radioButton01);
        let radioButton02 = createRadioButton0(frame: CGRect(x: view.frame.size.width - 40, y: 190, width: 25, height: 25), index: 2);
        otherButtons01.append(radioButton02);

        firstRadioButton01.otherButtons = otherButtons01;
        
        //ikona alergenu - zboża
        let icon_zboze: UIImageView!
        icon_zboze = UIImageView(frame: CGRect(x: 16, y: 190, width: 40, height: 40))
        icon_zboze.contentMode = .scaleAspectFill
        icon_zboze.image = UIImage(named: "cereals.png")
        self.myScrollView.addSubview(icon_zboze)
        
        //Zboża label
        let zboza = UILabel(frame: CGRect(x: 70, y: 190, width: Int(self.view.frame.size.width - 150), height: 30))
        zboza.text = "L_ZBOZA".localized()
        zboza.textColor = UIColor.darkGray
        zboza.font = UIFont.boldSystemFont(ofSize: 16)
        zboza.textAlignment = .left
        self.myScrollView.addSubview(zboza)
        
        //Zboża - reakcja label
        zboza_opis.frame = CGRect(x: 70, y: 210, width: Int(self.view.frame.size.width - 50), height: 30)
        zboza_opis.textColor = UIColor.darkGray
        zboza_opis.font = UIFont.systemFont(ofSize: 12)
        zboza_opis.textAlignment = .left
        self.myScrollView.addSubview(zboza_opis)
        
        let linia01 = UIView(frame: CGRect(x: 16, y: 240, width: Int(self.view.frame.size.width - 32), height: 1))
        linia01.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia01)
        
        //=================== skorupiaki (1) =============================
        //radiobatony
        let firstRadioButton11 = createRadioButton1(frame: CGRect(x: view.frame.size.width - 120, y: 250, width: 25, height: 25), index: 10)
        //other buttons
        var otherButtons11 : [DLRadioButton] = [];
        let radioButton11 = createRadioButton1(frame: CGRect(x: view.frame.size.width - 80, y: 250, width: 25, height: 25), index: 11);
        otherButtons11.append(radioButton11);
        let radioButton12 = createRadioButton1(frame: CGRect(x: view.frame.size.width - 40, y: 250, width: 25, height: 25), index: 12);
        otherButtons11.append(radioButton12);
        
        firstRadioButton11.otherButtons = otherButtons11;
        
        //ikona alergenu - skorupiaki
        let icon_skorupiaki: UIImageView!
        icon_skorupiaki = UIImageView(frame: CGRect(x: 16, y: 250, width: 40, height: 40))
        icon_skorupiaki.contentMode = .scaleAspectFill
        icon_skorupiaki.image = UIImage(named: "shellfish.png")
        self.myScrollView.addSubview(icon_skorupiaki)
        
        //skorupiaki label
        let skorupiaki = UILabel(frame: CGRect(x: 70, y: 250, width: Int(self.view.frame.size.width - 150), height: 30))
        skorupiaki.text = "L_SKORUPIAKI".localized()
        skorupiaki.textColor = UIColor.darkGray
        skorupiaki.font = UIFont.boldSystemFont(ofSize: 16)
        skorupiaki.textAlignment = .left
        self.myScrollView.addSubview(skorupiaki)
        
        //skorupiaki - reakcja label
        skorupiaki_opis.frame = CGRect(x: 70, y: 270, width: Int(self.view.frame.size.width - 50), height: 30)
        skorupiaki_opis.textColor = UIColor.darkGray
        skorupiaki_opis.font = UIFont.systemFont(ofSize: 12)
        skorupiaki_opis.textAlignment = .left
        self.myScrollView.addSubview(skorupiaki_opis)
        
        let linia11 = UIView(frame: CGRect(x: 16, y: 300, width: Int(self.view.frame.size.width - 32), height: 1))
        linia11.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia11)
        
        //=================== jaja (2) =============================
        //radiobatony
        let firstRadioButton21 = createRadioButton2(frame: CGRect(x: view.frame.size.width - 120, y: 310, width: 25, height: 25), index: 20)
        //other buttons
        var otherButtons21 : [DLRadioButton] = [];
        let radioButton21 = createRadioButton2(frame: CGRect(x: view.frame.size.width - 80, y: 310, width: 25, height: 25), index: 21);
        otherButtons21.append(radioButton21);
        let radioButton22 = createRadioButton2(frame: CGRect(x: view.frame.size.width - 40, y: 310, width: 25, height: 25), index: 22);
        otherButtons21.append(radioButton22);
        
        firstRadioButton21.otherButtons = otherButtons21;
        
        //ikona alergenu - jaja
        let icon_jaja: UIImageView!
        icon_jaja = UIImageView(frame: CGRect(x: 16, y: 310, width: 40, height: 40))
        icon_jaja.contentMode = .scaleAspectFill
        icon_jaja.image = UIImage(named: "eggs.png")
        self.myScrollView.addSubview(icon_jaja)
        
        //jaja label
        let jaja = UILabel(frame: CGRect(x: 70, y: 310, width: Int(self.view.frame.size.width - 150), height: 30))
        jaja.text = "L_JAJA".localized()
        jaja.textColor = UIColor.darkGray
        jaja.font = UIFont.boldSystemFont(ofSize: 16)
        jaja.textAlignment = .left
        self.myScrollView.addSubview(jaja)
        
        //jaja - reakcja label
        jaja_opis.frame = CGRect(x: 70, y: 330, width: Int(self.view.frame.size.width - 50), height: 30)
        jaja_opis.textColor = UIColor.darkGray
        jaja_opis.font = UIFont.systemFont(ofSize: 12)
        jaja_opis.textAlignment = .left
        self.myScrollView.addSubview(jaja_opis)
        
        let linia21 = UIView(frame: CGRect(x: 16, y: 360, width: Int(self.view.frame.size.width - 32), height: 1))
        linia21.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia21)
        
        //=================== ryby (3) =============================
        //radiobatony
        let firstRadioButton31 = createRadioButton3(frame: CGRect(x: view.frame.size.width - 120, y: 370, width: 25, height: 25), index: 30)
        //other buttons
        var otherButtons31 : [DLRadioButton] = [];
        let radioButton31 = createRadioButton3(frame: CGRect(x: view.frame.size.width - 80, y: 370, width: 25, height: 25), index: 31);
        otherButtons31.append(radioButton31);
        let radioButton32 = createRadioButton3(frame: CGRect(x: view.frame.size.width - 40, y: 370, width: 25, height: 25), index: 32);
        otherButtons31.append(radioButton32);
        
        firstRadioButton31.otherButtons = otherButtons31;
        
        //ikona alergenu - ryby
        let icon_ryby: UIImageView!
        icon_ryby = UIImageView(frame: CGRect(x: 16, y: 370, width: 40, height: 40))
        icon_ryby.contentMode = .scaleAspectFill
        icon_ryby.image = UIImage(named: "fish.png")
        self.myScrollView.addSubview(icon_ryby)
        
        //ryby label
        let ryby = UILabel(frame: CGRect(x: 70, y: 370, width: Int(self.view.frame.size.width - 150), height: 30))
        ryby.text = "L_RYBY".localized()
        ryby.textColor = UIColor.darkGray
        ryby.font = UIFont.boldSystemFont(ofSize: 16)
        ryby.textAlignment = .left
        self.myScrollView.addSubview(ryby)
        
        //ryby - reakcja label
        ryby_opis.frame = CGRect(x: 70, y: 390, width: Int(self.view.frame.size.width - 50), height: 30)
        ryby_opis.textColor = UIColor.darkGray
        ryby_opis.font = UIFont.systemFont(ofSize: 12)
        ryby_opis.textAlignment = .left
        self.myScrollView.addSubview(ryby_opis)
        
        let linia31 = UIView(frame: CGRect(x: 16, y: 420, width: Int(self.view.frame.size.width - 32), height: 1))
        linia31.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia31)
        
        //=================== o_ziemne (4) =============================
        //radiobatony
        let firstRadioButton41 = createRadioButton4(frame: CGRect(x: view.frame.size.width - 120, y: 430, width: 25, height: 25), index: 40)
        //other buttons
        var otherButtons41 : [DLRadioButton] = [];
        let radioButton41 = createRadioButton4(frame: CGRect(x: view.frame.size.width - 80, y: 430, width: 25, height: 25), index: 41);
        otherButtons41.append(radioButton41);
        let radioButton42 = createRadioButton4(frame: CGRect(x: view.frame.size.width - 40, y: 430, width: 25, height: 25), index: 42);
        otherButtons41.append(radioButton42);
        
        firstRadioButton41.otherButtons = otherButtons41;
        
        //ikona alergenu - o_ziemne
        let icon_ziemne: UIImageView!
        icon_ziemne = UIImageView(frame: CGRect(x: 16, y: 430, width: 40, height: 40))
        icon_ziemne.contentMode = .scaleAspectFill
        icon_ziemne.image = UIImage(named: "peanuts.png")
        self.myScrollView.addSubview(icon_ziemne)
        
        //o_ziemne label
        let ziemne = UILabel(frame: CGRect(x: 70, y: 430, width: Int(self.view.frame.size.width - 150), height: 30))
        ziemne.text = "L_ZIEMNE".localized()
        ziemne.textColor = UIColor.darkGray
        ziemne.font = UIFont.boldSystemFont(ofSize: 16)
        ziemne.textAlignment = .left
        self.myScrollView.addSubview(ziemne)
        
        //o_ziemne - reakcja label
        ziemne_opis.frame = CGRect(x: 70, y: 450, width: Int(self.view.frame.size.width - 50), height: 30)
        ziemne_opis.textColor = UIColor.darkGray
        ziemne_opis.font = UIFont.systemFont(ofSize: 12)
        ziemne_opis.textAlignment = .left
        self.myScrollView.addSubview(ziemne_opis)
        
        let linia41 = UIView(frame: CGRect(x: 16, y: 480, width: Int(self.view.frame.size.width - 32), height: 1))
        linia41.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia41)
        
        //=================== soja (5) =============================
        //radiobatony
        let firstRadioButton51 = createRadioButton5(frame: CGRect(x: view.frame.size.width - 120, y: 490, width: 25, height: 25), index: 50)
        //other buttons
        var otherButtons51 : [DLRadioButton] = [];
        let radioButton51 = createRadioButton5(frame: CGRect(x: view.frame.size.width - 80, y: 490, width: 25, height: 25), index: 51);
        otherButtons51.append(radioButton51);
        let radioButton52 = createRadioButton5(frame: CGRect(x: view.frame.size.width - 40, y: 490, width: 25, height: 25), index: 52);
        otherButtons51.append(radioButton52);
        
        firstRadioButton51.otherButtons = otherButtons51;
        
        //ikona alergenu - soja
        let icon_soja: UIImageView!
        icon_soja = UIImageView(frame: CGRect(x: 16, y: 490, width: 40, height: 40))
        icon_soja.contentMode = .scaleAspectFill
        icon_soja.image = UIImage(named: "soy.png")
        self.myScrollView.addSubview(icon_soja)
        
        //soja label
        let soja = UILabel(frame: CGRect(x: 70, y: 490, width: Int(self.view.frame.size.width - 150), height: 30))
        soja.text = "L_SOJA".localized()
        soja.textColor = UIColor.darkGray
        soja.font = UIFont.boldSystemFont(ofSize: 16)
        soja.textAlignment = .left
        self.myScrollView.addSubview(soja)
        
        //soja - reakcja label
        soja_opis.frame = CGRect(x: 70, y: 510, width: Int(self.view.frame.size.width - 50), height: 30)
        soja_opis.textColor = UIColor.darkGray
        soja_opis.font = UIFont.systemFont(ofSize: 12)
        soja_opis.textAlignment = .left
        self.myScrollView.addSubview(soja_opis)
        
        let linia51 = UIView(frame: CGRect(x: 16, y: 540, width: Int(self.view.frame.size.width - 32), height: 1))
        linia51.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia51)
        
        //=================== mleko (6) =============================
        //radiobatony
        let firstRadioButton61 = createRadioButton6(frame: CGRect(x: view.frame.size.width - 120, y: 550, width: 25, height: 25), index: 60)
        //other buttons
        var otherButtons61 : [DLRadioButton] = [];
        let radioButton61 = createRadioButton6(frame: CGRect(x: view.frame.size.width - 80, y: 550, width: 25, height: 25), index: 61);
        otherButtons61.append(radioButton61);
        let radioButton62 = createRadioButton6(frame: CGRect(x: view.frame.size.width - 40, y: 550, width: 25, height: 25), index: 62);
        otherButtons61.append(radioButton62);
        
        firstRadioButton61.otherButtons = otherButtons61;
        
        //ikona alergenu - mleko
        let icon_mleko: UIImageView!
        icon_mleko = UIImageView(frame: CGRect(x: 16, y: 550, width: 40, height: 40))
        icon_mleko.contentMode = .scaleAspectFill
        icon_mleko.image = UIImage(named: "milk.png")
        self.myScrollView.addSubview(icon_mleko)
        
        //mleko label
        let mleko = UILabel(frame: CGRect(x: 70, y: 550, width: Int(self.view.frame.size.width - 150), height: 30))
        mleko.text = "L_MLEKO".localized()
        mleko.textColor = UIColor.darkGray
        mleko.font = UIFont.boldSystemFont(ofSize: 16)
        mleko.textAlignment = .left
        self.myScrollView.addSubview(mleko)
        
        //soja - reakcja label
        mleko_opis.frame = CGRect(x: 70, y: 570, width: Int(self.view.frame.size.width - 50), height: 30)
        mleko_opis.textColor = UIColor.darkGray
        mleko_opis.font = UIFont.systemFont(ofSize: 12)
        mleko_opis.textAlignment = .left
        self.myScrollView.addSubview(mleko_opis)
        
        let linia61 = UIView(frame: CGRect(x: 16, y: 600, width: Int(self.view.frame.size.width - 32), height: 1))
        linia61.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia61)
        
        //=================== orzechy (7) =============================
        //radiobatony
        let firstRadioButton71 = createRadioButton7(frame: CGRect(x: view.frame.size.width - 120, y: 610, width: 25, height: 25), index: 70)
        //other buttons
        var otherButtons71 : [DLRadioButton] = [];
        let radioButton71 = createRadioButton7(frame: CGRect(x: view.frame.size.width - 80, y: 610, width: 25, height: 25), index: 71);
        otherButtons71.append(radioButton71);
        let radioButton72 = createRadioButton7(frame: CGRect(x: view.frame.size.width - 40, y: 610, width: 25, height: 25), index: 72);
        otherButtons71.append(radioButton72);
        
        firstRadioButton71.otherButtons = otherButtons71;
        
        //ikona alergenu - orzechy
        let icon_orzechy: UIImageView!
        icon_orzechy = UIImageView(frame: CGRect(x: 16, y: 610, width: 40, height: 40))
        icon_orzechy.contentMode = .scaleAspectFill
        icon_orzechy.image = UIImage(named: "nuts.png")
        self.myScrollView.addSubview(icon_orzechy)
        
        //orzechy label
        let orzechy = UILabel(frame: CGRect(x: 70, y: 610, width: Int(self.view.frame.size.width - 150), height: 30))
        orzechy.text = "L_ORZECHY".localized()
        orzechy.textColor = UIColor.darkGray
        orzechy.font = UIFont.boldSystemFont(ofSize: 16)
        orzechy.textAlignment = .left
        self.myScrollView.addSubview(orzechy)
        
        //orzechy - reakcja label
        orzechy_opis.frame = CGRect(x: 70, y: 630, width: Int(self.view.frame.size.width - 50), height: 30)
        orzechy_opis.textColor = UIColor.darkGray
        orzechy_opis.font = UIFont.systemFont(ofSize: 12)
        orzechy_opis.textAlignment = .left
        self.myScrollView.addSubview(orzechy_opis)
        
        let linia71 = UIView(frame: CGRect(x: 16, y: 660, width: Int(self.view.frame.size.width - 32), height: 1))
        linia71.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia71)
        
        //=================== seler (8) =============================
        //radiobatony
        let firstRadioButton81 = createRadioButton8(frame: CGRect(x: view.frame.size.width - 120, y: 670, width: 25, height: 25), index: 80)
        //other buttons
        var otherButtons81 : [DLRadioButton] = [];
        let radioButton81 = createRadioButton8(frame: CGRect(x: view.frame.size.width - 80, y: 670, width: 25, height: 25), index: 81);
        otherButtons81.append(radioButton81);
        let radioButton82 = createRadioButton8(frame: CGRect(x: view.frame.size.width - 40, y: 670, width: 25, height: 25), index: 82);
        otherButtons81.append(radioButton82);
        
        firstRadioButton81.otherButtons = otherButtons81;
        
        //ikona alergenu - seler
        let icon_seler: UIImageView!
        icon_seler = UIImageView(frame: CGRect(x: 16, y: 670, width: 40, height: 40))
        icon_seler.contentMode = .scaleAspectFill
        icon_seler.image = UIImage(named: "celery.png")
        self.myScrollView.addSubview(icon_seler)
        
        //seler label
        let seler = UILabel(frame: CGRect(x: 70, y: 670, width: Int(self.view.frame.size.width - 150), height: 30))
        seler.text = "L_SELER".localized()
        seler.textColor = UIColor.darkGray
        seler.font = UIFont.boldSystemFont(ofSize: 16)
        seler.textAlignment = .left
        self.myScrollView.addSubview(seler)
        
        //seler - reakcja label
        seler_opis.frame = CGRect(x: 70, y: 690, width: Int(self.view.frame.size.width - 50), height: 30)
        seler_opis.textColor = UIColor.darkGray
        seler_opis.font = UIFont.systemFont(ofSize: 12)
        seler_opis.textAlignment = .left
        self.myScrollView.addSubview(seler_opis)
        
        let linia81 = UIView(frame: CGRect(x: 16, y: 720, width: Int(self.view.frame.size.width - 32), height: 1))
        linia81.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia81)
        
        //=================== gorczyca (9) =============================
        //radiobatony
        let firstRadioButton91 = createRadioButton9(frame: CGRect(x: view.frame.size.width - 120, y: 730, width: 25, height: 25), index: 90)
        //other buttons
        var otherButtons91 : [DLRadioButton] = [];
        let radioButton91 = createRadioButton9(frame: CGRect(x: view.frame.size.width - 80, y: 730, width: 25, height: 25), index: 91);
        otherButtons91.append(radioButton91);
        let radioButton92 = createRadioButton9(frame: CGRect(x: view.frame.size.width - 40, y: 730, width: 25, height: 25), index: 92);
        otherButtons91.append(radioButton92);
        
        firstRadioButton91.otherButtons = otherButtons91;
        
        //ikona alergenu - gorczyca
        let icon_gorczyca: UIImageView!
        icon_gorczyca = UIImageView(frame: CGRect(x: 16, y: 730, width: 40, height: 40))
        icon_gorczyca.contentMode = .scaleAspectFill
        icon_gorczyca.image = UIImage(named: "charlock.png")
        self.myScrollView.addSubview(icon_gorczyca)
        
        //seler label
        let gorczyca = UILabel(frame: CGRect(x: 70, y: 730, width: Int(self.view.frame.size.width - 150), height: 30))
        gorczyca.text = "L_GORCZYCA".localized()
        gorczyca.textColor = UIColor.darkGray
        gorczyca.font = UIFont.boldSystemFont(ofSize: 16)
        gorczyca.textAlignment = .left
        self.myScrollView.addSubview(gorczyca)
        
        //gorczyca - reakcja label
        gorczyca_opis.frame = CGRect(x: 70, y: 750, width: Int(self.view.frame.size.width - 50), height: 30)
        gorczyca_opis.textColor = UIColor.darkGray
        gorczyca_opis.font = UIFont.systemFont(ofSize: 12)
        gorczyca_opis.textAlignment = .left
        self.myScrollView.addSubview(gorczyca_opis)
        
        let linia91 = UIView(frame: CGRect(x: 16, y: 780, width: Int(self.view.frame.size.width - 32), height: 1))
        linia91.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia91)
        
        //=================== sezam (10) =============================
        //radiobatony
        let firstRadioButton101 = createRadioButton10(frame: CGRect(x: view.frame.size.width - 120, y: 790, width: 25, height: 25), index: 100)
        //other buttons
        var otherButtons101 : [DLRadioButton] = [];
        let radioButton101 = createRadioButton10(frame: CGRect(x: view.frame.size.width - 80, y: 790, width: 25, height: 25), index: 101);
        otherButtons101.append(radioButton101);
        let radioButton102 = createRadioButton10(frame: CGRect(x: view.frame.size.width - 40, y: 790, width: 25, height: 25), index: 102);
        otherButtons101.append(radioButton102);
        
        firstRadioButton101.otherButtons = otherButtons101;
        
        //ikona alergenu - sezam
        let icon_sezam: UIImageView!
        icon_sezam = UIImageView(frame: CGRect(x: 16, y: 790, width: 40, height: 40))
        icon_sezam.contentMode = .scaleAspectFill
        icon_sezam.image = UIImage(named: "sesame.png")
        self.myScrollView.addSubview(icon_sezam)
        
        //sezam label
        let sezam = UILabel(frame: CGRect(x: 70, y: 790, width: Int(self.view.frame.size.width - 150), height: 30))
        sezam.text = "L_SEZAM".localized()
        sezam.textColor = UIColor.darkGray
        sezam.font = UIFont.boldSystemFont(ofSize: 16)
        sezam.textAlignment = .left
        self.myScrollView.addSubview(sezam)
        
        //sezam - reakcja label
        sezam_opis.frame = CGRect(x: 70, y: 810, width: Int(self.view.frame.size.width - 50), height: 30)
        sezam_opis.textColor = UIColor.darkGray
        sezam_opis.font = UIFont.systemFont(ofSize: 12)
        sezam_opis.textAlignment = .left
        self.myScrollView.addSubview(sezam_opis)
        
        let linia101 = UIView(frame: CGRect(x: 16, y: 840, width: Int(self.view.frame.size.width - 32), height: 1))
        linia101.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia101)
        
        //=================== siarczany (11) =============================
        //radiobatony
        let firstRadioButton111 = createRadioButton11(frame: CGRect(x: view.frame.size.width - 120, y: 850, width: 25, height: 25), index: 110)
        //other buttons
        var otherButtons111 : [DLRadioButton] = [];
        let radioButton111 = createRadioButton11(frame: CGRect(x: view.frame.size.width - 80, y: 850, width: 25, height: 25), index: 111);
        otherButtons111.append(radioButton111);
        let radioButton112 = createRadioButton11(frame: CGRect(x: view.frame.size.width - 40, y: 850, width: 25, height: 25), index: 112);
        otherButtons111.append(radioButton112);
        
        firstRadioButton111.otherButtons = otherButtons111;
        
        //ikona alergenu - siarczany
        let icon_siarczany: UIImageView!
        icon_siarczany = UIImageView(frame: CGRect(x: 16, y: 850, width: 40, height: 40))
        icon_siarczany.contentMode = .scaleAspectFill
        icon_siarczany.image = UIImage(named: "sulfur.png")
        self.myScrollView.addSubview(icon_siarczany)
        
        //siarczany label
        let siarczany = UILabel(frame: CGRect(x: 70, y: 850, width: Int(self.view.frame.size.width - 150), height: 30))
        siarczany.text = "L_SIARCZANY".localized()
        siarczany.textColor = UIColor.darkGray
        siarczany.font = UIFont.boldSystemFont(ofSize: 16)
        siarczany.textAlignment = .left
        self.myScrollView.addSubview(siarczany)
        
        //siarczany - reakcja label
        siarczany_opis.frame = CGRect(x: 70, y: 870, width: Int(self.view.frame.size.width - 50), height: 30)
        siarczany_opis.textColor = UIColor.darkGray
        siarczany_opis.font = UIFont.systemFont(ofSize: 12)
        siarczany_opis.textAlignment = .left
        self.myScrollView.addSubview(siarczany_opis)
        
        let linia111 = UIView(frame: CGRect(x: 16, y: 900, width: Int(self.view.frame.size.width - 32), height: 1))
        linia111.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia111)
        
        //=================== lubin (12) =============================
        //radiobatony
        let firstRadioButton121 = createRadioButton12(frame: CGRect(x: view.frame.size.width - 120, y: 910, width: 25, height: 25), index: 120)
        //other buttons
        var otherButtons121 : [DLRadioButton] = [];
        let radioButton121 = createRadioButton12(frame: CGRect(x: view.frame.size.width - 80, y: 910, width: 25, height: 25), index: 121);
        otherButtons121.append(radioButton121);
        let radioButton122 = createRadioButton12(frame: CGRect(x: view.frame.size.width - 40, y: 910, width: 25, height: 25), index: 122);
        otherButtons121.append(radioButton122);
        
        firstRadioButton121.otherButtons = otherButtons121;
        
        //ikona alergenu - lubin
        let icon_lubin: UIImageView!
        icon_lubin = UIImageView(frame: CGRect(x: 16, y: 910, width: 40, height: 40))
        icon_lubin.contentMode = .scaleAspectFill
        icon_lubin.image = UIImage(named: "lupine.png")
        self.myScrollView.addSubview(icon_lubin)
        
        //lubin label
        let lubin = UILabel(frame: CGRect(x: 70, y: 910, width: Int(self.view.frame.size.width - 150), height: 30))
        lubin.text = "L_LUBIN".localized()
        lubin.textColor = UIColor.darkGray
        lubin.font = UIFont.boldSystemFont(ofSize: 16)
        lubin.textAlignment = .left
        self.myScrollView.addSubview(lubin)
        
        //lubin - reakcja label
        lubin_opis.frame = CGRect(x: 70, y: 930, width: Int(self.view.frame.size.width - 50), height: 30)
        lubin_opis.textColor = UIColor.darkGray
        lubin_opis.font = UIFont.systemFont(ofSize: 12)
        lubin_opis.textAlignment = .left
        self.myScrollView.addSubview(lubin_opis)
        
        let linia121 = UIView(frame: CGRect(x: 16, y: 960, width: Int(self.view.frame.size.width - 32), height: 1))
        linia121.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia121)
        
        //=================== mieczaki (13) =============================
        //radiobatony
        let firstRadioButton131 = createRadioButton13(frame: CGRect(x: view.frame.size.width - 120, y: 970, width: 25, height: 25), index: 130)
        //other buttons
        var otherButtons131 : [DLRadioButton] = [];
        let radioButton131 = createRadioButton13(frame: CGRect(x: view.frame.size.width - 80, y: 970, width: 25, height: 25), index: 131);
        otherButtons131.append(radioButton131);
        let radioButton132 = createRadioButton13(frame: CGRect(x: view.frame.size.width - 40, y: 970, width: 25, height: 25), index: 132);
        otherButtons131.append(radioButton132);
        
        firstRadioButton131.otherButtons = otherButtons131;
        
        //ikona alergenu - mieczaki
        let icon_mieczaki: UIImageView!
        icon_mieczaki = UIImageView(frame: CGRect(x: 16, y: 970, width: 40, height: 40))
        icon_mieczaki.contentMode = .scaleAspectFill
        icon_mieczaki.image = UIImage(named: "molluscs.png")
        self.myScrollView.addSubview(icon_mieczaki)
        
        //mieczaki label
        let mieczaki = UILabel(frame: CGRect(x: 70, y: 970, width: Int(self.view.frame.size.width - 150), height: 30))
        mieczaki.text = "L_MIECZAKI".localized()
        mieczaki.textColor = UIColor.darkGray
        mieczaki.font = UIFont.boldSystemFont(ofSize: 16)
        mieczaki.textAlignment = .left
        self.myScrollView.addSubview(mieczaki)
        
        //mieczaki - reakcja label
        mieczaki_opis.frame = CGRect(x: 70, y: 990, width: Int(self.view.frame.size.width - 50), height: 30)
        mieczaki_opis.textColor = UIColor.darkGray
        mieczaki_opis.font = UIFont.systemFont(ofSize: 12)
        mieczaki_opis.textAlignment = .left
        self.myScrollView.addSubview(mieczaki_opis)
        
        let linia131 = UIView(frame: CGRect(x: 16, y: 1020, width: Int(self.view.frame.size.width - 32), height: 1))
        linia131.backgroundColor = UIColor.lightGray
        self.myScrollView.addSubview(linia131)
        
        
        
        //ustalenie wysokości myScrollView
        myScrollView.contentSize = CGSize(width: Int(self.view.frame.size.width), height: 1040)
    
    
        //----- wskaźnik aktywności-----------
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(activityIndicator)
        //------------------------------------
    
    }

    
    
    //-----------------------
    //tworzenie radiobatonów
    //-----------------------
    // zboza
    private func createRadioButton0(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 0: radioButton.iconColor = UIColor.lightGray
                radioButton.indicatorColor = UIColor.green
                if Shared.shared.user[0].au_zboza == "0" {radioButton.isSelected = true
                    self.zboza_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 1: radioButton.iconColor = UIColor.lightGray
                radioButton.indicatorColor = Shared.shared.mojeyellow
                if Shared.shared.user[0].au_zboza == "1" { radioButton.isSelected = true
                self.zboza_opis.text = "L_OSTRZEZENIA".localized()}
        case 2: radioButton.iconColor = UIColor.lightGray
                radioButton.indicatorColor = Shared.shared.malinaColor
                if Shared.shared.user[0].au_zboza == "2" { radioButton.isSelected = true
                self.zboza_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton0), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // skorupiaki
    private func createRadioButton1(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 10: radioButton.iconColor = UIColor.lightGray
                radioButton.indicatorColor = UIColor.green
                if Shared.shared.user[0].au_skorupiaki == "0" {radioButton.isSelected = true
                self.skorupiaki_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 11: radioButton.iconColor = UIColor.lightGray
                radioButton.indicatorColor = Shared.shared.mojeyellow
                if Shared.shared.user[0].au_skorupiaki == "1" { radioButton.isSelected = true
                self.skorupiaki_opis.text = "L_OSTRZEZENIA".localized()}
        case 12: radioButton.iconColor = UIColor.lightGray
                radioButton.indicatorColor = Shared.shared.malinaColor
                if Shared.shared.user[0].au_skorupiaki == "2" { radioButton.isSelected = true
                self.skorupiaki_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton1), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // jaja
    private func createRadioButton2(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 20: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_jaja == "0" {radioButton.isSelected = true
            self.jaja_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 21: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_jaja == "1" { radioButton.isSelected = true
            self.jaja_opis.text = "L_OSTRZEZENIA".localized()}
        case 22: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_jaja == "2" { radioButton.isSelected = true
            self.jaja_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton2), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // ryby
    private func createRadioButton3(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 30: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_ryby == "0" {radioButton.isSelected = true
            self.ryby_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 31: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_ryby == "1" { radioButton.isSelected = true
            self.ryby_opis.text = "L_OSTRZEZENIA".localized()}
        case 32: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_ryby == "2" { radioButton.isSelected = true
            self.ryby_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton3), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // o_ziemne
    private func createRadioButton4(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 40: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_o_ziemne == "0" {radioButton.isSelected = true
            self.ziemne_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 41: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_o_ziemne == "1" { radioButton.isSelected = true
            self.ziemne_opis.text = "L_OSTRZEZENIA".localized()}
        case 42: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_o_ziemne == "2" { radioButton.isSelected = true
            self.ziemne_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton4), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // soja
    private func createRadioButton5(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 50: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_soja == "0" {radioButton.isSelected = true
            self.soja_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 51: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_soja == "1" { radioButton.isSelected = true
            self.soja_opis.text = "L_OSTRZEZENIA".localized()}
        case 52: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_soja == "2" { radioButton.isSelected = true
            self.soja_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton5), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // mleko
    private func createRadioButton6(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 60: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_mleko == "0" {radioButton.isSelected = true
            self.mleko_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 61: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_mleko == "1" { radioButton.isSelected = true
            self.mleko_opis.text = "L_OSTRZEZENIA".localized()}
        case 62: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_mleko == "2" { radioButton.isSelected = true
            self.mleko_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton6), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // orzechy
    private func createRadioButton7(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 70: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_orzechy == "0" {radioButton.isSelected = true
            self.orzechy_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 71: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_orzechy == "1" { radioButton.isSelected = true
            self.orzechy_opis.text = "L_OSTRZEZENIA".localized()}
        case 72: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_orzechy == "2" { radioButton.isSelected = true
            self.orzechy_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton7), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // seler
    private func createRadioButton8(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 80: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_seler == "0" {radioButton.isSelected = true
            self.seler_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 81: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_seler == "1" { radioButton.isSelected = true
            self.seler_opis.text = "L_OSTRZEZENIA".localized()}
        case 82: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_seler == "2" { radioButton.isSelected = true
            self.seler_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton8), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // gorczyca
    private func createRadioButton9(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 90: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_gorczyca == "0" {radioButton.isSelected = true
            self.gorczyca_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 91: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_gorczyca == "1" { radioButton.isSelected = true
            self.gorczyca_opis.text = "L_OSTRZEZENIA".localized()}
        case 92: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_gorczyca == "2" { radioButton.isSelected = true
            self.gorczyca_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton9), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // sezam
    private func createRadioButton10(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 100: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_sezam == "0" {radioButton.isSelected = true
            self.sezam_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 101: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_sezam == "1" { radioButton.isSelected = true
            self.sezam_opis.text = "L_OSTRZEZENIA".localized()}
        case 102: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_sezam == "2" { radioButton.isSelected = true
            self.sezam_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton10), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // siarczany
    private func createRadioButton11(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 110: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_siarczany == "0" {radioButton.isSelected = true
            self.siarczany_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 111: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_siarczany == "1" { radioButton.isSelected = true
            self.siarczany_opis.text = "L_OSTRZEZENIA".localized()}
        case 112: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_siarczany == "2" { radioButton.isSelected = true
            self.siarczany_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton11), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // lubin
    private func createRadioButton12(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 120: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_lubin == "0" {radioButton.isSelected = true
            self.lubin_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 121: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_lubin == "1" { radioButton.isSelected = true
            self.lubin_opis.text = "L_OSTRZEZENIA".localized()}
        case 122: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_lubin == "2" { radioButton.isSelected = true
            self.lubin_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton12), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    // mieczaki
    private func createRadioButton13(frame : CGRect, index: Int) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame);
        radioButton.tag = index
        radioButton.marginWidth = 10
        radioButton.iconSize = 20
        //ustawienie kropki w zależności od zapisanych informacji o reakcjach
        switch index {
        case 130: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = UIColor.green
        if Shared.shared.user[0].au_mieczaki == "0" {radioButton.isSelected = true
            self.mieczaki_opis.text = "L_BEZ_OSTRZEZENIA".localized()}
        case 131: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.mojeyellow
        if Shared.shared.user[0].au_mieczaki == "1" { radioButton.isSelected = true
            self.mieczaki_opis.text = "L_OSTRZEZENIA".localized()}
        case 132: radioButton.iconColor = UIColor.lightGray
        radioButton.indicatorColor = Shared.shared.malinaColor
        if Shared.shared.user[0].au_mieczaki == "2" { radioButton.isSelected = true
            self.mieczaki_opis.text = "Z_BEZ DANIA".localized()}
        default: break
        }
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.addTarget(self, action: #selector(ProfilViewController.logSelectedButton13), for: UIControlEvents.touchUpInside);
        self.myScrollView.addSubview(radioButton);
        return radioButton;
    }
    
    //----------------------------------
    //zmiana ustawień
    //----------------------------------
    //zboza
    @objc @IBAction private func logSelectedButton0(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 0: Shared.shared.alergik_temp[0] = "0"
                radioButton.isSelected = true
                self.zboza_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 1: Shared.shared.alergik_temp[0] = "1"
                radioButton.isSelected = true
                self.zboza_opis.text = "L_OSTRZEZENIA".localized()
        case 2: Shared.shared.alergik_temp[0] = "2"
                radioButton.isSelected = true
                self.zboza_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //skorupiaki
    @objc @IBAction private func logSelectedButton1(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 10: Shared.shared.alergik_temp[1] = "0"
                radioButton.isSelected = true
                self.skorupiaki_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 11: Shared.shared.alergik_temp[1] = "1"
                radioButton.isSelected = true
                self.skorupiaki_opis.text = "L_OSTRZEZENIA".localized()
        case 12: Shared.shared.alergik_temp[1] = "2"
                radioButton.isSelected = true
                self.skorupiaki_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //jaja
    @objc @IBAction private func logSelectedButton2(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 20: Shared.shared.alergik_temp[2] = "0"
        radioButton.isSelected = true
        self.jaja_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 21: Shared.shared.alergik_temp[2] = "1"
        radioButton.isSelected = true
        self.jaja_opis.text = "L_OSTRZEZENIA".localized()
        case 22: Shared.shared.alergik_temp[2] = "2"
        radioButton.isSelected = true
        self.jaja_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //ryby
    @objc @IBAction private func logSelectedButton3(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 30: Shared.shared.alergik_temp[3] = "0"
        radioButton.isSelected = true
        self.ryby_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 31: Shared.shared.alergik_temp[3] = "1"
        radioButton.isSelected = true
        self.ryby_opis.text = "L_OSTRZEZENIA".localized()
        case 32: Shared.shared.alergik_temp[3] = "2"
        radioButton.isSelected = true
        self.ryby_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //o_ziemne
    @objc @IBAction private func logSelectedButton4(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 40: Shared.shared.alergik_temp[4] = "0"
        radioButton.isSelected = true
        self.ziemne_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 41: Shared.shared.alergik_temp[4] = "1"
        radioButton.isSelected = true
        self.ziemne_opis.text = "L_OSTRZEZENIA".localized()
        case 42: Shared.shared.alergik_temp[4] = "2"
        radioButton.isSelected = true
        self.ziemne_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //soja
    @objc @IBAction private func logSelectedButton5(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 50: Shared.shared.alergik_temp[5] = "0"
        radioButton.isSelected = true
        self.soja_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 51: Shared.shared.alergik_temp[5] = "1"
        radioButton.isSelected = true
        self.soja_opis.text = "L_OSTRZEZENIA".localized()
        case 52: Shared.shared.alergik_temp[5] = "2"
        radioButton.isSelected = true
        self.soja_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //mleko
    @objc @IBAction private func logSelectedButton6(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 60: Shared.shared.alergik_temp[6] = "0"
        radioButton.isSelected = true
        self.mleko_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 61: Shared.shared.alergik_temp[6] = "1"
        radioButton.isSelected = true
        self.mleko_opis.text = "L_OSTRZEZENIA".localized()
        case 62: Shared.shared.alergik_temp[6] = "2"
        radioButton.isSelected = true
        self.mleko_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //orzechy
    @objc @IBAction private func logSelectedButton7(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 70: Shared.shared.alergik_temp[7] = "0"
        radioButton.isSelected = true
        self.orzechy_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 71: Shared.shared.alergik_temp[7] = "1"
        radioButton.isSelected = true
        self.orzechy_opis.text = "L_OSTRZEZENIA".localized()
        case 72: Shared.shared.alergik_temp[7] = "2"
        radioButton.isSelected = true
        self.orzechy_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //seler
    @objc @IBAction private func logSelectedButton8(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 80: Shared.shared.alergik_temp[8] = "0"
        radioButton.isSelected = true
        self.seler_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 81: Shared.shared.alergik_temp[8] = "1"
        radioButton.isSelected = true
        self.seler_opis.text = "L_OSTRZEZENIA".localized()
        case 82: Shared.shared.alergik_temp[8] = "2"
        radioButton.isSelected = true
        self.seler_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //gorczyca
    @objc @IBAction private func logSelectedButton9(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 90: Shared.shared.alergik_temp[9] = "0"
        radioButton.isSelected = true
        self.gorczyca_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 91: Shared.shared.alergik_temp[9] = "1"
        radioButton.isSelected = true
        self.gorczyca_opis.text = "L_OSTRZEZENIA".localized()
        case 92: Shared.shared.alergik_temp[9] = "2"
        radioButton.isSelected = true
        self.gorczyca_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //sezam
    @objc @IBAction private func logSelectedButton10(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 100: Shared.shared.alergik_temp[10] = "0"
        radioButton.isSelected = true
        self.sezam_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 101: Shared.shared.alergik_temp[10] = "1"
        radioButton.isSelected = true
        self.sezam_opis.text = "L_OSTRZEZENIA".localized()
        case 102: Shared.shared.alergik_temp[10] = "2"
        radioButton.isSelected = true
        self.sezam_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //siarczany
    @objc @IBAction private func logSelectedButton11(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 110: Shared.shared.alergik_temp[11] = "0"
        radioButton.isSelected = true
        self.siarczany_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 111: Shared.shared.alergik_temp[11] = "1"
        radioButton.isSelected = true
        self.siarczany_opis.text = "L_OSTRZEZENIA".localized()
        case 112: Shared.shared.alergik_temp[11] = "2"
        radioButton.isSelected = true
        self.siarczany_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //lubin
    @objc @IBAction private func logSelectedButton12(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 120: Shared.shared.alergik_temp[12] = "0"
        radioButton.isSelected = true
        self.lubin_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 121: Shared.shared.alergik_temp[12] = "1"
        radioButton.isSelected = true
        self.lubin_opis.text = "L_OSTRZEZENIA".localized()
        case 122: Shared.shared.alergik_temp[12] = "2"
        radioButton.isSelected = true
        self.lubin_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    //mięczaki
    @objc @IBAction private func logSelectedButton13(radioButton : DLRadioButton) {
        switch radioButton.selected()!.tag {
        case 130: Shared.shared.alergik_temp[13] = "0"
        radioButton.isSelected = true
        self.mieczaki_opis.text = "L_BEZ_OSTRZEZENIA".localized()
        case 131: Shared.shared.alergik_temp[13] = "1"
        radioButton.isSelected = true
        self.mieczaki_opis.text = "L_OSTRZEZENIA".localized()
        case 132: Shared.shared.alergik_temp[13] = "2"
        radioButton.isSelected = true
        self.mieczaki_opis.text = "Z_BEZ DANIA".localized()
        default: break
        }
    }
    
    @objc @IBAction private func zapisTapped() {
        self.reachability = Reachability.init()
        if((self.reachability!.connection) != .none){ //jeżeli jest Internet
            //----- wskaźnik aktywności-------
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            //---------------------------------
            
            let res = aktualizujUser()
            
            if res == 1 {//jeżeli udało się zapisać zmiany na serwerze
                siec = Network()
                
                //skasowanie wszystkich dań z tabeli 'dania'
                _ = StephencelisDB.instance.deleteDaniaAll()
                
                //pobranie lokalizacji z tabeli 'memory->mem_lok'
                location = StephencelisDB.instance.getMemory(memo: "mem_lok")


                //czy jest restauracja? bo jeśli nie to załaduj domyślne (wszystkie z Konina)
                if location![0].e != "0" { //jeżeli nie są wybrane "Wszystkie" rest w mieście
                    _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                }else{ //są wybrane "Wszystkie"
                    //pobranie dań dla wszystkich restauracji w miescie (bez filtrów bo skasowane i uaktualnione)
                    _ = siec?.importujDania(link: "http://www.cobytu.com/cbt.php?d=ios_dania&uz_id=\(Shared.shared.uz_id!)&woj_id=\(location![0].a)&mia_id=\(location![0].c)&rest=\(location![0].e)&lang=\(Localize.currentLanguage())")
                }
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                
                    AppDelegate.refresh_list_meal = true
                    
                    //----- wskaźnik aktywności-------
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    //---------------------------------
                    _ = self.navigationController?.popViewController(animated: true) //powrót
                    }
            }
        }else{ //jeżeli nie ma Internetu
            displayAlert()
        }
    }
    
    //----------------------------------------------------------
    //aktualizacja danych użytkownika na serwerze
    //----------------------------------------------------------
    func aktualizujUser()  -> Int  {
        //send HTTP Request to Register user
        let myUrl = URL(string: "https://www.cobytu.com/cbt_ios_user.php")
        var request = URLRequest(url: myUrl!)
        var check = "0"
        if box.on {check = "1"} else {check = "0"}
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["uz_id": Shared.shared.uz_id,
                          "uz_email": emailField.text!,
                          "uz_student": check,
                          "au_zboza": Shared.shared.alergik_temp[0],
                          "au_skorupiaki": Shared.shared.alergik_temp[1],
                          "au_jaja": Shared.shared.alergik_temp[2],
                          "au_ryby": Shared.shared.alergik_temp[3],
                          "au_o_ziemne": Shared.shared.alergik_temp[4],
                          "au_soja": Shared.shared.alergik_temp[5],
                          "au_mleko": Shared.shared.alergik_temp[6],
                          "au_orzechy": Shared.shared.alergik_temp[7],
                          "au_seler": Shared.shared.alergik_temp[8],
                          "au_gorczyca": Shared.shared.alergik_temp[9],
                          "au_sezam": Shared.shared.alergik_temp[10],
                          "au_siarczany": Shared.shared.alergik_temp[11],
                          "au_lubin": Shared.shared.alergik_temp[12],
                          "au_mieczaki": Shared.shared.alergik_temp[13]] as [String: String]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error {
            print(error.localizedDescription)
            return 0
        }
        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error======\(String(describing: error))")
                return
            }
            
            //konwertowanie danych odebranych z serwera
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                print ("json:====== \(String(describing: json!))")
                //print ("json:==\(String(describing: json!["error_email"]!))")
                
                let success = String(describing: json!["success"])
                print("ss=\(success)")
                
                if (success != "Optional(1)"){
                    return
                }else{
                    //powiodło sie)
                    //AppDelegate.lubienie_zmienione = true //zmieniono ocenę składników
                    //AppDelegate.refresh_list_meal = true //trzeba odświerzyć listę dań
                    Shared.shared.uz_email = json!["uz_email"] as? String
                    Shared.shared.uz_student = json!["uz_student"] as? String
                    return
                }
            } catch{
                print(error)
            }
        }
        task.resume()
        return 1
    }
    
    //komunikat "Brak Internetu"
    func displayAlert() {
        let alertViev = UIAlertController (title: "L_BRAK_INTERNETU".localized(), message: "L_URUCHOM_INTERNET".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "L_ANULUJ".localized(), style: .default)
        alertViev.addAction(cancel)
        
        present(alertViev, animated: true, completion: nil)
    }

}
