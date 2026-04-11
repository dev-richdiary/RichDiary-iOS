# Engineering Test Standards (Testing-as-Documentation)

## Principles
- **Documentation Role**: Tests must read like a technical specification. Folder and file names should map to business domains.
- **Modern Stack**: Strictly use **Swift Testing** (`@Suite`, `@Test`, `#expect`) for all new tests.
- **Zero App Mutation**: Testing must NEVER require changes to existing application code. Use `Extension` or `Mocking` only within the test target.

## Analytical Techniques
- **Boundary Value Analysis (경계값 분석)**: 0, 1, 100억, -1 등 로직의 한계점을 집중 테스트.
- **Equivalence Partitioning (동치 분할)**: 지출/수입, 필수/선택 등 동일한 결과군을 묶어 대표값 테스트.
- **Side-Effect Simulation**: DB 장애, 권한 부족 등 시스템 사이드 이펙트 검증.

## Folder Strategy
`RichDiaryTests/`
├── `Domain/` (Core Business Entities & Logic)
├── `Presentation/` (UI Logic & State - Based on existing VCs)
└── `Infrastructure/` (Storage & External Systems)
