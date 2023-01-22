//
//  MessageViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-14.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift
class MessageViewController: MessagesViewController {

    
    
    let leftbarButtonView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        return view
    }()
    let subTitleLabel:UILabel = {
       let subtitle = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20))
        subtitle.textAlignment = .left
        subtitle.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        subtitle.adjustsFontSizeToFitWidth = true
        return subtitle
    }()
    
    let titleLabel:UILabel = {
       let title = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    var chatId = ""
    var recepientId = ""
    var recepientName = ""
    let refreshcontroller = UIRefreshControl()
    let micBtn = InputBarButtonItem()
    var notificationToken:NotificationToken?
    var mkMessages:[MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    let realm = try! Realm()
    var displayMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    var typingCounter = 0
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    init(chatId: String = "", recepientId: String = "", recepientName: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recepientId = recepientId
        self.recepientName = recepientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = recepientName
        configcollectionview()
        configmessageinputbar()
        loadChats()
        listenForNewChats()
        createTypingObserver()
        configLeftBarButton()
        configcustomTitle()
//        updateTypingIndicator(true)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configcollectionview()
    {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = false
        messagesCollectionView.refreshControl = refreshcontroller
    }
    
    
    func configmessageinputbar()
    {
        messageInputBar.delegate = self
        let attachBtn = InputBarButtonItem()
        attachBtn.image = UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        attachBtn.setSize(CGSize(width: 30, height: 30), animated: false)
        attachBtn.onTouchUpInside { item in
            print("bbtn pressed")
            
        }
     
        micBtn.image = UIImage(systemName: "mic")
        micBtn.setSize(CGSize(width: 30, height: 30), animated: false)
//        micBtn.onTouchUpInside { item in
//            print("bbtn pressed")
//
//        }
        messageInputBar.setStackViewItems([attachBtn], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        updateMicButtonStatus(show:true)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
//        messageInputBar.setStackViewItems([micBtn], forStack: .right, animated: false)
//        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)

        

    }
    
    func updateMicButtonStatus(show:Bool)
    {
        if show{
            messageInputBar.setStackViewItems([micBtn], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    
    

    func messageSend(text:String?,photo:UIImage?,video:String?,audio:String?,location:String?,audioDuration:Float = 0.0)
    {
        OutgoingMessage.send(chatid: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberids: [User.currentId,recepientId])
    }
  
    
    func loadChats(){
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
    
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: "date",ascending: true)
        
        if allLocalMessages.isEmpty{
            checkforoldchats()
        }
        
        notificationToken = allLocalMessages.observe({ (changes:RealmCollectionChange) in
            switch changes {
            case .initial:
                self.inseertMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .update(_,_, let insertions ,_ ):
                for index in insertions{
                    self.insertMessage(localMessage: self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)

                }
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
    }
    
    func listenForNewChats(){
        FirebaseMessageListner.shared.listenForNewChats(documentId: User.currentId, collectionid: chatId, lastMessageDate: lastMessageDate())
    }
    
    func checkforoldchats(){
        FirebaseMessageListner.shared.checkforoldchats(documentid: User.currentId, collectionId: chatId)
    }
    
    
    func inseertMessages(){
        maxMessageNumber = allLocalMessages.count - displayMessagesCount
        minMessageNumber = maxMessageNumber - knumberofmessages
        
        if(minMessageNumber < 0)
        {
            minMessageNumber = 0
        }
        
        for i in minMessageNumber..<maxMessageNumber{
            insertMessage(localMessage: allLocalMessages[i])

        }
    }
    
    func insertMessage(localMessage:LocalMessage){
        
        let incoming = IncomingMessage(messageCollectionView: self)
        self.mkMessages.append(incoming.createMessage(localMessage: localMessage))
        displayMessagesCount += 1
    }

    func insertOlderMessage(localMessage:LocalMessage){
        
        let incoming = IncomingMessage(messageCollectionView: self)
        self.mkMessages.insert(incoming.createMessage(localMessage: localMessage), at: 0)
        
        displayMessagesCount += 1
    }
    
    func loadMoreMessages(maxNum:Int, minNum:Int)
    {
         maxMessageNumber = minNum - 1
        minMessageNumber = maxMessageNumber - knumberofmessages
        if minMessageNumber < 0{
            minMessageNumber = 0
            
        }
        for i in (minMessageNumber ... maxMessageNumber).reversed(){
            insertOlderMessage(localMessage: allLocalMessages[i])
            displayMessagesCount += 1
        }
        
    }
    func configLeftBarButton(){
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backbtnPress))]
    }
    
    func configcustomTitle(){
        leftbarButtonView.addSubview(titleLabel)
        leftbarButtonView.addSubview(subTitleLabel)
        let leftbarButtonItem = UIBarButtonItem(customView: leftbarButtonView)
        self.navigationItem.leftBarButtonItems?.append(leftbarButtonItem)
        titleLabel.text = recepientName
        
    }
    
    func createTypingObserver(){
        FirebaseTypingListener.shared.createTypingObserver(chatRoomId: chatId) { isTyping in
            DispatchQueue.main.async {
                self.updateTypingIndicator(isTyping)
            }
        }
    }
    func typingIndecatorUpdate(){
        typingCounter += 1
        FirebaseTypingListener.saveTypingCounter(typing: true, chatRoomId: chatId)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
            self.typingCounterStop()
        }
    }
    
    func typingCounterStop(){
        typingCounter -= 1
        if typingCounter == 0{
            FirebaseTypingListener.saveTypingCounter(typing: false, chatRoomId: chatId)
        }
    }
    
    func updateTypingIndicator(_ show:Bool){
        subTitleLabel.text = show ? "Typing... " : ""
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshcontroller.isRefreshing{
            if displayMessagesCount < allLocalMessages.count{
                self.loadMoreMessages(maxNum: maxMessageNumber, minNum: minMessageNumber)
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            refreshcontroller.endRefreshing()
        }
    }
    
    func lastMessageDate()->Date{
        let lastmess = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second,value: 1, to: lastmess) ?? lastmess
    }
    
    func removeListener(){
        FirebaseTypingListener.shared.removeTypingListener()
        FirebaseMessageListner.shared.removeListener()
    }
    
    @objc func backbtnPress(){
        FirebaseRecentListner.shared.resetRecentCounter(chatRoomId: chatId)
        removeListener()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
