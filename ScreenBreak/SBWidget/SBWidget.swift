//
//  SBWidget.swift
//  SBWidget
//
//  Created by Christian Pichardo on 4/11/23.
//

import WidgetKit
import SwiftUI
import DeviceActivity


struct ScreenTimeEntry: TimelineEntry {
    let date = Date()
    let endTime: String
    let inRestrictionMode: Bool
}

func formatTime(hours: Int, minutes: Int) -> String {
    var h = "\(hours)"
    var m = "\(minutes)"
    var pm = false
    if(hours % 12 > 0){
        h = "\(hours % 12)"
        pm = true
    }
    if(hours == 12){
        pm = true
    }
    if(minutes < 10){
        m = "0\(minutes)"
    }
    
    if(pm) {
        return "\(h):\(m) PM"
    } else {
        return "\(h):\(m) AM"
    }
}

struct Provider: TimelineProvider {
    private let userDefaults = UserDefaults(suiteName: "group.ChristianPichardo.ScreenBreak")
    
    var endHour: Int {
        userDefaults?.integer(forKey: "widgetEndHour") ?? 12
    }
    var endMins: Int {
        userDefaults?.integer(forKey: "widgetEndMins") ?? 0
    }
    var inRestrictionMode: Bool {
        userDefaults?.bool(forKey: "widgetInRestrictionMode") ?? false
    }
    
    func placeholder(in context: Context) -> ScreenTimeEntry {
        ScreenTimeEntry(endTime: formatTime(hours: 12, minutes: 30), inRestrictionMode: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (ScreenTimeEntry) -> ()) {
        let entry = ScreenTimeEntry(endTime: formatTime(hours: endHour, minutes: endMins), inRestrictionMode: inRestrictionMode)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = ScreenTimeEntry(endTime: formatTime(hours: endHour, minutes: endMins), inRestrictionMode: inRestrictionMode)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SBWidgetEntryView : View {
    var entry: ScreenTimeEntry

    var body: some View {
        ZStack{
            
            ContainerRelativeShape().fill(Color("backgroundColor").gradient.opacity(0.9))
            if entry.inRestrictionMode{
                VStack{
                    HStack{
                        Spacer()
                        Image(systemName: "lock.fill")
                        Text("Restriction Mode")
                            .customFont(.caption)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Spacer()
                    }
                    Spacer().frame(height:10)
                    Text("Ends At")
                        .customFont(.headline)
                        .multilineTextAlignment(.center)
                    
                    
                    Text(entry.endTime)
                        .customFont(.title)
                        .multilineTextAlignment(.center)
                        .bold(true)
                        
                }
            }else{
                VStack{
                    Image(systemName: "lock.open.fill")
                        .imageScale(.large)
                    Text("Congrats! You are not in restriction mode.")
                        .customFont(.headline)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("borderColor"), lineWidth: 5)
        )
        
    }
}


struct SBWidget: Widget {
    let kind: String = "SBWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SBWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color("backgroundColor")
                }
        }
        .configurationDisplayName("ScreenBreak Widget")
        .description("This widget will show you when your restriction time will be over.")
        .supportedFamilies([.systemSmall])
    }
}


struct SBWidget_Previews: PreviewProvider {
    static var previews: some View {
        SBWidgetEntryView(entry:  ScreenTimeEntry(endTime:formatTime(hours:12, minutes:30), inRestrictionMode: true))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
 
