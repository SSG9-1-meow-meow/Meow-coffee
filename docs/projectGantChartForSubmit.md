```mermaid
gantt
    title SSG 9차수 냥냥 커피 WMS 프로젝트 간트 차트
    dateFormat YYYY-MM-DD

    section 기획
    요구사항 정의 :a1, 2025-11-07, 1d
    와이어프레임 작성 :a2, after a1, 1d
    화면정의서 작성 :a3, after a1, 1d
    API 명세서 작성 :a4, after a1, 1d

    section 개발
    백엔드 개발 :b1, after a4, 3d
    프론트엔드 개발 :b2, after a4, 3d

    section 테스트
    단위 테스트 :c1, 2025-11-11, 1d
    통합 테스트 :c2, after b2, 1d

    section 정리
    문서 작성 :d1, after c2, 1d
    동영상 촬영 :d2, after c2, 1d
    최종발표: milestone, m1, after d2, 0

```
