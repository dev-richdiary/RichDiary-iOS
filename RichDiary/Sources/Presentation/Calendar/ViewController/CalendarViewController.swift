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

final class CalendarViewController: BaseUIViewController, TabBarResettable {
    
    // MARK: - Properties
    
    private var allDiaries: [DiaryModel] = []
    
    
    // MARK: - UI Components
    
    private let scrollview = UIScrollView()
    private let contentView = UIView()
    private let headerView = CalendarHeaderView()
    private let calendarView = CalendarView()
    private let diaryStackView = UIStackView()
    
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarViewHandlers()
    }
    
    
    //MARK: - Func
    
    override func setUI() {
        self.view.addSubviews(headerView, scrollview)
        scrollview.addSubview(contentView)
        contentView.addSubviews(calendarView, diaryStackView)
    }
    
    override func setStyle() {
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
        updateDiaryTiles(for: calendarView.selectedDate)
    }
}


//MARK: - Private Func

extension CalendarViewController {
    private func setupCalendarViewHandlers() {
        calendarView.onDateSelected = { [weak self] date in
            self?.updateDiaryTiles(for: date)
        }
    }
    
    private func updateDiaryTiles(for date: Date?) {
            // 기존 뷰 제거
            diaryStackView.arrangedSubviews.forEach {
                diaryStackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            guard let selectedDate = date else {
                // 날짜가 선택되지 않았다면 타일을 표시할 필요 없음
                return
            }
            
            let filteredDiaries = self.allDiaries.filter { diary in
                Calendar.current.isDate(diary.date, inSameDayAs: selectedDate)
            }
            
            // ✅ 유효성 검사 추가: 무효화된 객체는 필터링
            // (fetchData()에서 allDiaries를 최신으로 가져오므로 이 시점에는 무효화된 객체가 없어야 하지만, 방어적 코딩)
            let validFilteredDiaries = filteredDiaries.filter { !$0.isInvalidated }
            
            // ✅ forEach 대신 for-in 구문 사용 (타입 추론 에러 방지)
            for model in validFilteredDiaries {
                let tile = DiaryTile()
                tile.configure(with: model) // DiaryTile의 configure는 이제 ID를 저장하고 UI를 업데이트합니다.
                tile.snp.makeConstraints {
                    $0.height.equalTo(72)
                }
                
                // ✅ onTap 클로저 수정: DiaryTile에서 전달된 diaryID를 사용
                tile.onTap = { [weak self] diaryID in // ✅ diaryID를 매개변수로 받음
                    guard let self = self else { return }
                    
                    do {
                        let realm = try Realm()
                        // ✅ DiaryDetailViewController로 넘겨주기 전에 Realm에서 객체를 다시 조회
                        if let liveDiary = realm.object(ofType: DiaryModel.self, forPrimaryKey: diaryID) {
                            let detailVC = DiaryDetailViewController(diaryId: liveDiary.diaryID)
                            detailVC.modalPresentationStyle = .overFullScreen
                            detailVC.modalTransitionStyle = .crossDissolve
                            self.present(detailVC, animated: true)
                        } else {
                            // 해당 ID의 일기가 삭제되었거나 찾을 수 없을 경우
                            print("오류: ID(\(diaryID))를 가진 일기를 찾을 수 없습니다. 이미 삭제되었을 수 있습니다.")
                            let alert = UIAlertController(title: "알림", message: "해당 일기가 삭제되었거나 찾을 수 없습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                                // ✅ 확인 버튼 탭 시 현재 선택된 날짜의 타일을 새로고침
                                self.fetchData() // fetchData가 updateDiaryTiles도 호출하므로 전체 새로고침
                            })
                            self.present(alert, animated: true, completion: nil)
                        }
                    } catch {
                        print("Realm 조회 중 에러 발생: \(error)")
                        let alert = UIAlertController(title: "오류", message: "데이터 로딩 중 문제가 발생했습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                diaryStackView.addArrangedSubview(tile)
            }
        }
        
        // TODO: - 달 단위로 그때 그때 fetch 하는 게 성능상 좋을듯
        private func fetchData() {
            do {
                let realm = try Realm()
                let realmResults = realm.objects(DiaryModel.self)
                // ✅ Realm Live Objects를 배열로 변환하여 저장
                // 이 시점에 allDiaries에는 삭제되지 않은 유효한 객체만 포함됩니다.
                self.allDiaries = Array(realmResults)
                
                // calendarView에 데이터가 변경되었음을 알리고 다시 그리도록 합니다.
                calendarView.reloadData(with: realmResults)
                // 현재 선택된 날짜에 대한 타일도 업데이트합니다.
                updateDiaryTiles(for: calendarView.selectedDate)
            } catch {
                print("Realm 데이터 로딩 중 에러 발생: \(error)")
            }
        }
}
