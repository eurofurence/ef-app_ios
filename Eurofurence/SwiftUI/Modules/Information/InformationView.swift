import EurofurenceKit
import SwiftUI

struct InformationView: View {
    
    @FetchRequest(
        entity: KnowledgeGroup.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \KnowledgeGroup.order, ascending: true)]
    )
    private var groups: FetchedResults<KnowledgeGroup>
    
    var body: some View {
        List {
            ForEach(groups) { group in
                NavigationLink {
                    if let first = group.entries.first, group.entries.count == 1 {
                        KnowledgeEntryView(knowledgeEntry: first)
                    } else {
                        KnowledgeGroupView(knowledgeGroup: group)
                    }
                } label: {
                    HStack(spacing: 18) {
                        FontAwesomeText(unicodeCharacterAddress: group.fontAwesomeUnicodeCharacterAddress, size: 34)
                            .frame(width: 48)
                        
                        VStack(alignment: .leading) {
                            Text(group.name)
                                .font(.headline)
                            
                            Text(group.knowledgeGroupDescription)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Information")
    }
    
}

private struct KnowledgeGroupView: View {
    
    @FetchRequest(
        entity: KnowledgeEntry.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \KnowledgeEntry.order, ascending: true)
        ]
    )
    private var knowledgeEntries: FetchedResults<KnowledgeEntry>
    
    @ObservedObject var knowledgeGroup: KnowledgeGroup
    
    var body: some View {
        List {
            ForEach(knowledgeEntries) { entry in
                NavigationLink {
                    KnowledgeEntryView(knowledgeEntry: entry)
                } label: {
                    Text(entry.title)
                }
            }
        }
        .onAppear {
            updateFetchRequest()
        }
        .onChange(of: knowledgeGroup) { _ in
            updateFetchRequest()
        }
        .navigationTitle(knowledgeGroup.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func updateFetchRequest() {
        knowledgeEntries.nsPredicate = KnowledgeEntry.predicateForEntries(in: knowledgeGroup)
    }
    
}

private struct KnowledgeEntryView: View {
    
    @FetchRequest(
        entity: KnowledgeEntryImage.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \KnowledgeEntryImage.internalReference, ascending: true)]
    )
    private var images: FetchedResults<KnowledgeEntryImage>
    
    @FetchRequest(
        entity: KnowledgeLink.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \KnowledgeLink.name, ascending: true)]
    )
    private var links: FetchedResults<KnowledgeLink>
    
    @ObservedObject var knowledgeEntry: KnowledgeEntry
    @State private var containerWidth: CGFloat = 0
    
    init(knowledgeEntry: KnowledgeEntry) {
        self.knowledgeEntry = knowledgeEntry
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(images) { image in
                    EurofurenceKitImage(image: image)
                }
                
                let markdown = LocalizedStringKey(knowledgeEntry.text)
                Text(markdown)
                
                ForEach(links) { link in
                    Divider()
                    LinkButton(link: link)
                }
            }
            .padding()
        }
        .onAppear {
            images.nsPredicate = KnowledgeEntryImage.predicateForImages(in: knowledgeEntry)
            links.nsPredicate = NSPredicate(format: "entry == %@", knowledgeEntry)
        }
        .navigationTitle(knowledgeEntry.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct InformationView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                InformationView()
            }
        }
    }
    
}
