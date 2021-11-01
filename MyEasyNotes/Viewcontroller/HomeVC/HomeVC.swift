//
//  HomeVC.swift
//  MyEasyNotes
//
//  Created by admin on 09/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,NotesSavedDelegate{
    
    var shareManager : Globals = Globals.sharedInstance
    
    func notesSaved() {
      let userDefaults = UserDefaults.standard
        do {
            let playingItMyWay = UserDefaults.standard.data(forKey: "MyEasyNotes")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(playingItMyWay)
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print(error.localizedDescription)
        }

          
//        do {
//            let playingItMyWay = try shareManager.userDefaults.getObjectClass(forKey: "MyEasyNotes", castTo: NotesAddingModel.self)
//            print(playingItMyWay.title as? String)
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    
    var notesHeight = 0
    var notesModel : [NotesModel]!
    var imageHeight : CGFloat! {
        return 150
    }
    
    @IBOutlet weak var collectionNotes : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        let layout = WaterfallLayout()
        layout.delegate = self
        collectionNotes.collectionViewLayout = layout
        
        notesModel = [NotesModel]()
        
        let note1 = NotesModel()
        note1.isReminderNote = true
        note1.isImageNote = true
        note1.content = "hey this is my notes hey this is my notes hey this is my notes hey this is my noteshey this is my notes hey this is my notes hey this is my notes"
        notesModel.append(note1)
        
        let note2 = NotesModel()
        note2.isReminderNote = false
        note2.isImageNote = false
        note2.content = "hey this is my notes"
        notesModel.append(note2)
        
        let note3 = NotesModel()
        note3.isReminderNote = false
        note3.isImageNote = false
        note3.content = "hey this is my notes"
        notesModel.append(note3)
        
        let note4 = NotesModel()
        note4.isReminderNote = true
        note4.isImageNote = true
        note4.content = "hey this is my notes"
        notesModel.append(note4)
        
        let note5 = NotesModel()
        note5.isReminderNote = true
        note5.isImageNote = false
        note5.content = "hey this is my notes"
        notesModel.append(note5)
        
        let note6 = NotesModel()
        note6.isReminderNote = false
        note6.isImageNote = false
        note6.content = "hey this is my notes"
        notesModel.append(note6)
        
        let note7 = NotesModel()
        note7.isReminderNote = false
        note7.isImageNote = false
        note7.content = "hey this is my notes"
        notesModel.append(note7)
        
        let note8 = NotesModel()
        note8.isReminderNote = true
        note8.isImageNote = true
        note8.content = "hey this is my notes"
        notesModel.append(note8)
        
        let note9 = NotesModel()
        note9.isReminderNote = true
        note9.isImageNote = false
        note9.content = "hey this is my notes"
        notesModel.append(note9)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        do {
            let playingItMyWay = UserDefaults.standard.data(forKey: "MyEasyNotes")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(playingItMyWay)
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func serverRequest()  {
        
    }
    
    @IBAction func btnActionPlus(_ sender: UIButton) {
        let loginStoryBoard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
        loginStoryBoard.delegate = self
        self.navigationController?.pushViewController(loginStoryBoard, animated: true)
    }
}

extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollCell", for: indexPath) as! HomeCollCell
        cell.lblNotes.text = notesModel[indexPath.row].content
        if notesModel[indexPath.row].isImageNote {
            cell.consImgHeight.constant = imageHeight
        }else {
            cell.consImgHeight.constant = 0
        }
        
        if notesModel[indexPath.row].isReminderNote {
            cell.vwReminder.isHidden = false
        }else {
            cell.vwReminder.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let loginStoryBoard = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
        loginStoryBoard.delegate = self
        self.navigationController?.pushViewController(loginStoryBoard, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellHeight  = 100
        
        if notesModel[indexPath.row].isImageNote {
            cellHeight += Int(imageHeight)
        }
        if notesModel[indexPath.row].isReminderNote {
            cellHeight += 70
        }
        
        cellHeight += Int(notesModel[indexPath.row].content.heightWithConstrainedWidth(width: ((collectionView.frame.size.width - 30)/2), font: UIFont.systemFont(ofSize: 14)))
        
        return CGSize(width: Int((collectionView.frame.size.width - 30)/2), height: cellHeight)
        
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

extension HomeVC: WaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellHeight  = 100
        
        if notesModel[indexPath.row].isImageNote {
            cellHeight += Int(imageHeight)
        }
        if notesModel[indexPath.row].isReminderNote {
            cellHeight += 70
        }
        cellHeight += Int(notesModel[indexPath.row].content.heightWithConstrainedWidth(width: ((collectionView.frame.size.width - 30)/2), font: UIFont.systemFont(ofSize: 14)))
        return CGSize(width: Int((collectionView.frame.size.width - 30)/2), height: cellHeight)
    }
    
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .equal)
    }
}

extension HomeVC {}

