import SwiftUI

struct AddNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var firestoreManager: FirestoreManager
    
    
    var noteToEdit: Note?
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Note Details")) {
                    TextField("Title", text: $title)
                    TextField("Content", text: $content)
                }
                
                Button(noteToEdit == nil ? "Save" : "Update Note") {
                    if !title.isEmpty {
                        if let existingNote = noteToEdit {
                            firestoreManager.updateNote(note: existingNote, newTitle: title, newContent: content)
                        } else {
                            firestoreManager.addNote(title: title, content: content)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle(noteToEdit == nil ? "Add Note" : "Edit Note")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                
                if let note = noteToEdit {
                    title = note.title
                    content = note.content
                }
            }
        }
    }
}
