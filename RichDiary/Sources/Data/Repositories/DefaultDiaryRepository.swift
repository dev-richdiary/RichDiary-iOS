import Foundation
import RealmSwift
import RxSwift

final class DefaultDiaryRepository: DiaryRepository {
    
    func fetchDiaries() -> Observable<[DiaryModel]> {
        return Observable.create { observer in
            do {
                let realm = try Realm()
                let results = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
                
                let token = results.observe { changes in
                    switch changes {
                    case .initial(let data), .update(let data, _, _, _):
                        observer.onNext(Array(data))
                    case .error(let error):
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    token.invalidate()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
    
    func fetchDiaries(byMonth date: Date) -> Observable<[DiaryModel]> {
        return fetchDiaries().map { diaries in
            diaries.filter { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
        }
    }
    
    func deleteDiary(id: String) -> Single<Void> {
        return Single.create { single in
            do {
                let realm = try Realm()
                if let objectId = try? ObjectId(string: id),
                   let object = realm.object(ofType: DiaryModel.self, forPrimaryKey: objectId) {
                    try realm.write {
                        realm.delete(object)
                    }
                }
                single(.success(()))
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
