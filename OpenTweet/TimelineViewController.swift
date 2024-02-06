//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var timelineViewContainer: UIView!
    weak var timelineTableView: TimelineTableViewController?
    var imageCache = [String : UIImage]()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = theme.background
	}

    func loadJson(fileName: String) -> Timeline? {
      
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        else {
            print("loadJson url nil")
            return nil
        }
        guard let data = try? Data(contentsOf: url)
        else {
            print("loadJson nil data")
            return nil
        }
     
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let timeline = try decoder.decode(Timeline.self, from: data)
            return timeline
            
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("loadJson Key '\(key)' not found:", context.debugDescription)
            print("loadJson codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("loadJson Value '\(value)' not found:", context.debugDescription)
            print("loadJson codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("loadJson Type '\(type)' mismatch:", context.debugDescription)
            print("loadJson codingPath:", context.codingPath)
        } catch {
            print("loadJson error: ", error)
        }
        
        return nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedTimelineTableViewController" {
     
            timelineTableView = segue.destination as? TimelineTableViewController
            
            // Load timeline from json
            let timeline = loadJson(fileName: timelineFileName)
            
            
            // sort timeline incase it didnt start sorted
            if let sorted = timeline?.sort(tweets: timeline?.timeline) {
                timelineTableView?.timeline.timeline = sorted
            }
        }
    }
}

