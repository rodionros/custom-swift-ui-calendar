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
    @Binding var isDateTimePickerOpened: Bool
    @State private var displayDate = Date()
    @State private var selectedDate = Date()
    @State private var days: [Date] = []
    
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var onPickDate: (Date) -> Void
    
    
    init(isPresented: Binding<Bool>, isDateTimePickerOpened: Binding<Bool>, onPickDate: @escaping (Date) -> Void = { _ in }) {
        self._isPresented = isPresented
        self._isDateTimePickerOpened = isDateTimePickerOpened
        self.onPickDate = onPickDate
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("\(displayDate.monthAsString()) \(displayDate.yearAsString())")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                HStack {
                    Text("\(selectedDate.monthAsString()) \(selectedDate.dayAsString()) \(selectedDate.yearAsString())")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .onTapGesture {
                    isDateTimePickerOpened = !isDateTimePickerOpened
                    days = displayDate.calendarDisplayDays
                }
            }
            Spacer()
            if isDateTimePickerOpened {
                VStack {
                    DatePicker("Select a date and time", selection: $displayDate, displayedComponents: [.date])
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .padding()
                                    .frame(maxWidth: 200, minHeight: 200)
                                    .onChange(of: displayDate) { newDate in
                                            selectedDate = newDate
                                        }
                }
            } else {
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
                            let isCurrentMonth = day.monthInt == displayDate.monthInt
                            let isSelectedDay = day == selectedDate
                            
                            if !isCurrentMonth {
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
                                    .overlay(
                                        isSelectedDay
                                        ? Circle()
                                            .stroke(Color.blue, lineWidth: 1)
                                        : nil
                                        
                                    )
                                    .onTapGesture {
                                        selectedDate = day
                                    }
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
            Divider()
            HStack{
                Text("Pick selected date")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.vertical)
            .onTapGesture {
                onPickDate(selectedDate)
                isDateTimePickerOpened = false
                isPresented = false
            }
            Divider()
            HStack{
                Text("Reset to today")
                Spacer()
                Image(systemName: "calendar")
            }
            .padding(.vertical)
            .onTapGesture {
                onPickDate(Date.now)
                isDateTimePickerOpened = false
                isPresented = false
            }
            
        }
        .padding()
        .onAppear {
            days = displayDate.calendarDisplayDays
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    let xOffset = gesture.translation.width
                    withAnimation(.easeInOut) {
                        if xOffset < -50 {
                            displayDate = displayDate.nextMonth
                            days = displayDate.calendarDisplayDays
                        } else if xOffset > 50 {
                            displayDate = displayDate.previousMonth
                            days = displayDate.calendarDisplayDays
                        }
                    }
                }
        )
    }
}
