//
//  FIRFirestoreService.swift
//  SampleBasicApp
//
//  Created by Xona on 10/4/18.
//  Copyright © 2018 Xona. All rights reserved.
//
/*
 Comunication with the database: create, read and update data.
 */

import Foundation
import Firebase
import FirebaseAuth
class FIRFirestoreService{
    private init() {}
    static let shared = FIRFirestoreService()
    func configure(){
        FirebaseApp.configure()
    }
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference{
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    //Create a document inside a collection using a specific document identification
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference, to specificDocument:String){
        do{
            let json = try encodableObject.toJson(excluding: ["id"])
            
            reference(to: collectionReference).document(specificDocument).setData(json)
        }catch{
            print(error)
        }
    }
    //Read all the documents from a collection
    func readAll<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void){
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [T]()
                objects.removeAll()
                for document in snapshot.documents{
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                    print("Objekti: \(object)")
                }
                
                completion(objects)
            } catch {
                print(error)
            }
        }
    }
    //Read only a specific document from a collection
    func readDocument<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, specificDocument: String, completion: @escaping (T) -> Void){
        reference(to: collectionReference).document(specificDocument).getDocument { (document, _) in
            guard let document = document else { return }
            do {
                let object: T = try document.decode(as: objectType.self)
                completion(object)
            }catch{
                print(error)
            }
        }
    }
    //Read a specific field under conditions
    func read<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, specificField: String, completion: @escaping ([T]) -> Void){
        reference(to: collectionReference).whereField(specificField, isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do {
                var objects = [T]()
                for document in snapshot.documents{
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                completion(objects)
            }catch{
                print(error)
            }
        }
    }
    //Update a specific document in a collection
    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference, specificDocument: String){
        do{
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let id = encodableObject.id else { throw MyError.encodingError }
            reference(to: collectionReference).document(id).setData(json)
        }
        catch{
            print(error)
        }
    }
}
