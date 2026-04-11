# Step-by-Step Execution Workflow (Senior Standards)

**CRITICAL PRINCIPLES**:
- **Legacy Code Sanctity**: Existing code is proven and stable. When a test fails, suspect your **NEW code or Test Setup** first. Modifying existing code has the lowest priority.
- **Zero Data Loss**: Never modify schemas without a migration plan.
- **Testing-as-Doc**: Tests must read like technical specifications.

1. **[요구사항 분석 및 영향도 평가]**:
   - Analyze instructions, inputs, and expected outputs.
   - Audit data impact (Realm, UserDefaults).
2. **[사전 검색 및 논리 설계]**:
   - Search for utility functions.
   - Document logic, migration strategy, and test cases.
3. **[설계 승인]**:
   - Present the plan. **Wait for explicit "Yes/No" approval.**
4. **[TDD 기반 구현]**:
   - Write **Unit Test first** (Always Green goal).
   - Follow **Micro-commit** principle (1 atomic change = 1 commit).
5. **[최종 3단계 검증]**:
   - Build, Test (All green), and Run (13 mini simulator).
