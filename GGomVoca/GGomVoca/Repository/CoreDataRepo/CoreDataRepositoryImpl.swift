//
//  CoredataRepositoryImpl.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine
import CoreData
class CoreDataRepositoryImpl : CoreDataRepository {

    // CloudKit database와 동기화하기 위해서는 NSPersistentCloudKitContainer로 변경
    
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    /*
    MARK: 데이터를 디스크에 저장하는 메서드
     */
    func saveContext() {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    /*
    MARK: 단어장 불러오기
     */
    func fetchVocaData() -> AnyPublisher<[Vocabulary], FirstPartyRepoError> {
        return Future<[Vocabulary], FirstPartyRepoError>{observer in
            let vocabularyFetch = Vocabulary.fetchRequest()
            
            do {
                let results = (try self.context.fetch(vocabularyFetch) as [Vocabulary])
                observer(.success(results))
            }catch{
                observer(.failure(FirstPartyRepoError.notFoundDataFromCoreData))
            }
            
           
//            print(cloudControlloer.fetchVocabulary(completion: {value in print("ok : \(value)")}))
            
        }.eraseToAnyPublisher()
        
    }
    /*
    MARK: 단어장 추가하기
     */
    func postVocaData(vocaName : String, nationality: String) -> AnyPublisher<Vocabulary, FirstPartyRepoError> {
      
        return Future<Vocabulary, FirstPartyRepoError>{[weak self] observer in
            
            guard let viewContext = self?.context else{
                return observer(.failure(FirstPartyRepoError.notFoundDataFromCoreData))
            }
            
            let newVocabulary = Vocabulary(context: viewContext)
            newVocabulary.id = UUID()
            newVocabulary.name = "\(vocaName)" // name
            newVocabulary.nationality = "\(nationality)" //"\(self.nationality)" // nationality
            newVocabulary.createdAt = "\(Date())"
            newVocabulary.words = NSSet(array: [])
            newVocabulary.updatedAt = "\(Date())"
            print("newVocabulary \(newVocabulary)")
            self?.saveContext()
           
            observer(.success(newVocabulary))
        }.eraseToAnyPublisher()
        
    }
    
    /*
    MARK: 단어장 고정 상태 업데이트하기
     */
    func updatePinnedVoca(id: UUID) -> AnyPublisher<String, FirstPartyRepoError> {
        
        return Future<String, FirstPartyRepoError>{[weak self] observer in
            
            guard let viewContext = self?.context else{
                return observer(.failure(FirstPartyRepoError.notFoundDataFromCoreData))
            }
            
            let vocabularyFetch = Vocabulary.fetchRequest()
            vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            let results = (try? viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
            do {
                let objectUpdate = results[0]
                objectUpdate.setValue(!objectUpdate.isPinned, forKey: "isPinned")
                print(objectUpdate)
                observer(.success("\(objectUpdate)"))
            }
        }.eraseToAnyPublisher()
       
    }
 
    
    /*
     MARK: 단어장 삭제 후 반영 함수
     */
    func deletedVocaData(id: UUID) -> AnyPublisher<String, FirstPartyRepoError> {
        return Future<String, FirstPartyRepoError>{observer in
            observer(.success(""))
            
        }.eraseToAnyPublisher()
    }
    
//    //MARK: 단어장 이름 업데이트
//    func updateVocaName(id : UUID, vocaName : String) -> AnyPublisher<String, CoredataRepoError>{
//
//    }
    
    
}
