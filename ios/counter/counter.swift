import SwiftUI
import WidgetKit

private let groupID = "group.fluttercounter"

struct CounterWidgetEntry: TimelineEntry {
    let date: Date
}

struct CounterWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CounterWidgetEntry {
        CounterWidgetEntry(date: Date() )
    }

    func getSnapshot(in context: Context, completion: @escaping (CounterWidgetEntry) -> ()) {
        let entry = CounterWidgetEntry(date: Date() )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CounterWidgetEntry>) -> ()) {
        let entry = CounterWidgetEntry(date: Date() )
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}


struct CounterWidgetEntryView: View {
    var entry: CounterWidgetEntry

    var body: some View {
        CounterWidgetView(entry: entry)
    }
}

struct CounterWidgetView: View {
    var entry: CounterWidgetEntry

    var body: some View {
        VStack(spacing: 9) { // Adjust spacing as needed
            HStack(spacing: 9) { // Adjust spacing as needed
                CircleButton(number: 1, entry: entry)
                CircleButton(number: 2, entry: entry)
            }
            HStack(spacing: 9) { // Adjust spacing as needed
                CircleButton(number: 3, entry: entry)
                CircleButton(number: 4, entry: entry)
            }
        }
        .padding()
    }
}

struct CircleButton: View {
    let number: Int
    let entry: CounterWidgetEntry

    var body: some View {
        Button(action: {
                let userDefaults = UserDefaults(suiteName: "group.fluttercounter")
                userDefaults?.set(number, forKey: "selectedNumber")
                userDefaults?.synchronize()
                WidgetCenter.shared.reloadAllTimelines()

        }) {
            Text("\(number) hour")
                .font(.subheadline) // Smaller font
                .foregroundColor(.black) // Text color is black
                .frame(width: 60, height: 60) // Smaller button size
                .background(Circle().fill(Color.white).overlay(Circle().stroke(Color.black, lineWidth: 1)))
                .widgetURL(URL(string: "taskmanager://counterAction?message=\(number)&homeWidget=\(number)"))// White circle with black border
        }
    }
}

struct CounterWidget: Widget {
    private let kind: String = "CounterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CounterWidgetProvider()) { entry in
            CounterWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall]) // Use .systemMedium to get a 4x4 widget layout
        .configurationDisplayName("TaskManager Widget")
        .description("Widget to set timer hours.")
    }
}



