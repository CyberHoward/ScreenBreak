//
//  HomeReportView.swift
//  ReportExtension
//

import SwiftUI
import SwiftUICharts        // <- willdale/SwiftUICharts
import DeviceActivity
import Charts               // you can keep this if other code needs it

struct HomeReportView: View {

    let homeReport: ChartAndTopThreeReport
    private let fixedColumns =  [GridItem(.fixed(80)), GridItem(.fixed(80)), GridItem(.fixed(80))]

    // willdale’s charts use data objects, so we build them in init
    @State private var categoryBarData: BarChartData
    @State private var appBarData: BarChartData

    init(homeReport: ChartAndTopThreeReport) {
        self.homeReport = homeReport

        self._categoryBarData = State(initialValue:
            HomeReportView.makeBarData(
                title: "Category Minutes",
                subtitle: "Categories",
                tuples: homeReport.categoryChartData
            )
        )

        self._appBarData = State(initialValue:
            HomeReportView.makeBarData(
                title: "App Minutes",
                subtitle: "App Time",
                tuples: homeReport.appChartData
            )
        )
    }

    var body: some View {
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack {
                card

                Spacer(minLength: 20)
                Text("Screen Time Today").customFont(.title2)
                Text("\(homeReport.totalDuration.formatedDuration())")
                    .customFont(.headline)

                Rectangle()
                    .fill(Color("border"))
                    .frame(width: 200, height: 3)

                // replace old TabView of BarChartView(...) with the new charts
                TabView {
                    BarChart(chartData: categoryBarData)
                        .id(categoryBarData.id)               // recommended by lib
                        .touchOverlay(chartData: categoryBarData)
                        .xAxisLabels(chartData: categoryBarData)
                        .yAxisGrid(chartData: categoryBarData)
                        .headerBox(chartData: categoryBarData)

                    BarChart(chartData: appBarData)
                        .id(appBarData.id)
                        .touchOverlay(chartData: appBarData)
                        .xAxisLabels(chartData: appBarData)
                        .yAxisGrid(chartData: appBarData)
                        .headerBox(chartData: appBarData)
                }
                .frame(height: 320)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
        }
    }

    var card: some View {
        VStack(alignment: .center) {
            Text("Top Apps")
                .customFont(.title2)

            Rectangle()
                .fill(Color("border"))
                .frame(width: 150, height: 3)

            LazyVGrid(columns: fixedColumns, spacing: 2) {
                ForEach(homeReport.topApps) { app in
                    CardView(app: app, disablePopover: true)
                }
            }
        }
        .padding()
    }
}

// MARK: - Helpers

extension HomeReportView {
    /// turns [(label, value)] into a willdale BarChartData
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

        // You can customise style more if you want
        let style = BarChartStyle(infoBoxPlacement: .infoBox(isStatic: false),
                                  xAxisLabelPosition: .bottom,
                                  yAxisLabelPosition: .leading)

        return BarChartData(
            dataSets: dataSet,
            metadata: metadata,
            chartStyle: style
        )
    }
}
