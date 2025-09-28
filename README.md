# 🧄 RichDiary-iOS

**부자가계부**

> 부자를 향한 첫 걸음

[![](https://github.com/user-attachments/assets/b80fcddf-3b00-4f0a-9c4c-4c9daf52b440)](https://apps.apple.com/kr/app/%EB%B6%80%EC%9E%90%EA%B0%80%EA%B3%84%EB%B6%80-rich-diary/id6752819841)

<br>

## 🧑🏻‍💻 Developer
| <img width="200px" height="3400" src="https://avatars.githubusercontent.com/u/63261054?v=4" /> |
| :--------: |
| [김한열](https://github.com/OneTen19) |

<br>

## 🧄 Project 

많은 사람들이 자신의 수입은 정확히 알고 있지만, 본인이 한 달에 얼마를 사용하는지는 비교적 신경쓰지 않습니다. <br>
때문에 어느 것이 자신에게 불필요한 지출인지, 또한 낭비성 지출을 얼마나 하고 있는지 파악하기 쉽지 않습니다. <br>
저축은 불필요한 지출을 줄이는 것에서부터 시작됩니다. <br><br>

▶ 부자가계부는 지출을 3가지로 분류합니다. <br><br>

𝐀 꼭 필요한 것 <br>

꼭 필요한 것은 먹고사는 데 필수적인 것입니다.
예를 들어 교통비나 식대, 아파트 관리비, 세금과 같은 것입니다. <br><br>

𝐁 필요한 것 <br>

필요한 것은 자녀 교육비와 같은 것입니다.
이것들은 반드시는 아니어도 필요한 것들입니다. <br><br>

𝐂 있으면 좋은 것, 그리고 없어도 되는 것 <br>

있으면 좋은 것은 명품이나 잦은 외식 같은 것들이 대표적입니다.말 그대로 있으면 좋은 것들입니다. <br>
없어도 되는 것은 주차 위반 딱지나 과태료, 연체료 등 조금만 신경 쓰면 얼마든지 없앨 수 있는 것입니다. <br>
생돈 날리는 경우라고 할 수 있습니다. <br><br>


## 🛠 Development Environment

![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white)


|  | Purpose |
| --- | --- |
| UIKit | iOS 초기부터 사용되던 프레임워크로, **높은 안정성**을 보장 |
| SnapKit | 오토레이아웃을 간편하게 설정하기 위함 |
| Then | UI 코드를 간편하게 작성하기 위함 |
| RxSwift | 반응형 프로그래밍 |
| Tuist | 프로젝트 관리 및 추후 모듈화 용이성 |
| Realm | 로컬 데이터베이스 |


<br>


## 📌 Convention

[Swift 스타일쉐어 가이드](https://github.com/StyleShare/swift-style-guide)를 기반으로 합니다.

### Commit

```markdown
[Style] : UI 관련
[Feat] : 새로운 기능 구현
[Fix] : 버그, 오류 해결
[Chore] : 코드 수정, 내부 파일 수정, 애매한 것들이나 잡일은 이걸로!
[Add] : 라이브러리 추가, 에셋 추가
[Del] : 쓸모없는 코드 삭제
[Docs] : README나 WIKI 등의 문서 개정
[Refactor] : 전면 수정이 있을 때 사용합니다.
[Setting] : 프로젝트 관련 설정 시에 사용합니다.
[Release] : 릴리즈 관련 수정 시에 사용합니다.
[Merge] : Pull Request Merge
```

예시 [Feat] #1 - 메인 UI 구현
