import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var userId: String
}

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    @Published var notes = [Note]()
    
    private var currentUserID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    func addNote(title: String, content: String) {
        guard let uid = currentUserID else { return }
        let newNote = Note(title: title, content: content, userId: uid)
        
        do {
            _ = try db.collection("notes").addDocument(from: newNote)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
 
    func updateNote(note: Note, newTitle: String, newContent: String) {
        guard let noteID = note.id else { return }
        
        db.collection("notes").document(noteID).updateData([
            "title": newTitle,
            "content": newContent
        ]) { error in
            if let error = error {
                print("Error updating note: \(error.localizedDescription)")
            }
        }
    }
    
    func getNotes() {
        guard let uid = currentUserID else { return }
        
        db.collection("notes")
            .whereField("userId", isEqualTo: uid)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error getting notes: \(error)")
                    return
                }
                
                self.notes = snapshot?.documents.compactMap { document in
                    try? document.data(as: Note.self)
                } ?? []
            }
    }
    
    func deleteNote(note: Note) {
        guard let noteID = note.id else { return }
        db.collection("notes").document(noteID).delete()
    }
}
