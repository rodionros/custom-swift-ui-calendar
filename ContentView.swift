import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isCalendarPresented = false
    @State private var currentDate = Date.now
    let buttonHeight: CGFloat = 60
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack {
                        Button(action: {
                            self.isCalendarPresented.toggle()
                        }) {
                            HStack {
                                Text("\(currentDate.formatted(.dateTime.day())) \(currentDate.monthAsString()), \(currentDate.yearAsString())")
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .frame(width: geometry.size.width) // Adjust the width of the button
                        .zIndex(0)
                        .buttonStyle(PlainButtonStyle())
                        
                        if isCalendarPresented {
                            // Show the calendar view above the button
                            CalendarView(currentDate: $currentDate, isPresented: $isCalendarPresented)
                                .frame(width: 300, height: 400) // Customize the size as needed
                                .zIndex(1) // Place the calendar above other views
                        }
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
    }
}
