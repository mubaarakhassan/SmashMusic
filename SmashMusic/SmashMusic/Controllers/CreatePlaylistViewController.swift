//
//  CreatePlaylistViewController.swift
//  SmashMusic
//
//  Created by Mubaarak Hassan on 05/11/2017.
//  Copyright © 2017 Mubaarak Hassan. All rights reserved.
//

import UIKit

class CreatePlaylistViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var descriptionText: UITextField!
    
    @IBOutlet weak var playlistImage: UIImageView!
    
    var playlistVC : PlaylistViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.text = ""
        playlistImage.image = UIImage(named: "default_cover")
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
    // not working stuff on ipad, redirects directly to photolibary...
        if UIDevice.current.modelName.contains("iPad") {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
        else {

            let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary                
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.barButtonItem = sender as? UIBarButtonItem
            }
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        playlistImage?.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        
        if(titleText.text != ""){
            let playlist = PlaylistData(context: PersistenceService.context)
            playlist.name = titleText.text
            playlist.descriptions = descriptionText.text
            playlist.image = UIImagePNGRepresentation(playlistImage.image!) as NSData?
            playlistVC.arrayOfPlaylists.append(playlist)
            PersistenceService.saveContext()
            let insertionIndexPath = IndexPath(row: playlistVC.arrayOfPlaylists.count - 1, section: 0)
            
            playlistVC.tableView.beginUpdates()
            playlistVC.tableView.insertRows(at: [insertionIndexPath], with: .automatic)
            playlistVC.tableView.endUpdates()
            navigationController?.popViewController(animated: true)

        } else{
            showErrorMessage("Playlist needs to have a title")
        }
    }
    
    
    func showErrorMessage(_ message: String){
        let alert = UIAlertController(title: "Playlist cannot be added", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
