//
//  CalendarView.swift
//  Calendar
//
//  Created by Родион Ростовщиков on 14.03.2024.
//

import Foundation
import SwiftUI

struct CalendarView: View {
    @Binding var isPresented: Bool
    @State private var currentDate = Date.now
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    
    init(currentDate: Binding<Date>, isPresented: Binding<Bool>) {
        self._currentDate = State(initialValue: Date())
        self._isPresented = isPresented
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("\(currentDate.monthAsString()) \(currentDate.yearAsString())")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            Spacer()
            VStack {
                HStack {
                    ForEach(daysOfWeek.indices, id: \.self) { index in
                        Text(daysOfWeek[index])
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .font(.caption)
                    }
                }
                LazyVGrid(columns: columns) {
                    ForEach(days, id: \.self) { day in
                        if day.monthInt != currentDate.monthInt {
                            Text("")
                        } else {
                            Text(day.formatted(.dateTime.day()))
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .foregroundStyle(
                                            Date.now.startOfDay == day.startOfDay
                                            ? .blue
                                            : .white
                                        )
                                        .frame(width: 30)
                                )
                        }
                    }
                }
            }
            .frame(maxHeight: 300)
        }
        .padding()
        .onAppear {
            days = currentDate.calendarDisplayDays
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    let xOffset = gesture.translation.width
                    if xOffset < -50 { // Swipe left
                        self.currentDate = self.currentDate.nextMonth
                        days = currentDate.calendarDisplayDays
                    } else if xOffset > 50 { // Swipe right
                        self.currentDate = self.currentDate.previousMonth
                        days = currentDate.calendarDisplayDays
                    }
                }
        )
    }
}
