//
//  Notes.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 30/03/2021.
//

import SwiftUI
import CoreData


struct NotesMain: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Note.date, ascending: false)])
    var notes : FetchedResults<Note>
    
    @State var showNote = false
    @State var showEdit = false
    
    var body: some View {
        VStack {
            HStack(spacing: 15){
                Text("Notatnik")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(
                    destination: CreateNewNoteView(notes: notes),
                    label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(MainColor)
                            .font(.system(size: 25))
                    })
            }.padding(.top, 90)
            .padding()
            Spacer()
            if isEmpty{
                Text("Nie masz żadnych notatek")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(MainColor)
            }else{
                List{
                    ForEach(notes) { note in
                        NavigationLink(
                            destination: EditNote(note: note, notes: notes),
                            label: {
                                VStack(alignment: .leading){
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text(note.title ?? "Brak tytułu")
                                                .font(.title2)
                                                .bold()
                                                .foregroundColor(MainColor)
                                                .lineLimit(1)
                                            Text(note.main ?? "Brak treści").lineLimit(2)
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                        Text(Formatter.weekDay.string(from: note.date ?? Date()))
                                    }
                                    Divider().foregroundColor(MainColor)
                                }
                            })
                    }.onDelete(perform: deleteNote)
                    .accentColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .listRowInsets(EdgeInsets())
                    .background(Color.white)
                }.padding()
            }
            Spacer()
        }.edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
    private func saveContext(){
        do {
            try viewContext.save()
        }catch{
            let error = error as NSError
            fatalError("Error: \(error)")
        }
    }
    private func deleteNote(offset: IndexSet) {
        withAnimation(){
            offset.map { notes[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func addNote() {
        withAnimation(){
            let newNote = Note(context: viewContext)
            newNote.title = "Nowa notatka"
            newNote.date = Date()
            saveContext()
        }
    }
    var isEmpty: Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            let count  = try viewContext.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
}

//MARK: - NOWA NOTATKA

struct CreateNewNoteView : View {
    
    @State var NoteTitle : String = ""
    @State var NoteMain : String = "Wpisz treść..."
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var notes : FetchedResults<Note>
    
    var body: some View{
        VStack{
            TextField("Wpisz tytuł...", text: $NoteTitle)
                .padding(20)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(MainColor)
            TextEditor(text: self.$NoteMain)
                .foregroundColor(self.NoteMain == "Wpisz treść..." ? .gray : .primary)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                        withAnimation {
                            if self.NoteMain == "Wpisz treść..." {
                                self.NoteMain = ""
                            }
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                        withAnimation {
                            if self.NoteMain == "" {
                                self.NoteMain = "Wpisz treść..."
                            }
                        }
                    }
                }
                .padding()
                .font(.system(size: 20))
                .frame(idealHeight: screenH - 400, maxHeight: .infinity)
                .onTapGesture {
                    hideKeyboard()
                }
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    addNote()
                }, label: {
                    ZStack{
                        MainColor
                            .frame(width: 120, height: 40)
                            .cornerRadius(20)
                        Text("Zapisz")
                            .foregroundColor(.white)
                            .font(.system(size: 21))
                    }
                })
            }.padding()
        }.padding(.top, 90)
        .onTapGesture {
            hideKeyboard()
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
            addNote()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
    private func saveContext(){
        do {
            try viewContext.save()
        }catch{
            let error = error as NSError
            fatalError("Error: \(error)")
        }
    }
    private func deleteNote(offset: IndexSet) {
        withAnimation(){
            offset.map { notes[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    
    private func addNote() {
        withAnimation(){
            let newNote = Note(context: viewContext)
            newNote.title = NoteTitle
            newNote.main = NoteMain
            newNote.date = Date()
            saveContext()
            
        }
    }
}

//MARK: - EDYCJA ISTNIEJĄCEJ NOTATKI

struct EditNote : View {
    @State var note : Note
    
    @State var NoteTitle : String = ""
    @State var NoteMain : String = "Wpisz treść..."
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var notes : FetchedResults<Note>
    
    var body: some View{
        VStack{
            TextField("Wpisz tytuł...", text: $NoteTitle)
                .padding(20)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(MainColor)
            TextEditor(text: self.$NoteMain)
                .foregroundColor(self.NoteMain == "Wpisz treść..." ? .gray : .primary)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                        withAnimation {
                            if self.NoteMain == "Wpisz treść..." {
                                self.NoteMain = ""
                            }
                        }
                    }
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                        withAnimation {
                            if self.NoteMain == "" {
                                self.NoteMain = "Wpisz treść..."
                            }
                        }
                    }
                }
                .padding()
                .font(.system(size: 20))
                .frame(idealHeight: screenH - 400, maxHeight: .infinity)
                .onTapGesture {
                    hideKeyboard()
                }
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    updateNote(note)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    ZStack{
                        MainColor
                            .frame(width: 120, height: 40)
                            .cornerRadius(20)
                        Text("Zapisz")
                            .foregroundColor(.white)
                            .font(.system(size: 21))
                    }
                })
            }.padding()
        }.padding(.top, 90)
        .onAppear(){
            change()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
            updateNote(note)
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
    private func saveContext(){
        do {
            try viewContext.save()
        }catch{
            let error = error as NSError
            fatalError("Error: \(error)")
        }
    }
    private func updateNote(_ note: FetchedResults<Note>.Element) {
        withAnimation(){
            note.main = NoteMain
            note.title = NoteTitle
            note.date = Date()
            saveContext()
        }
    }
    private func change(){
        NoteMain = note.main ?? "error"
        NoteTitle = note.title ?? "error"
    }
    
    private func addNote() {
        withAnimation(){
            let newNote = Note(context: viewContext)
            newNote.title = NoteTitle
            newNote.main = NoteMain
            saveContext()
        }
    }
}

extension Formatter{
    static let weekDay : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: Locale.preferredLanguages.first!)
        formatter.dateStyle = .long
        
        return formatter
    }()
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

