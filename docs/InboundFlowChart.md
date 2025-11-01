## 회원 입고 관리 웹 API 요청 플로우 차트

```mermaid
graph TD
    subgraph "회원 입고 관리 웹 플로우 (API 요청)"
        A(입고관리) --> B["입고 현황 페이지 접속<br/>(GET /inbounds)"];
        B --> C{"작업을 선택하세요"};

        C -- "신규 입고 요청" --> D["입고 요청서 작성 페이지<br/>(GET /inbounds/new)"];
        D -- "내용 작성 후" --> E["<b>입고 요청 제출</b><br/>(POST /inbounds)"];
        E -- "요청 완료 후 현황 페이지로 이동" --> B;

        C -- "기존 요청 수정" --> F["수정할 요청 선택 후<br/>수정 페이지 접속<br/>(GET /inbounds/{id}/update)"];
        F -- "내용 수정 후" --> G["<b>수정 내용 제출</b><br/>(POST /inbounds/{id})"];
        G -- "수정 완료 후 현황 페이지로 이동" --> B;

        C -- "기존 요청 취소" --> H["'취소' 버튼 클릭<br/>(사용자 확인)"];
        H -- "확인 시" --> I["<b>입고 요청 취소 처리</b><br/>(POST /inbounds/{id}/cancel)"];
        I -- "취소 완료 후 현황 페이지로 이동" --> B;

        C -- "조건별 현황 조회" --> J["조회 옵션 선택<br/>(기간별/월별)"];
        J -- "기간 선택" --> K["기간별 입고 현황 조회<br/>(GET /inbounds?start=...&end=...)"];
        J -- "월 선택" --> L["월별 입고 현황 조회<br/>(GET /inbounds?month=...)"];
        K --> B;
        L --> B;

        C -- "종료" --> M(종료);
    end

    style E fill:#cce5ff,stroke:#333,stroke-width:2px
    style G fill:#cce5ff,stroke:#333,stroke-width:2px
    style I fill:#cce5ff,stroke:#333,stroke-width:2px
```

API 요청 설명

1. 입고 현황 조회

- (GET /inbounds): 자신이 요청한 모든 입고 건의 전체 목록을 서버로부터 받아와 화면에 표시합니다.
- (GET /inbounds?start=...&end=... 또는 ?month=...): 시작일/종료일 또는 특정 월을 기준으로 자신이 요청한 입고 현황을 기간별로 필터링하여 조회합니다.

2. 신규 입고 요청

- (GET /inbounds/new): 새로운 입고 요청서를 작성할 수 있는 입력 양식(form) 페이지를 불러옵니다.
- (POST /inbounds): 작성한 입고 요청서의 데이터를 서버로 전송하여 새로운 입고 건을 생성합니다.

3. 기존 입고 요청 관리

- (GET /inbounds/{id}/update): '승인대기' 상태인 특정 입고 요청({id})의 내용을 수정하기 위해, 기존 데이터가 채워진 수정 페이지를 불러옵니다.
- (POST /inbounds/{id}): 수정 페이지에서 변경한 내용을 서버로 전송하여 데이터를 업데이트합니다.
- (POST /inbounds/{id}/cancel): '승인대기' 상태인 특정 입고 요청({id})을 **철회(취소)**하기 위해 서버에 요청을 보냅니다.

## 관리자 입고 관리 웹 API 요청 플로우 차트

```mermaid
graph TD
    subgraph "총관리자 입고 관리 웹 플로우 (대시보드 중심)"
        A(입고관리 시작) --> B["입고 관리 종합 대시보드<br/>(GET /inbounds)"];

        B -- "대시보드에서 데이터 필터링" --> C["상태별/기간별 필터 적용<br/>(GET /inbounds?status=...&start=...)"];
        C --> B;

        B -- "'승인대기' 건 선택" --> D["승인 처리 페이지로 이동<br/>(GET /inbounds/{id}/approval)"];
        subgraph "입고 승인 프로세스"
            D -- "요청 검토 및<br/>입고일/위치 입력" --> E["<b>승인 처리 및 정보 저장</b><br/>(POST /inbounds/{id}/approve)"];
        end
        E -- "처리 완료 후 대시보드 복귀" --> B;

        B -- "'승인완료' 건 선택" --> F["승인된 요청에 대한<br/>추가 작업 선택"];
         subgraph "승인 후 입고 준비"
            F --> F1["<b>QR코드 생성</b><br/>(POST /inbounds/{id}/qrcode)"];
            F --> F2["<b>입고지시서 출력</b><br/>(GET /inbounds/{id}/print-order)"];
        end
        F1 --> B;
        F2 --> B;

        B -- "'입고예정' 건 선택" --> G["<b>실물 입고 완료 처리</b><br/>(POST /inbounds/{id}/receive)"];
        G --> B;

        B -- "기타 관리 작업" --> H{"수정 또는 취소"};
        H -- "수정" --> I["입고 요청 수정 페이지<br/>(GET /inbounds/{id}/update)"];
        I -- "제출" --> J["<b>수정 내용 저장</b><br/>(POST /inbounds/{id})"];
        J --> B;
        H -- "취소" --> K["<b>관리자 권한으로 요청 취소</b><br/>(POST /inbounds/{id}/cancel)"];
        K --> B;
    end

    style E fill:#cce5ff,stroke:#333,stroke-width:2px
    style F1 fill:#cce5ff,stroke:#333,stroke-width:2px
    style G fill:#cce5ff,stroke:#333,stroke-width:2px
    style J fill:#cce5ff,stroke:#333,stroke-width:2px
    style K fill:#cce5ff,stroke:#333,stroke-width:2px
```

1. 입고 현황 조회 (목록 및 필터링)ß

- (GET /inbounds): 모든 입고 요청 목록(상태 무관)을 조회하여 관리자 대시보드에 표시합니다. 관리자가 전체 현황을 파악하는 기본 API입니다.
- (GET /inbounds?status=...&start=...&end=...): 상태(pending, approved, received 등), 시작일, 종료일 등 다양한 쿼리 파라미터를 사용하여 입고 목록을 필터링하여 조회합니다. 예를 들어, 처리해야 할 승인대기 건만 보려면 ?status=pending을 사용합니다.

2. 입고 승인 및 처리

- (GET /inbounds/{id}/approval): 승인대기 상태인 특정 입고 요청({id})의 상세 정보와 함께, 입고 예정일 및 보관 위치를 입력할 수 있는 승인 처리 페이지를 불러옵니다.

- (POST /inbounds/{id}/approve): 관리자가 입력한 입고 예정일, 보관 위치 데이터를 서버로 전송하여 저장하고, 해당 입고 요청의 상태를 '승인완료'로 변경합니다.

3. 승인 후 작업

- (POST /inbounds/{id}/qrcode): '승인완료'된 특정 입고 요청({id})에 대한 QR코드를 생성하고, 생성된 QR 정보를 반환받습니다.
- (GET /inbounds/{id}/print-order): 현장 작업자가 사용할 입고지시서를 출력할 수 있는 페이지를 불러옵니다.
- (POST /inbounds/{id}/receive): 실제 물품이 창고에 도착했을 때, 해당 입고 요청({id})의 상태를 '입고완료'로 최종 변경합니다.

4. 기타 관리 기능

- (GET /inbounds/{id}/update): 관리자가 회원의 요청 내용을 직접 수정해야 할 때, 기존 데이터가 채워진 수정 페이지를 불러옵니다. (회원의 수정 페이지와 동일한 URL 사용 가능)
- (POST /inbounds/{id}): 수정 페이지에서 변경된 내용을 서버로 전송하여 데이터를 업데이트합니다. (회원의 수정 요청과 동일한 URL 사용 가능)
  (- POST /inbounds/{id}/cancel): 관리자 권한으로 특정 입고 요청({id})을 강제 취소 처리합니다. (회원의 취소 요청과 동일한 URL 사용 가능)
