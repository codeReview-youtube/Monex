//
//  ConvertorMonex.swift
//  ConvertorMonex
//
//  Created by Mustafa Alroomi on 01/03/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      let valuesData = ValuesData(from: "EUR", to: "USD", amount: 99.9, result: 102.71)
      return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), data: valuesData)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      let valuesData = ValuesData(from: "EUR", to: "USD", amount: 99.9, result: 102.71)
        let entry = SimpleEntry(date: Date(), configuration: configuration,data: valuesData)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
      let userDfaults = UserDefaults.init(suiteName: "group.monex")
      let jsonText = userDfaults!.value(forKey: "convertorMonex") as? String
      let jsonData = Data(jsonText?.utf8 ?? "".utf8)
      let valuesData = try! JSONDecoder().decode(ValuesData.self, from: jsonData)
    

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
          let entry = SimpleEntry(date: entryDate, configuration: configuration, data: valuesData)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ValuesData: Codable {
  let from: String
  let to: String
  let amount: Double
  let result: Double
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let data: ValuesData
}

struct ConvertorMonexEntryView : View {
    var entry: Provider.Entry
  
  var redColor = Color(UIColor(displayP3Red: 1, green: 15/255, blue: 83/255, alpha: 1))
  
  @Environment(\.widgetFamily) var family

  var body: some View {
    HStack(spacing: 20) {
      VStack(alignment: .leading) {
        Text(entry.data.from).bold().font(.system(size: 12)).foregroundColor(redColor)
        Text(String(format: "%.2f", entry.data.amount))
          .bold()
          .font(.system(size: 50))
          .foregroundColor(Color.black)
          .shadow(color: .gray, radius: 15, x: 7, y: 7)
          .minimumScaleFactor(0.5)
        Text(entry.data.to).bold().font(.system(size: 12)).foregroundColor(redColor)
        Text(String(format: "%.2f", entry.data.result))
          .bold()
          .font(.system(size: 50))
          .foregroundColor(Color.black)
          .shadow(color: .gray, radius: 15, x: 7, y: 7)
          .minimumScaleFactor(0.5)
      }
      if family == .systemMedium {
        VStack(alignment: .center) {
          Text("Last Updated")
            .bold()
            .font(.system(size: 12))
            .foregroundColor(redColor)
            .shadow(color: .gray, radius: 15, x: 7, y: 7)
            .minimumScaleFactor(0.5)
          Text("Today")
            .bold()
            .font(.system(size: 40))
            .foregroundColor(Color.black)
            .shadow(color: .gray, radius: 15, x: 7, y: 7)
            .minimumScaleFactor(0.5)
        }
      }
    }.padding(.all, 10)
  }
}

struct ConvertorMonex: Widget {
    let kind: String = "ConvertorMonex"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ConvertorMonexEntryView(entry: entry)
        }
        .configurationDisplayName("Convertor Monex")
        .description("Check last conversion currencies!")
    }
}

struct ConvertorMonex_Previews: PreviewProvider {
    static var previews: some View {
      let valuesData = ValuesData(from: "EUR", to: "USD", amount: 99.9, result: 102.71)
      ConvertorMonexEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), data: valuesData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
