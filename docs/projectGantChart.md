```mermaid
gantt
    title SSG 9차수 냥냥 커피 WMS 프로젝트 간트 차트
    dateFormat YYYY-MM-DD

    section 기획
    요구사항 정의 :a1, 2025-10-31, 1d
    와이어프레임 작성 :a2, after a1, 2d
    화면정의서 작성 :a3, after a2, 1d
    API 명세서 작성 :a4, after a2, 2d

    section 개발
    백엔드 개발 :b1, after a4, 5d
    프론트엔드 개발 :b2, after a4, 5d

    section 테스트
    단위 테스트 :c1, after b2, 1d
    통합 테스트 :c2, after c1, 1d

    section 정리
    문서 작성 :d1, after c2, 1d
    동영상 촬영 :d1, after c2, 1d
    최종발표: milestone, m1, 2025-11-14, 0

```
