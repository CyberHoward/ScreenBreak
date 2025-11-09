//
//  PickupsChartView.swift
//  ReportExtension
//
//  Created by Christian Pichardo on 4/14/23.
//

import SwiftUI
import SwiftUICharts       // willdale
import DeviceActivity

struct PickupsChartView: View {
    let moreInsightsReport: MoreInsightsReport

    // we have 4 different bar charts
    @State private var categoryPickupsData: BarChartData
    @State private var categoryNotifsData: BarChartData
    @State private var appPickupsData: BarChartData
    @State private var appNotifsData: BarChartData

    init(moreInsightsReport: MoreInsightsReport) {
        self.moreInsightsReport = moreInsightsReport

        self._categoryPickupsData = State(initialValue:
            PickupsChartView.makeBarData(
                title: "Pickups",
                subtitle: "Category Pickups",
                tuples: moreInsightsReport.pickupsChartData
            )
        )

        self._categoryNotifsData = State(initialValue:
            PickupsChartView.makeBarData(
                title: "Notifications",
                subtitle: "Category Notifications",
                tuples: moreInsightsReport.notifsChartData
            )
        )

        self._appPickupsData = State(initialValue:
            PickupsChartView.makeBarData(
                title: "Pickups",
                subtitle: "Application Pickups",
                tuples: moreInsightsReport.pickupsAppChartData
            )
        )

        self._appNotifsData = State(initialValue:
            PickupsChartView.makeBarData(
                title: "Notifications",
                subtitle: "Application Notifications",
                tuples: moreInsightsReport.notifsAppChartData
            )
        )
    }

    var body: some View {
        ZStack {
            Color("backgroundColor").edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {

                    // ===== Tab 1: category-level charts =====
                    TabView {
                        VStack {
                            Text("Category Pickups")
                                .customFont(.headline)
                                .underline()

                            BarChart(chartData: categoryPickupsData)
                                .id(categoryPickupsData.id)
                                .touchOverlay(chartData: categoryPickupsData)
                                .xAxisLabels(chartData: categoryPickupsData)
                                .yAxisGrid(chartData: categoryPickupsData)
                                .headerBox(chartData: categoryPickupsData)
                        }

                        VStack {
                            Text("Category Notifications")
                                .customFont(.headline)
                                .underline()

                            BarChart(chartData: categoryNotifsData)
                                .id(categoryNotifsData.id)
                                .touchOverlay(chartData: categoryNotifsData)
                                .xAxisLabels(chartData: categoryNotifsData)
                                .yAxisGrid(chartData: categoryNotifsData)
                                .headerBox(chartData: categoryNotifsData)
                        }
                    }
                    .frame(height: 320)
                    .padding(.bottom)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))

                    // ===== Tab 2: app-level charts =====
                    TabView {
                        VStack {
                            Text("Application Pickups")
                                .customFont(.headline)
                                .underline()

                            BarChart(chartData: appPickupsData)
                                .id(appPickupsData.id)
                                .touchOverlay(chartData: appPickupsData)
                                .xAxisLabels(chartData: appPickupsData)
                                .yAxisGrid(chartData: appPickupsData)
                                .headerBox(chartData: appPickupsData)
                        }

                        VStack {
                            Text("Application Notifications")
                                .customFont(.headline)
                                .underline()

                            BarChart(chartData: appNotifsData)
                                .id(appNotifsData.id)
                                .touchOverlay(chartData: appNotifsData)
                                .xAxisLabels(chartData: appNotifsData)
                                .yAxisGrid(chartData: appNotifsData)
                                .headerBox(chartData: appNotifsData)
                        }
                    }
                    .frame(height: 320)
                    .padding(.bottom)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))

                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 3)

                    Text("First Pickup: \n\(moreInsightsReport.firstPickup)")
                        .customFont(.title3)

                    Text("Mindless Device Pickups: \n\(moreInsightsReport.totalPickupsWithoutApplicationActivity)")
                        .customFont(.title3)

                    Spacer().frame(height: 80)
                }
                .padding(5)
                .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Helper
extension PickupsChartView {
    static func makeBarData(
        title: String,
        subtitle: String,
        tuples: [(String, Double)]
    ) -> BarChartData {

        let points = tuples.map { (label, value) in
            BarChartDataPoint(
                value: value,
                xAxisLabel: label,
                description: label
            )
        }

        let dataSet = BarDataSet(dataPoints: points, legendTitle: "")
        let metadata = ChartMetadata(title: title, subtitle: subtitle)

        let style = BarChartStyle(
            infoBoxPlacement: .infoBox(isStatic: false),
            xAxisLabelPosition: .bottom,
            yAxisLabelPosition: .leading
        )

        return BarChartData(
            dataSets: dataSet,
            metadata: metadata,
            chartStyle: style
        )
    }
}
