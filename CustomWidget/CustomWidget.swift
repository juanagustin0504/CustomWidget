////
////  CustomWidget.swift
////  CustomWidget
////
////  Created by Webcash on 2020/12/10.
////
//
//import WidgetKit
//import SwiftUI
//
//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date())
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date())
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}
//
//struct Commit {
//    let message: String
//    let author: String
//    let date: String
//}
//
//struct LastCommitEntry: TimelineEntry {
//    public let date: Date
//    public let commit: Commit
//}
//
//struct CommitLoader {
//    static func fetch(completion: @escaping (Result<Commit, Error>) -> Void) {
//        let branchContentsURL = URL(string: "https://github.com/juanagustin0504/CustomWidget.git")
//    }
//}
//
//struct CustomWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}
//
//@main
//struct CustomWidget: Widget {
//    let kind: String = "CustomWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            CustomWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//    }
//}
//
//struct CustomWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomWidgetEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
