import UIKit

/// Creates an instance of `TweetsListViewController` and does the required setup
extension TweetsList {
    static func scene(withType viewType: ViewType) -> TweetsListViewController {
        let viewController = StoryboardType.timeline.instance.instantiateController(withType: TweetsListViewController.self)
        
        var presenter = TweetsListPresenter()
        presenter.viewController = viewController
        
        let interactor = TweetsListInteractor(viewType: viewType)
        interactor.presenter = presenter
        interactor.tweetsWorker = TweetsWorker(localTweetsProvider: LocalTweetsProvider(localFileTweetsProvider: LocalFileTweetsProvider()))
        
        var router = TweetsListRouter()
        router.viewController = viewController
        router.dataStore = interactor
        
        viewController.interactor = interactor
        viewController.router = router
        
        return viewController
    }
}
