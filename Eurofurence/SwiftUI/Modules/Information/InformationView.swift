import EurofurenceKit
import SwiftUI

struct InformationView: View {
    
    @FetchRequest(fetchRequest: KnowledgeGroup.orderedGroupsFetchRequest())
    private var groups: FetchedResults<KnowledgeGroup>
    
    var body: some View {
        List {
            ForEach(groups) { group in
                NavigationLink {
                    if let first = group.orderedKnowledgeEntries.first, group.orderedKnowledgeEntries.count == 1 {
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
    
    @ObservedObject var knowledgeGroup: KnowledgeGroup
    
    var body: some View {
        List {
            ForEach(knowledgeGroup.orderedKnowledgeEntries) { entry in
                NavigationLink {
                    KnowledgeEntryView(knowledgeEntry: entry)
                } label: {
                    Text(entry.title)
                }
            }
        }
        .navigationTitle(knowledgeGroup.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

private struct KnowledgeEntryView: View {
    
    @ObservedObject var knowledgeEntry: KnowledgeEntry
    
    init(knowledgeEntry: KnowledgeEntry) {
        self.knowledgeEntry = knowledgeEntry
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(knowledgeEntry.orderedImages) { image in
                    EurofurenceKitImage(image: image)
                }
                
                let markdown = LocalizedStringKey(knowledgeEntry.text)
                Text(markdown)
                
                ForEach(knowledgeEntry.orderedLinks) { link in
                    Divider()
                    LinkButton(link: link)
                }
            }
            .padding()
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
