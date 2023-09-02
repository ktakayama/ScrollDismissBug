//
//  ContentView.swift
//  ScrollDismissBug
//
//  Created by Kyosuke Takayama on 2023/07/11.
//

import SwiftUI
import EventKit
import EventKitUI

var globalEvent: EKEvent? = nil

struct ContentView: View {
    @State private var isShowingNormalController = false
    @State private var isShowingEventController = false
    let eventStore = EKEventStore()

    var body: some View {
        VStack {
            Spacer()

            Button(action: {
                self.isShowingNormalController = true
            }) {
                Text("NormalViewControllerWrapper")
            }
            .sheet(isPresented: $isShowingNormalController, content: {
                NormalViewControllerWrapper()
            })

            Spacer()

            Button(action: {
                requestAccessToCalendar {
                    prepareEvent { event in
                        globalEvent = event
                        self.isShowingEventController = true
                    }
                }
            }) {
                Text("EventViewControllerWrapper")
            }
            .sheet(isPresented: $isShowingEventController, content: {
                EventViewControllerWrapper(event: globalEvent)
            })

            Spacer()

        }
        .padding()
    }

    private func requestAccessToCalendar(completion: @escaping () -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        completion()
                    }
                } else if let error = error {
                    print("Failed to request access: \(error)")
                }
            }
        } else {
            eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        completion()
                    }
                } else if let error = error {
                    print("Failed to request access: \(error)")
                }
            }
        }
    }

    private func prepareEvent(completion: @escaping (EKEvent?) -> Void) {
        let predicate = eventStore.predicateForEvents(withStart: Date().addingTimeInterval(-3600*24*30),
                                                      end: Date().addingTimeInterval(3600*24*30),
                                                      calendars: [])
        let events = eventStore.events(matching: predicate)
        let event = events.filter({ $0.title == "Sample" }).first

        if(event == nil) {
            let e = EKEvent(eventStore: eventStore)
            e.title = "Sample"
            DispatchQueue.main.async {
                completion(e)
            }
        } else {
            DispatchQueue.main.async {
                completion(event)
            }
        }
    }
}

struct NormalViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = UIViewController()
        viewController.title = "NormalViewControllerWrapper"
        let scrollView = UIScrollView(frame: CGRectMake(0,80,viewController.view.frame.size.width,500))
        scrollView.backgroundColor = UIColor.systemBlue
        scrollView.contentSize = CGSizeMake(300, 1000)
        let contents = UIView(frame: CGRectMake(20,20,150,150))
        contents.backgroundColor = UIColor.systemCyan
        scrollView.addSubview(contents)
        viewController.view .addSubview(scrollView)
        return UINavigationController(rootViewController: viewController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
    }
}

struct EventViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    var event: EKEvent?

    func makeUIViewController(context: Context) -> UINavigationController {
        let eventController = EKEventViewController()
        eventController.event = event
        eventController.delegate = context.coordinator
        return UINavigationController(rootViewController: eventController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, EKEventViewDelegate {
        func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
            controller.dismiss(animated: true)
        }
    }
}
