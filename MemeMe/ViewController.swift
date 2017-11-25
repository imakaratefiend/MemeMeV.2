//
//  ViewController.swift
//  MemeMe
//
//  Created by Bradley Hill on 6/4/17.
//  Copyright © 2017 Bradley Hill. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate  {

    let textFieldDelegate = TextEditorDelegate()
    


    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareMeme: UIBarButtonItem!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelMemeEditor: UIBarButtonItem!
    
    
    var topConstraint : NSLayoutConstraint!
    var bottomConstraint : NSLayoutConstraint!
    var meme: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareMeme.isEnabled = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.meme = appDelegate.memes
        
        
 // MARK: - Text field attribute declarations
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"

        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0]
        
        func setTextFields(_ textField: UITextField) {
            textField.defaultTextAttributes = memeTextAttributes
            textField.delegate = self.textFieldDelegate
            textField.adjustsFontSizeToFitWidth = true
            textField.backgroundColor = UIColor.clear
            textField.borderStyle = UITextBorderStyle.none
            textField.textAlignment = .center
        }
        
        
        setTextFields(topText)
        setTextFields(bottomText)
        
    }
    
    
    
 // MARK: - Override Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTextFields() // Please see notes preceding the code for this helper function called "layoutTextFields() for proper credit
    }
    
 // MARK: - Creating/Saving meme image
    
    
    func generateMemedImage() -> UIImage {
        

        hideToolBars(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        

        hideToolBars(hide: false)
        
        return memedImage
    }
    
    
    func saveMeme() {
        // Create the meme
        
       let meme = Meme(topTextField: topText.text!, bottomTextField: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }


    @IBAction func shareMeme(_ sender: Any) {
        
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) -> Void in
            if (completed) {
                self.saveMeme()
            }
        }
    }
    
    func hideToolBars(hide: Bool){
        topToolBar.isHidden = hide
        bottomToolBar.isHidden = hide
    }

    // MARK: - Dismiss Meme Editor
    
    @IBAction func cancelMemeEditor(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}

 // MARK: - UIImagePickerControllerDelegate
 extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePickerView.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let source = UIImagePickerControllerSourceType.photoLibrary
        chooseSourceType(source: source)

    }
 
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let source = UIImagePickerControllerSourceType.camera
        chooseSourceType(source: source)
    }

    func chooseSourceType(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        shareMeme.isEnabled = true
    }
    
}

 // MARK: - UINavigationControllerDelegate
 extension ViewController: UINavigationControllerDelegate {
 
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
 
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
 
    func keyboardWillShow(_ notification:Notification) {
        if(bottomText.isFirstResponder) {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
 
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
 
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    
    
    // The following code/logic was largely followed from the website referenced below and is not completey my own. After 
    // researching,  this was the only solution I could find that would get the proper functionality for different
    // sized images. I did not copy verbtim, but the concept and a large part of the logic was followed.
    // Code was updated to reflect current Swift standards, and variable names were changed to reflect the coding I have adopted.
    // https://stackoverflow.com/questions/32479499/updating-auto-layout-constraints-to-reposition-text-field
    
    
    func layoutTextFields() {
        
        //Delete any existing constraings
        if topTextStackViewConstraint != nil {
            view.removeConstraint(topTextStackViewConstraint)
        }
        
        if bottomTextStackViewConstraint != nil {
            view.removeConstraint(bottomTextStackViewConstraint)
        }
        
        //Get the position of the image inside the imageView
        let size = imagePickerView.image != nil ? imagePickerView.image!.size : imagePickerView.frame.size
        let frame = AVMakeRect(aspectRatio: size, insideRect: imagePickerView.bounds)
 
        //Set a new margin constant of .25%
        let margin = frame.origin.y + frame.size.height * 0.0001


        //Create and add the new constraints
        topTextStackViewConstraint = NSLayoutConstraint(
            item: topText,
            attribute: .top,
            relatedBy: .equal,
            toItem: imagePickerView,
            attribute: .top,
            multiplier: 1.0,
            constant: margin)
        topTextStackViewConstraint.isActive = true
        
        bottomTextStackViewConstraint = NSLayoutConstraint(
            item: bottomText,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: imagePickerView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -margin)
        bottomTextStackViewConstraint.isActive = true
        
        }
    
    // End of followed code from website noted above
    
}
 


