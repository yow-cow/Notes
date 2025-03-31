//
//  NoteViewModel.swift
//  Notes
//
//  Created by Charles Yow on 3/31/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class NoteViewModel : ObservableObject {
    
    @Published var notes = [NoteModel]()
    let db = Firestore.firestore()
    
    func fetchData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        notes.removeAll()

        db.collection("users").document(userID).collection("notes")
            .getDocuments { querySnapshot, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            self.notes.append(try document.data(as: NoteModel.self))
                        } catch {
                            print(error)
                        }
                    }
                }
            }
    }

    func saveData(note: NoteModel) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let userNotesRef = db.collection("users").document(userID).collection("notes")
        
        if let id = note.id {
            if !note.title.isEmpty || !note.notesdata.isEmpty {
                userNotesRef.document(id).updateData([
                    "title": note.title,
                    "notesdata": note.notesdata
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
        } else {
            if !note.title.isEmpty || !note.notesdata.isEmpty {
                var ref: DocumentReference? = nil
                ref = userNotesRef.addDocument(data: [
                    "title": note.title,
                    "notesdata": note.notesdata
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            }
        }
    }
}
