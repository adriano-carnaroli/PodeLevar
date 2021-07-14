//
//  NewAnnouncementController.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 29/04/21.
//

import UIKit

class NewAnnouncementController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

class NewAnnouncementTableController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var txtTitle: UITextFieldX!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblPlaceholderDescription: UILabel!
    @IBOutlet weak var txtZipcode: UITextFieldX!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblImgCount: UILabel!
    @IBOutlet weak var collectionViewPictures: UICollectionView!
    
    private var selectedImages: [UIImage] = []
    private let imageService = ImagePickerService()
    private let userManager = UserManager()
    private let manager = AnnouncementManager()
    private var address:ZipcodeResponse?
    private var userName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDescription.returnKeyType = .done
        lblAddress.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEnableHideKeyboardWhenTapped()
        self.parent?.setEnableHideKeyboardWhenTapped()
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 1 && selectedImages.isEmpty) || (indexPath.row == 5 && lblAddress.text!.isEmpty) { return 0 }
        return UITableView.automaticDimension
    }
    
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailPictureCell.identifier, for: indexPath) as? ThumbnailPictureCell else { return UICollectionViewCell() }
        cell.imgThumbnail.image = selectedImages[indexPath.row]
        cell.onRemove = { void in self.removePic(indexPath.row) }
        return cell
    }

    func removePic(_ position: Int) {
        selectedImages.remove(at: position)
        updateScreen()
    }
    
    func updateScreen() {
        self.lblImgCount.text = "\(self.selectedImages.count)/6 imagens selecionadas"
        self.tableView.reloadData()
        self.collectionViewPictures.reloadData()
    }
    
    func validateFields() -> Bool {
        var message = ""
        if selectedImages.isEmpty {
            message = "Selecione ao menos uma foto."
        } else if txtTitle.text!.trim().count < 4 {
            message = "Insira um título para descrever o item."
        } else if txtDescription.text.trim().count < 4 {
            message = "Insira uma descrição com as condições e funcionamento do item doado."
        } else if txtZipcode.text!.trim().count < 9 || lblAddress.text!.isEmpty {
            message = "O CEP é inválido."
        }
        if !message.isEmpty {
            showToast(message: message, title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @IBAction func addPictures(_ sender: UIButton) {
        if selectedImages.count >= 6 {
            showToast(message: "Limite de imagens atingido", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
        } else {
            imageService.pickImage(from: self) {[weak self] image in
                self?.selectedImages.append(image)
                self?.updateScreen()
            }
        }
    }
    
    func showError() {
        showToast(message: "Erro ao salvar anúncio.", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if validateFields() {
            userManager.currentUserData {[weak self] user in
                if let userName = user?.name {
                    self?.userName = userName
                    self?.saveAnnouncement()
                } else {
                    self?.showError()
                }
            }
        }
    }
    
    func saveAnnouncement() {
        let announcement = ObjectAnnouncement()
        guard let userID = userManager.currentUserID() else { showError(); return }
        announcement.userId = userID
        announcement.userName = userName
        announcement.announcementPics = selectedImages
        announcement.title = txtTitle.text
        announcement.description = txtDescription.text
        announcement.zipcode = txtZipcode.text
        announcement.state = address!.uf
        announcement.city = address!.localidade
        announcement.district = address!.bairro
        announcement.insertDate = String.dateFormatter(date: Date(), patternOutput: "yyyy-MM-dd HH:mm:ss")
        showLoading(true)
        manager.create(announcement) {[weak self] response in
            ThemeService.showLoading(false)
            switch response {
                case .failure: self?.showAlert()
                case .success: self?.success()
            }
        }
    }
    
    func success() {
        showToast(message: "Anúncio publicado com sucesso!", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
        clearFields()
        updateScreen()
    }
    
    func clearFields() {
        txtTitle.text = ""
        txtDescription.text = ""
        lblPlaceholderDescription.isHidden = false
        txtZipcode.text = ""
        lblAddress.text = ""
        selectedImages = []
        address = nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}

//MARK: UITextField Delegate
extension NewAnnouncementTableController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let string = "\(textView.text!)\(text)"
        if string.count > 0 {
            lblPlaceholderDescription.isHidden = true
        }
        if text.isEmpty && string.count == range.length {
            lblPlaceholderDescription.isHidden = false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = "\(textField.text!)\(string)"
        if textField == txtZipcode && string != "" && text.count == 9 {
            textField.resignFirstResponder()
            getAddressBy(text.removeMaskFromZipcode())
        } else if textField == txtZipcode {
            if address != nil {
                self.address = nil
                self.lblAddress.text = ""
                tableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
            }
        }
        
        
        return true
    }
    
    func getAddressBy(_ zipcode:String) {
        showLoading(true)
        var request = URLRequest(url: URL(string: "https://viacep.com.br/ws/\(zipcode)/json/")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                self.address = try JSONDecoder().decode(ZipcodeResponse.self, from: data!) 
            } catch {
                self.address = nil
            }
            DispatchQueue.main.async {
                self.updateAddress()
                self.showLoading(false)
            }
        })
        task.resume()
    }
    
    func updateAddress() {
        if let address = self.address {
            self.lblAddress.text = "\(address.localidade)/\(address.uf)"
        } else {
            self.showToast(message: "CEP não encontrado!", title: nil, image: nil, tapCloseToast: nil, closeAutoToast: nil)
            self.lblAddress.text = ""
        }
        tableView.reloadData()
    }
}
