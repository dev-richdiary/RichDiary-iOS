//
//  CalendarViewController.swift
//  RichDiary-iOS
//
//  Created by OneTen on 9/5/25.
//

import UIKit

import SnapKit
import Then

import RealmSwift
import RxSwift
import RxCocoa

final class CalendarViewController: BaseUIViewController, TabBarResettable {
    
    // MARK: - Properties
    
    private let allDiariesRelay = BehaviorRelay<[DiaryModel]>(value: [])
    private let disposeBag = DisposeBag()
    
    private var notificationToken: RealmSwift.NotificationToken?
    
    
    // MARK: - UI Components
    
    private let scrollview = UIScrollView()
    private let contentView = UIView()
    private let headerView = CalendarHeaderView()
    private let calendarView = CalendarView()
    private let diaryStackView = UIStackView()
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setRealmNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
        setCalendarViewHandlers()
    }
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(calendarView, diaryStackView)
    }
    
    override func setStyle() {
        headerView.do {
            $0.helpButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    let helpVC = HelpViewController()
                    helpVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(helpVC, animated: true)
                })
                .disposed(by: disposeBag)
            
            /*
             $0.noticeButton.rx.tap
             .subscribe(onNext: { [weak self] in
             let noticeVC = NoticeViewController()
             noticeVC.hidesBottomBarWhenPushed = true
             self?.navigationController?.pushViewController(noticeVC, animated: true)
             })
             .disposed(by: disposeBag)
             */
        }
        
        scrollview.do {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 40
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
        
        diaryStackView.do {
            $0.axis = .vertical
            $0.spacing = 0
            $0.distribution = .fill
        }
    }
    
    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        scrollview.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(25)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        diaryStackView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func resetToInitialState() {
        scrollview.setContentOffset(.zero, animated: true)
        
        calendarView.resetToToday()
        loadAndRefreshDiaries()
    }
}


//MARK: - Private Func

extension CalendarViewController {
    private func presentAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        self.present(alert, animated: true)
    }
    
    private func navigateToDiaryDetail(diaryID: ObjectId) {
        do {
            let realm = try Realm()
            if let currentDiary = realm.object(ofType: DiaryModel.self, forPrimaryKey: diaryID) {
                let detailVC = DiaryDetailViewController(diaryId: currentDiary.diaryID)
                detailVC.modalPresentationStyle = .overFullScreen
                detailVC.modalTransitionStyle = .crossDissolve
                self.present(detailVC, animated: true)
            } else {
                print("오류: ID(\(diaryID))를 가진 가계부를 찾을 수 없습니다. 이미 삭제되었을 수 있습니다.")
                presentAlert(title: "알림", message: "해당 가계부가 삭제되었거나 찾을 수 없습니다.") { [weak self] in
                    self?.loadAndRefreshDiaries()
                }
            }
        } catch {
            print("Realm 조회 중 에러 발생: \(error)")
            presentAlert(title: "오류", message: "데이터 로딩 중 문제가 발생했습니다.")
        }
    }
    
    private func setCalendarViewHandlers() {
        calendarView.onDateSelected = { [weak self] date in
            // calendarView의 selectedDate가 변경되면 allDiariesRelay의 최신 값을 가져와 updateDiaryTiles 호출
            if let currentDiaries = self?.allDiariesRelay.value {
                self?.updateDiaryTiles(for: date, allDiaries: currentDiaries)
            }
        }
    }
    
    private func updateDiaryTiles(for date: Date?, allDiaries: [DiaryModel]) {
        // 기존 뷰 제거
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        guard let selectedDate = date else {
            return
        }
        
        let filteredDiaries = allDiaries.filter { diary in
            Calendar.current.isDate(diary.date, inSameDayAs: selectedDate)
        }
        
        // 필터링된 유효한 다이어리들로 타일 생성
        for model in filteredDiaries {
            let tile = DiaryTile()
            tile.configure(with: model)
            
            tile.snp.makeConstraints {
                $0.height.equalTo(72)
            }
            
            tile.onTap = { [weak self] diaryID in
                self?.navigateToDiaryDetail(diaryID: diaryID)
            }
            
            diaryStackView.addArrangedSubview(tile)
        }
    }
    
    private func loadAndRefreshDiaries() {
        do {
            let realm = try Realm()
            let allDiaries = Array(realm.objects(DiaryModel.self)).filter { !$0.isInvalidated }
            self.allDiariesRelay.accept(allDiaries.sorted(by: { $1.date < $0.date })) // 최신순 정렬
        } catch {
            print("Realm 데이터 로딩 중 에러 발생: \(error)")
            self.allDiariesRelay.accept([]) // 에러 발생 시 빈 배열로 업데이트
        }
    }
    
    private func setRealmNotification() {
        notificationToken?.invalidate()
        notificationToken = nil
        
        do {
            let realm = try Realm()
            let realmResults = realm.objects(DiaryModel.self).sorted(byKeyPath: "date", ascending: false)
            
            notificationToken = realmResults.observe { [weak self] (changes: RealmCollectionChange) in
                guard let self = self else { return }
                
                var currentValidDiaries: [DiaryModel] = []
                
                switch changes {
                case .initial(let results):
                    currentValidDiaries = Array(results).filter { !$0.isInvalidated }
                case .update(let results, _, _, _):
                    currentValidDiaries = Array(results).filter { !$0.isInvalidated }
                case .error(let error):
                    print("Realm Notification Error: \(error)")
                    currentValidDiaries = []
                }
                
                self.allDiariesRelay.accept(currentValidDiaries)
            }
        } catch {
            print("Realm Notification 초기화 중 에러 발생: \(error)")
            self.allDiariesRelay.accept([])
        }
    }
    
    private func setBinding() {
        allDiariesRelay
            .subscribe(onNext: { [weak self] diaries in
                guard let self = self else { return }
                self.calendarView.reloadData(with: diaries)
                self.updateDiaryTiles(for: self.calendarView.selectedDate, allDiaries: diaries)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func handleDiarySavedOrDeletedNotification() {
        print("CalendarViewController: 일기 저장/삭제 알림 받음. 데이터 갱신 시작.")
        loadAndRefreshDiaries()
    }
}
