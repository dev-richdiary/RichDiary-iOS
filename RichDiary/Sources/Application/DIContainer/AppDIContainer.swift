import Foundation
import UIKit

final class AppDIContainer {
    static let shared = AppDIContainer()
    
    private init() {}
    
    // MARK: - Core (Repositories)
    
    private func makeDiaryRepository() -> DiaryRepository {
        return DefaultDiaryRepository()
    }
    
    // MARK: - Domain (UseCases)
    
    private func makeFetchDiariesUseCase() -> FetchDiariesUseCase {
        return DefaultFetchDiariesUseCase(repository: makeDiaryRepository())
    }
    
    // MARK: - Presentation (ViewModels & ViewControllers)
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(fetchDiariesUseCase: makeFetchDiariesUseCase())
        return HomeViewController(viewModel: viewModel)
    }
    
    func makeCalendarViewController() -> CalendarViewController {
        let viewModel = CalendarViewModel(fetchDiariesUseCase: makeFetchDiariesUseCase())
        return CalendarViewController(viewModel: viewModel)
    }
    
    func makeAddDiaryViewController() -> AddDiaryViewController {
        return AddDiaryViewController()
    }
}
