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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 모든 다이어리 데이터 배열 초기화
        self.allDiaries = []
        
        // diaryStackView의 모든 서브뷰 제거 및 비우기
        diaryStackView.arrangedSubviews.forEach {
            diaryStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
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
            
            let validFilteredDiaries = filteredDiaries.filter { !$0.isInvalidated }
            
            for model in validFilteredDiaries {
                let tile = DiaryTile()
                
                tile.configure(with: model)
                
                tile.snp.makeConstraints {
                    $0.height.equalTo(72)
                }
                
                tile.onTap = { [weak self] diaryID in
                    guard let self = self else { return }
                    
                    do {
                        let realm = try Realm()
                        if let liveDiary = realm.object(ofType: DiaryModel.self, forPrimaryKey: diaryID) {
                            let detailVC = DiaryDetailViewController(diaryId: liveDiary.diaryID)
                            detailVC.modalPresentationStyle = .overFullScreen
                            detailVC.modalTransitionStyle = .crossDissolve
                            self.present(detailVC, animated: true)
                        } else {
                            print("ID(\(diaryID)) 가계부를 찾을 수 없습니다. 이미 삭제되었을 수 있습니다.")
                            let alert = UIAlertController(title: "알림", message: "해당 가계부가 삭제되었거나 찾을 수 없습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                                self.fetchData()
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
                self.allDiaries = Array(realmResults).sorted(by: { $1.date < $0.date })
                
                calendarView.reloadData(with: realmResults)
                updateDiaryTiles(for: calendarView.selectedDate)
            } catch {
                print("Realm 데이터 로딩 중 에러 발생: \(error)")
            }
        }
}
