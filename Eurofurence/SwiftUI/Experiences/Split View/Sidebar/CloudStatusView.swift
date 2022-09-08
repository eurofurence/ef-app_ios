import EurofurenceKit
import SwiftUI

private extension EurofurenceModel {
    
    func refresh() {
        Task {
            do {
                try await updateLocalStore()
            } catch {
                
            }
        }
    }
    
}

struct CloudStatusView: View {
    
    @EnvironmentObject private var model: EurofurenceModel
    
    var body: some View {
        switch model.cloudStatus {
        case .idle:
            IdleStatus(model: model)
        
        case .failed:
            FailedStatus(model: model)
        
        case .updated:
            UpdatedStatus(model: model)
        
        case .updating(let progress):
            UpdatingStatus(progress: progress)
        }
    }
    
    private struct IdleStatus: View {
        
        var model: EurofurenceModel
        
        var body: some View {
            Button {
                model.refresh()
            } label: {
                HStack {
                    Image(systemName: "cloud")
                    Text("Pending update")
                }
                .foregroundColor(.gray)
            }
        }
        
    }
    
    private struct FailedStatus: View {
        
        var model: EurofurenceModel
        
        var body: some View {
            Button {
                model.refresh()
            } label: {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Update failed")
                }
                .foregroundColor(.red)
            }
        }
        
    }
    
    private struct UpdatedStatus: View {
        
        var model: EurofurenceModel
        
        var body: some View {
            Button {
                model.refresh()
            } label: {
                HStack {
                    Image(systemName: "cloud")
                    Text("Up to date")
                }
                .foregroundColor(.blue)
            }
        }
        
    }
    
    private struct UpdatingStatus: View {
        
        @ObservedObject var progress: EurofurenceModel.Progress
        
        var body: some View {
            VStack {
                HStack {
                    ProgressView()
                    Text(verbatim: progress.localizedDescription)
                }
                .foregroundColor(.blue)
                
                if let fractionComplete = progress.fractionComplete {
                    ProgressView(value: fractionComplete)
                }
            }
        }
        
    }
    
}

struct CloudStatusView_Previews: PreviewProvider {
    
    static var previews: some View {
        // The canvas can't render all these previews in good time right now. One for the optimisation ticket?
        EurofurenceModel.preview(cloudStatus: .idle) { _ in
            CloudStatusView()
                .previewLayout(.sizeThatFits)
        }

        EurofurenceModel.preview(cloudStatus: .updating(fractionComplete: nil)) { _ in
            CloudStatusView()
                .previewLayout(.sizeThatFits)
        }

//        EurofurenceModel.preview(cloudStatus: .updating(fractionComplete: 0.3)) { _ in
//            CloudStatusView()
//                .previewLayout(.sizeThatFits)
//        }
//
//        EurofurenceModel.preview(cloudStatus: .updating(fractionComplete: 1)) { _ in
//            CloudStatusView()
//                .previewLayout(.sizeThatFits)
//        }
//
//        EurofurenceModel.preview(cloudStatus: .failed) { _ in
//            CloudStatusView()
//                .previewLayout(.sizeThatFits)
//        }

//        EurofurenceModel.preview(cloudStatus: .updated) { _ in
//            CloudStatusView()
//                .previewLayout(.sizeThatFits)
//        }
    }
    
}
