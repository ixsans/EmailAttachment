//
//  AttachmentTableViewController.swift
//  EmailAttachment
//

import UIKit
import MessageUI

class AttachmentTableViewController: UITableViewController, MFMailComposeViewControllerDelegate{

    let filenames = ["10 Great iPhone Tips.pdf", "camera-photo-tips.html", "foggy.jpg", "Hello World.ppt", "no more complaint.png", "Why Appcoda.doc"]
    
    enum MIMEType: String{
        case jpg = "image/jpeg"
        case png = "image/png"
        case doc = "application/msword"
        case ppt = "applicatiion/vnd.ms-powerpoint"
        case html = "text/html"
        case pdf = "application/pdf"
        
        init?(type: String) {
            switch type.lowercased() {
                case "jpg" : self = .jpg
                case "png" : self = .png
                case "doc" : self = .doc
                case "html" : self = .html
                case "pdf" : self = .pdf
                default: return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return filenames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = filenames[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon\(indexPath.row)");

        return cell
    }
    
    func showEmail(attachment: String) {
        
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let emailTitle = "Great Photo and Doc"
        let messageBody = "Hey, check this out!"
        let recipients = ["ixsan.muslim@gmail.com"]
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(recipients)
        print("AAAA1")
        
        let fileparts = attachment.components(separatedBy: ".")
        let filename = fileparts[0]
        let fileExtension = fileparts[1]
        
        guard let filePath = Bundle.main.path(forResource: filename, ofType: fileExtension) else {
            return
        }
        
        if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
            let mimeType = MIMEType(type: fileExtension) {
            
            mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: filename)
            
            
            present(mailComposer, animated: true, completion: nil)
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
            case MFMailComposeResult.sent:
                print("Mail sent")
            case MFMailComposeResult.saved:
                print("Mail saved")
            case MFMailComposeResult.failed:
                print("Mail failed")
            case MFMailComposeResult.cancelled:
                print("Mail cancelled")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = filenames[indexPath.row]
        showEmail(attachment: selectedFile)
    }

}
