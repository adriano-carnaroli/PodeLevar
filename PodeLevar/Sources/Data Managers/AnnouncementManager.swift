//
//  AnnouncementManager.swift
//  PodeLevar
//
//  Created by Adriano Carnaroli on 29/04/21.
//

import Foundation

class AnnouncementManager {
      
    let service = FirestoreService()

    func getAll(_ completion: @escaping CompletionObject<[ObjectAnnouncement]>) {
        //guard let userID = UserManager().currentUserID() else { return }
        //let query = FirestoreService.DataQuery(key: "userIDs", value: userID, mode: .contains)
        service.objectWithListener(ObjectAnnouncement.self, reference: .init(location: .announcement)) { results in
            completion(results)
        }
    }
  
    func create(_ announcement: ObjectAnnouncement, _ completion: @escaping CompletionObject<FirestoreResponse>) {
        FirestoreService().update(announcement, reference: .init(location: .announcement), completion: { result in
            self.update(announc: announcement, completion: { _ in
                completion(result)
            })
        })
    }
    
    func update(announc: ObjectAnnouncement, completion: @escaping CompletionObject<FirestoreResponse>) {
        FirestorageService().update(announc, reference: .announcement) { response in
            switch response {
                case .failure: completion(.failure)
                case .success:
                    FirestoreService().update(announc, reference: .init(location: .announcement), completion: { result in
                        completion(result)
                    })
            }
        }
    }
}

