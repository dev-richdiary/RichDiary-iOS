import Foundation

final class AppDIContainer {
    static let shared = AppDIContainer()
    
    private init() {}
    
    // MARK: - Core
    
    // func makeDiaryRepository() -> DiaryRepository {
    //     return RealDiaryRepository()
    // }
    
    // MARK: - UseCases
    
    // func makeFetchDiariesUseCase() -> FetchDiariesUseCase {
    //     return DefaultFetchDiariesUseCase(repository: makeDiaryRepository())
    // }
}
