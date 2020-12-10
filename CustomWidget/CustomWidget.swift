//
//  CustomWidget.swift
//  CustomWidget
//
//  Created by Webcash on 2020/12/10.
//

import WidgetKit
import SwiftUI

struct Commit {
    let message: String
    let author: String
    let date: String
}

struct LastCommitEntry: TimelineEntry {
    public let date: Date
    public let commit: Commit
    
    var relevance: TimelineEntryRelevance? {
        return TimelineEntryRelevance(score: 10) // 0 - not important | 100 - very important
    }
}

struct CommitLoader {
    static func fetch(completion: @escaping (Result<Commit, Error>) -> Void) {
        let branchContentsURL = URL(string: "https://api.github.com/repos/juanagustin0504/CustomWidget/branches/main")!
        URLSession.shared.dataTask(with: branchContentsURL) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let commit = getCommitInfo(fromData: data!)
            completion(.success(commit))
        }.resume()
    }
    
    static func getCommitInfo(fromData data: Foundation.Data) -> Commit {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let commitParentJson = json["commit"] as! [String: Any]
        let commitJson = commitParentJson["commit"] as! [String: Any]
        let authorJson = commitJson["author"] as! [String: Any]
        let message = commitJson["message"] as! String
        let author = authorJson["name"] as! String
        let date = authorJson["date"] as! String
        return Commit(message: message, author: author, date: date)
    }
}

struct CommitTimeline: TimelineProvider {
    typealias Entry = LastCommitEntry
    
    func placeholder(in context: Context) -> LastCommitEntry {
        LastCommitEntry(date: Date(), commit: Commit(message: "Loading...", author: "", date: ""))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<LastCommitEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        CommitLoader.fetch { result in
            let commit: Commit
            if case .success(let fetchedCommit) = result {
                commit = fetchedCommit
            } else {
                commit = Commit(message: "Failed to load commits", author: "", date: "")
            }
            let entry = LastCommitEntry(date: currentDate, commit: commit)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LastCommitEntry) -> Void) {
        let fakeCommit = Commit(message: "- First Commit", author: "moon-john", date: "2020-12-10")
        let entry = LastCommitEntry(date: Date(), commit: fakeCommit)
        completion(entry)
    }
}

struct CommitCheckerWidgetView : View {
    let entry: LastCommitEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("moon-john/WidgetSample's Latest Commit")
                .font(.system(.title3))
                .foregroundColor(.black)
            Text(entry.commit.message)
                .font(.system(.callout))
                .foregroundColor(.black)
                .bold()
            Text("by \(entry.commit.author) at \(entry.commit.date)")
                .font(.system(.caption))
                .foregroundColor(.black)
            Text("Updated at \(Self.format(date:entry.date))")
                .font(.system(.caption2))
                .foregroundColor(.black)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom))
    }
    
    static func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string(from: date)
    }
}

@main
struct CustomWidget: Widget {
    let kind: String = "CustomWidget"

    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: CommitTimeline()) { entry in
            CommitCheckerWidgetView(entry: entry)
        }
        .configurationDisplayName("Custom Widget")
        .description("Custom Widget for Last Commit.")
    }
}

struct CustomWidget_Previews: PreviewProvider {
    static var previews: some View {
        CommitCheckerWidgetView(entry: LastCommitEntry(date: Date(), commit: Commit(message: "previews", author: "tester", date: "2020-12-10")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
//
