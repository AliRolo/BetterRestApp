//
//  ContentView.swift
//  BestRest
//
//  Created by Alondra Rodríguez on 03/08/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
   /*var calculateBedTime: Date {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            var sleepTime = wakeUp - prediction.actualSleep
            return sleepTime
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
    }*/
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("When do you want to wake up?")
                            .font(.headline)
                        
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:
                                .hourAndMinute)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Daily coffee intake")
                            .font(.headline)
                        //Chalenge 2: Change Stepper for Picker
                        Picker("Number of cups", selection: $coffeeAmount) {
                            ForEach(0 ..< 20) {
                                Text("\($0)")
                            }
                        }
                        //Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    }
                    .pickerStyle(.navigationLink)
                }
                //Challenge 3 Removed the botton and show all the time the recommended bedtime
                Section("Recommended bedtime") {
                                    Text("\(calculateBedTime())")
                                    .font(.title)
                }
            } .navigationTitle("BetterRest")
            // I removed this because the challenge 3
            /*.toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Ok") {}
            } message: {
                Text(alertMessage)
            }*/
        }
    }
    
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            //alertTitle = "Your ideal bedtime is..."
            //alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            let sleepTimeFormatted = sleepTime.formatted(date: .omitted, time: .shortened)
            
            return sleepTimeFormatted
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
            showingAlert = true

        }
        return ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
