//
//  AppDelegate.swift
//  PrintDaemon
//
//  Created by Andrew Charkin on 4/9/15.
//  Copyright (c) 2015 Charimon. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var statusMenu: NSMenu!

  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
  let port = 8080
  let printerName = "Matte_Daemon"
  let ppdFile = "/tmp/MatteDaemon.ppd"
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let icon = NSImage(named: "star")
    icon?.setTemplate(true)
    self.statusItem.image = icon
    self.statusItem.menu = statusMenu
    
    _addPrinter()
    startServer()
  }

  @IBAction func addPrinter(sender: NSMenuItem) { _addPrinter() }
  
  private func _addPrinter(){
    if let ppdURL = NSBundle.mainBundle().URLForResource("MatteDaemon", withExtension: "ppd"){
      let printerPPD = NSData(contentsOfURL: ppdURL)
      printerPPD?.writeToFile(ppdFile, atomically: true)
      
      let task = NSTask()
      task.launchPath = "/usr/sbin/lpadmin"
      
      task.arguments = ["-p", printerName, "-E", "-v", "http://localhost:\(self.port)/ipp", "-P", ppdFile]
      task.launch()
      task.waitUntilExit()
    } else {
      println("failed to get ppd")
    }
  }
  
  let responseObj = [
    "request-id":"50",
    "version-number":"2.0",
    "status-code":"successful-ok",
    "referenced-uri-scheme-supported":"file, http, https, ipp",
    "job-uri":"/ipp/print",
    "job-id":"1",
    "job-state":"9",
    "job-state-reasons":"9",
  ]
  
  func startServer(){
    let server = HttpServer()
    server["/ipp"] = { request in
      
      println("body \(request.headers)")
      println("body \(request.body)")
      
      let body = request.body
      
      if let str = body {
        //        let newString = str.substringToIndex(advance(str.startIndex, count(str)))
        println("HERE: \(str)")
      }
      
      switch request.method.uppercaseString {
      case "POST":
        let data = "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        //          return HttpResponse.RAW(100, data!)
        
        return .OK(.JSON(self.responseObj))
      case "GET":
        return .OK(.JSON(self.responseObj))
      default:
        return .NotFound
      }
      
      
      
    }
    server.start(listenPort: 8080)
  }

}

