import Foundation
import RxSwift

protocol DiaryRepository {
    func fetchDiaries() -> Observable<[DiaryModel]>
    func fetchDiaries(byMonth date: Date) -> Observable<[DiaryModel]>
    func deleteDiary(id: String) -> Single<Void>
}
