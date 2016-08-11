//
//  ViewController.swift
//  Downloader
//
//  Created by Kushagra Gupta on 08/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit

var fileURL:NSURL?

class DownloadViewController: UIViewController, UITextFieldDelegate, NSURLSessionDataDelegate{
    
    //Mark: Properties
    
    
    var url:String! = " "
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var showImage: UIButton!
    @IBOutlet weak var saveStatus: UILabel!
    @IBOutlet weak var showPercentageDownload: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var showStatus: UILabel!
    @IBOutlet weak var urlTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        showImage.hidden = true
        progressBar.hidden = true
        progressBar.setProgress(0.0, animated: true)
        urlTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        url = textField.text
        //print(url)
    }
    
    //Mark: Actions
    
    @IBAction func resetDownload(sender: UIButton) {
        
        showStatus.text = " "
        progressBar.setProgress(0.0, animated: false)
        progressBar.hidden = true
        showPercentageDownload.text = " "
        saveStatus.text = " "
        showImage.hidden = true
        downloadButton.enabled = true
    }
    
    @IBAction func downloadUrl(sender: UIButton) {
        urlTextField.resignFirstResponder()
        url = urlTextField.text
        showStatus.text = "Downloading..."
        progressBar.hidden = false
        resetButton.enabled = false
        downloadButton.enabled = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let download_url = NSURL(string: url)
        let downloadSession:NSURLSession = {
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            return session
        }()
        let task = downloadSession.downloadTaskWithURL(download_url!)

        task.resume()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
        
        let filename = (self.url as NSString).lastPathComponent
        let file_extension = (self.url as NSString).pathExtension
        print(file_extension)
        print(filename)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let fileManager = NSFileManager.defaultManager()
        let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        fileURL = documents.URLByAppendingPathComponent(filename)
        print(fileURL)
        do {
                try fileManager.moveItemAtURL(location, toURL: fileURL!)
                saveStatus.text = "\(filename) Saved"
            
            } catch {
                        print(error)
                        saveStatus.text = "File not saved: It exists"
                    }
        
        let imageExtensions:[String] = ["jpg","jpeg","png","gif","xmf"]
        if imageExtensions.indexOf(file_extension) != nil{
            print("Image Found")
            dispatch_async(dispatch_get_main_queue(),{
            self.showImage.hidden = false
            })
        }
                            
    }

    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        let taskTotalBytesWritten = Int(writ)
        let taskTotalBytesExpectedToWrite = Int(exp)
        let percentageWritten = Float(taskTotalBytesWritten) / Float(taskTotalBytesExpectedToWrite)
        dispatch_async(dispatch_get_main_queue(),{
            self.progressBar.setProgress(percentageWritten, animated:true)
            print(percentageWritten)
            self.showPercentageDownload.text = "\(percentageWritten*100)%"
            if percentageWritten == 1.0
            {
                self.showStatus.text = "Download Finished"
                self.resetButton.enabled = true
            }}
        )
    }
    
}


