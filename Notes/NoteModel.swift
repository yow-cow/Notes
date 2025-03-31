//
//  NoteModel.swift
//  Notes
//
//  Created by Charles Yow on 3/31/25.
//

import Foundation
import FirebaseFirestore


struct NoteModel : Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var notesdata: String
}
