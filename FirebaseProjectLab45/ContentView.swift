import SwiftUI

struct ContentView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var showingSheet = false
    @State private var selectedNote: Note?
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(firestoreManager.notes) { note in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(note.title).font(.headline)
                                Text(note.content).font(.subheadline)
                            }
                            Spacer()
                            Button("Delete") {
                                firestoreManager.deleteNote(note: note)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.red)
                        }
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                selectedNote = note
                                showingSheet = true
                            }
                            .tint(.blue)
                        }
                    }
                }
                .navigationTitle("Notes")
                .navigationBarItems(trailing: Button(action: {
                    selectedNote = nil 
                    showingSheet = true
                }) {
                    Image(systemName: "plus")
                })
                .onAppear {
                    firestoreManager.getNotes()
                }
                .sheet(isPresented: $showingSheet) {
                    AddNoteView(firestoreManager: firestoreManager, noteToEdit: selectedNote)
                }

                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
