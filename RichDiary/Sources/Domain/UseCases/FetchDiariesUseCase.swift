import Foundation
import RxSwift

protocol FetchDiariesUseCase {
    func execute(date: Date) -> Observable<[DiaryModel]>
}

final class DefaultFetchDiariesUseCase: FetchDiariesUseCase {
    
    private let repository: DiaryRepository
    
    init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    func execute(date: Date) -> Observable<[DiaryModel]> {
        return repository.fetchDiaries(byMonth: date)
    }
}
