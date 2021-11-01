//
//  HomeDetailVC.swift
//  MyEasyNotes
//
//  Created by admin on 12/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import DatePickerDialog
import CoreData
import SwiftyJSON

protocol ObjectSavable {
    func setObjectClass<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObjectClass<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

protocol NotesSavedDelegate {
    func notesSaved()
}

class HomeDetailVC: UIViewController {
    
    @IBOutlet weak var lblCurrentDate : UILabel!
    
    @IBOutlet weak var tblShowContent : UITableView!
    @IBOutlet weak var tblAddContent : UITableView!
    
    @IBOutlet weak var consItemVWHeight : NSLayoutConstraint!
    @IBOutlet weak var btnAddItem : UIButton!
    
    @IBOutlet weak var collAddContent : UICollectionView!
    var arrOfColor = [DataUtils.hexStringToUIColor(hex: "#00FFFF"),DataUtils.hexStringToUIColor(hex: "#0000A0"),DataUtils.hexStringToUIColor(hex: "#ADD8E6"),DataUtils.hexStringToUIColor(hex: "#FFFF00"),DataUtils.hexStringToUIColor(hex: "#FFA500"),DataUtils.hexStringToUIColor(hex: "#00FF00"),DataUtils.hexStringToUIColor(hex: "#A52A2A"),DataUtils.hexStringToUIColor(hex: "#FF00FF"),DataUtils.hexStringToUIColor(hex: "#800000"),DataUtils.hexStringToUIColor(hex: "#C0C0C0"),DataUtils.hexStringToUIColor(hex: "#008000"),DataUtils.hexStringToUIColor(hex: "#808080"),DataUtils.hexStringToUIColor(hex: "#808000")]
    
    var shareManager : Globals = Globals.sharedInstance

    var isReload = false
    
    var arrSelectItem = ["Add Image","Add Reminder","Save to File Manager","Share Note as Text","Delete Note"]
    var arrImgItem = ["addimage","addreminder","addfile","share","delete"]
    
    var modelSelectionItem : NotesAddingModel!
    
    var imageArr = [FileTypeInfo]()
    var selectedColor : [SelectedColor]?
    
    
    var moc:NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var delegate: NotesSavedDelegate? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        moc = appDelegate?.persistentContainer.viewContext

        selectedColor=[SelectedColor]()
        for _ in 0..<arrOfColor.count {
            let colo = SelectedColor()
            colo.isSelectedColor = false
            selectedColor?.append(colo)
        }
        NotificationCenter.default.addObserver(self,selector: #selector(getFileData(notification:)),name: NSNotification.Name(rawValue: "fileSelectionclicked"), object: nil)
        lblCurrentDate.text = Date().string(format: Constants.DateCons.dateTime.rawValue)
        
        modelSelectionItem=NotesAddingModel()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func getFileData(notification : NSNotification)  {
        guard let dictFile  = notification.userInfo
            else {
                return
        }
        
        let fileData = FileTypeInfo()
        fileData.fileData = dictFile["fileData"] as! Data
        fileData.fileName = dictFile["fileName"] as! String
        fileData.uploadFileKey = dictFile["uploadFileKey"] as! String
        fileData.mimeType = dictFile["mimeType"] as! String
        
        imageArr.append(fileData)
        self.modelSelectionItem.images.append(fileData.fileData)
       tblShowContent.reloadData()
    }
    
    @IBAction func btnActionAddItems(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.5) {
            if !sender.isSelected {
                self.consItemVWHeight.constant = 400
                // self.imgArrow.image = UIImage(named: "")
                self.isReload = false
            }else {
                self.consItemVWHeight.constant = 70//self.btnAddItem.frame.size.height
                // self.imgArrow.image = UIImage(named: "")
                self.isReload = true
            }
            self.view.layoutIfNeeded()
            
            self.tblShowContent.reloadData()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnActionSave(_ sender: Any) {
        self.view.endEditing(true)
        
        let item1 = NotesAddingModel()
        item1.title = "sfdsdsds"
        
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(item1)
            
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            print(json)
            var userDefaults = UserDefaults.standard
            userDefaults.set(json, forKey: "MyEasyNotes")
            userDefaults.synchronize()
        } catch is Error {
                
        }
      
//
//        do {
//            try shareManager.userDefaults.setObjectClass(item1, forKey: "MyEasyNotes")
//        } catch {
//            print(error.localizedDescription)
//        }
        self.delegate?.notesSaved()
      _ = self.navigationController?.popViewController(animated: true)
    }
}

extension HomeDetailVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag != 1002 {
            return arrOfColor.count
        }
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag != 1002 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollCell", for: indexPath) as! CircleCollCell
            cell.circleBack.backgroundColor = arrOfColor[indexPath.row]
            cell.circleBorder.backgroundColor = arrOfColor[indexPath.row]
            if selectedColor?[indexPath.row].isSelectedColor == true {
                cell.imgCircle.image = UIImage(named: "checktick")
            }else {
               cell.imgCircle.image = UIImage(named: "")
            }
            
            return cell

        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailImgCollCell", for: indexPath) as! DetailImgCollCell
            if imageArr.count > 0 {
                cell.img.image = UIImage(data: imageArr[indexPath.row].fileData)
            }
            return cell

        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailImgCollCell", for: indexPath) as! DetailImgCollCell
        if imageArr.count > 0 {
            _ = UIImage(data: imageArr[indexPath.row].fileData)
            cell.img.image = UIImage(data: imageArr[indexPath.row].fileData)
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.modelSelectionItem.colorOfObj = arrOfColor[indexPath.row]
        for i in 0..<selectedColor!.count   {
            if indexPath.row == i {
                selectedColor![i].isSelectedColor = true
            }else {
                selectedColor![i].isSelectedColor = false
            }
        }
        
        tblShowContent.reloadData()
        collectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1005
        {
            return CGSize(width: 70, height: 70)

        }
        return CGSize(width: collectionView.frame.size.width/2 - 30, height: collectionView.frame.size.height)
    }
}


extension HomeDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblShowContent {
            return 4
        }
        
        return arrSelectItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblShowContent {
            if indexPath.row == 0 {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleCell
                cell.txtFldTitle.delegate = self
                
                cell.txtFldTitle.textColor = self.modelSelectionItem.colorOfObj
                cell.vwSide.backgroundColor = self.modelSelectionItem.colorOfObj

                self.modelSelectionItem.title = cell.txtFldTitle.text
                return cell
                
            }else if indexPath.row == 1 {
                
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
                if self.modelSelectionItem.reminders.count > 0 {
                    cell.lblReminder.text = self.modelSelectionItem.reminders[0]
                }
                return cell
            }else if indexPath.row == 2 {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
                if self.imageArr.count > 0 {
                    cell.imageArr = self.imageArr
                }
                return cell
            }else if indexPath.row == 3 {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "ContentTextCell", for: indexPath) as! ContentTextCell
                cell.txtVwNotes.delegate = self
                return cell
            }
        }
        else {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell", for: indexPath) as! SelectItemCell
            cell.lblItem.text = arrSelectItem[indexPath.row]
            cell.imgItem.image = UIImage(named: arrImgItem[indexPath.row])
            
            return cell
        }
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "SelectItemCell", for: indexPath) as! SelectItemCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? ImageCell else { return }

        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: 1002)

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblShowContent {
            switch indexPath.row {
            case 0:
                return
                
            case 1:
             openReminder()
            default:
                return
            }
            tblShowContent.reloadData()
        }else {
            switch indexPath.row {
            case 0:
                modelSelectionItem.isImages = true
                openFiles()
            case 1:
                modelSelectionItem.isReminder = true
                openReminder()
                
            default:
                return
            }
            tblShowContent.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblShowContent {
            switch indexPath.row {
            case 0:
                return 80
            case 1:
                if modelSelectionItem.isReminder {
                    return 100
                }
                return 0
            case 2:
                if modelSelectionItem.isImages {
                    if imageArr.count > 0 {
                        return 170
                    }
                }
                return 0
            case 3:
                if isReload {
                    return 400
                }
                return 140
            case 4:
                return 60
            default:
                return 70
            }
        }
        return 60
    }
    
    func openReminder()  {
        DatePickerDialog().show("Check OUT", doneButtonTitle: "done", cancelButtonTitle: "cancel", datePickerMode: .dateAndTime) { (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "E, d MMM yyyy HH:mm:ss a"
                let str1 = formatter1.string(from: dt)
                self.modelSelectionItem.reminders = []
                self.modelSelectionItem.reminders.append(str1)
                self.tblShowContent.reloadData()
                // self.birthdayField.text = formatter.string(from: dt)
            }
        }
    }
    
    func openFiles()  {
        AttachmentHandler.shared.showImageLibraryList(vc: self)
    }
}

extension HomeDetailVC : UITextFieldDelegate,UITextViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
     
        self.modelSelectionItem.title = textField.text

    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.modelSelectionItem.contentTxt = []
        self.modelSelectionItem.contentTxt.append(textView.text)

        return true
    }
}

class SelectedColor {
    var isSelectedColor = false
}

