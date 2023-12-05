# Contributor Notes

I've used UIKit with xib and storyboard for this exercise as I wanted to iterate quickly. However, for a production application I recommend to build UI using the code instead.

## Highlights

1. The code has 95% coverage in testing,
2. The code has both unit and UI tests with a total of 13 test cases,
3. The app has been profiled using Instruments,
4. The code doesn't use any third-party frameworks or external dependencies,
5. The code has been generalized/abstracted for future extensibility,
6. The code has been documented wherever needed,
7. The string files have been localized by default to allow multiple languages support in future.

## Architecture

[Clean Swift](https://clean-swift.com/handbook/) is Uncle Bob’s Clean Architecture.

In Clean Swift, the project structure is built around scenes. We have a set of components for each scene that will "work" for our controller. These are the components:
- Models
- Router
- Worker
- Interactor
- Presenter

When a new feature is implemented, these steps are followed:
1. Trigger a use case from a method like viewDidLoad(),
2. The view controller invokes the interactor to perform some business logic,
3. The interactor utilizes the worker to perform core operations,
4. The interactor invokes the presenter to format the result to some primitive types,
5. The presenter invokes the view controller to display the results on the screen.

### Contributor
- [Tushar Agarwal](https://www.linkedin.com/in/tusharagarwal10)

OpenTweet
=========

Hi! Welcome to your iOS coding excercise.

This is a very simple twitter like client. You'll find a json file under Data/ with a short tweet timeline. You are asked to write the app that will display the tweets, similar to what a Twitter client would do.

A tweet has at the minimum:

* An id
* An author
* A content (e.g. the actual tweet)
* A date (text format, in the standard ISO-8601 format)

Additionally, a tweet may have:

* A reference to the tweet ID it's replying to
* A URL to the user's avatar
* A list of image URLs

The timeline is a chronologically ordered (ascending order) list of tweets.

Since the topic is very simple, yet offers so many possibilities at the same time, there is a minimum requirement, and bonuses.

Minimum requirement
-------------------

* Fork the repo
* Parse the json file included in the project
* Display the tweets in the order the json file defines them. The app should display the author, the tweet and the date it was tweeted at. Tweets are variable length, so the cells must be properly sized to the content
* When done, send a pull request to this project

Keep in mind that the repo is public, so forking and sending a pull request will be shown in your public GitHub activity. If that doesn't work out for you for whatever reason, you can simply clone the repo locally, and submit your work back as a zip file to the recruiter.

You may use UIKit or SwiftUI for this exercise. The provided template uses UIKit, but if you would like to use SwiftUI, it may be simpler to create a new xcode project and submit that instead.


Bonuses (in no particular order)
--------------------------------

* Highlight the mentions (@username) and/or links in a different font/color
* Display a tweet's thread when tapping on a giving tweet. Due to the very simplistic data model made available to you, it's probably best to simplify this: if the user taps on the first tweet of a thread, display all the replies in ascending chronological order, if the user taps on a reply to another tweet, only show the tapped tweet and the tweet it's replying to.
* Display avatar images (feel free to use AFNetworking/AlamoFire or just use NSURLSession for that)
* Animate/highlight a tweet when it is selected (e.g. make it "bigger", in an animated fashion)
* Anything else you might think of that showcases a UIKit feature: UIDynamics, parallax effect, the list is endless.

What the assignment will be judged on
-------------------------------------

* Accuracy of the result (e.g. is the cell sizing pixel perfect, dates are properly formatted, the app doesn't crash, project builds and runs with no extra step, etc.)
* Proper usage of UIKit apis (e.g. are cells properly reused, a back button must have a proper title, how well does it scale to various device sizes, etc.)
* Overall code quality: clarity, conciseness, quality of comments. Robustness and maintainability matter a lot more than clever one liners.
* If you end up short on time and/or can't fix a specific bug or finish a given feature, update this readme with what the bug is, and how you think you can fix had you more time.
* Bonuses are exactly that, bonuses. If you can complete one or more, good. Otherwise, don't sweat it
* If you can't complete something, explain why, how you reached that conclusion and potential options to complete it.

What the assignment will NOT be judged on
-----------------------------------------

* Visual design. This is a UI coding excercise, not a visual design excercise. 
* UI performance (e.g. framerate), as long as it's reasonable. Feel free to indicate in the code if/why something would affect the framerate, and a potential solution to it.
* If you try to complete a bonus and can't finish it, that's fine. I'd recommend using git commits/tags to indicate where the bonuses start in the history, so we can easily reset the branch at that commit and validate the minimum requirement.

Happy coding!
