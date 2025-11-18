# ☕ Meow Coffee WMS (창고 관리 시스템) 프로젝트

## 1. 프로젝트 개요

### 1-1. 프로젝트 소개

> **Meow Coffee WMS**는 커피 유통 비즈니스에 특화된 전문 창고 관리 시스템(Warehouse Management System)입니다.
> 본 프로젝트는 회원사(화주)의 상품 입고 요청부터 창고 내 적치, 재고 관리, 출고 지시에 이르기까지 창고 운영의 전 과정을 효율적으로 디지털화하고 자동화하는 것을 목표로 합니다.

> 회원사는 웹을 통해 간편하게 입고를 요청하고 진행 상황을 추적할 수 있으며, 내부 창고 관리자는 실시간 데이터를 기반으로 최적의 의사결정을 내리고 현장 작업을 지시할 수 있습니다. 이를 통해 휴먼 에러를 최소화하고, 재고 가시성을 확보하며, 창고 공간 및 자원 활용률을 극대화합니다.

### 1.2. 주요 기능

본 프로젝트는 크게 로그인, 회원가입, 입고, 출고, 창고, 재고, 재무, 대시보드 기능으로 구성되어 있으며,
아래는 담당한 입고 관리 파트의 주요 기능입니다.

| 구분              | 주요 기능                 | 상세 설명                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ----------------- | ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **입고 관리**     | 회원사 입고 요청          | 회원사가 입고할 상품, 수량, 희망 입고일을 지정하여 요청하고 임시 저장하는 기능을 제공합니다.                                                                                                                                                                                                                                                                                                                                                                                                       |
|                   | **관리자 동적 입고 처리** | 관리자는 시각화된 데이터를 바탕으로 입고 요청을 처리합니다.<br> • **창고 부하 시각화**: FullCalendar와 연동하여 일별/창고별 예상 부하(처리량, 인력, 장비)를 '안전', '경고', '위험' 상태로 표시합니다.<br> • **최적 보관 위치 추천**: 선택된 날짜와 입고 수량을 기준으로, 공간 효율성 및 작업 안정성을 고려한 최적의 보관 위치(Location)를 시스템이 추천합니다.<br> • **유연한 날짜 재지정**: Flatpickr UI를 통해 관리자가 실시간으로 부하 정보를 확인하며 최적의 입고 예정일을 지정할 수 있습니다. |
|                   | 입고 지시서 생성          | '승인완료'된 건에 대해 현장 작업자를 위한 상세 입고 지시서를 생성하고, PDF로 출력하거나 공유할 수 있습니다.                                                                                                                                                                                                                                                                                                                                                                                        |
|                   | 검수 및 실물 입고 처리    | 현장에서 지시서 기반의 검수가 완료되면, 관리자는 시스템에서 '검수 시작' 및 '실물 입고 완료' 처리를 통해 재고를 확정합니다.                                                                                                                                                                                                                                                                                                                                                                         |
|                   | QR 코드 연동              | '입고완료' 처리 시, 해당 재고(파렛트 단위)의 고유 QR 코드가 생성됩니다. QR 코드 스캔 시 해당 재고의 상세 정보 페이지로 이동하여 실시간 재고 추적을 지원합니다.                                                                                                                                                                                                                                                                                                                                     |
| **대시보드/통계** | 주요 지표 시각화          | (대시보드 담당 구현) 월별/일별 입출고량, 품목별 입출고 순위, 평균 입고/출고 리드타임 등 핵심 성과 지표(KPI)를 차트로 제공합니다.                                                                                                                                                                                                                                                                                                                                                                   |

### 1.3 입고 관리 파트 실행 데모 영상

[![thumbnail_image](https://img.youtube.com/vi/BBk4V9J8obs/maxresdefault.jpg)](https://www.youtube.com/watch?v=BBk4V9J8obs&t=1s)

1. 입고 요청 및 목록 조회: 회원사가 입고를 요청하고, 회원/관리자가 조건별로 목록을 필터링/정렬
2. 동적 입고 처리 과정 (핵심 기능):

- 관리자가 FullCalendar에서 특정 날짜를 클릭하면 우측에 해당 날짜의 부하 정보와 할당 가능 위치가 실시간으로 업데이트
- 관리자가 최종 처리 섹션의 데이트 피커(flatpickr)로 날짜를 변경할 때마다 위치 추천 드롭다운이 함께 변경됨

3. 입고 지시서 및 QR 코드 생성: '입고 지시서' 버튼을 눌러 PDF 미리보기/출력 화면으로 이동, 'QR 코드 보기' 버튼을 눌러 모달에 QR 코드가 뜨고, 클릭하면 재고화된 정보가 새 화면으로 뜸.

### 1.4. 기술 스택 (Technology Stack)

| 구분            | 기술                                                   | 상세 내용                                                          |
| --------------- | ------------------------------------------------------ | ------------------------------------------------------------------ |
| **Backend**     | Java 11, Spring Framework 5.3.27, Lombok, Jackson      | 안정적인 비즈니스 로직 처리를 위한 Spring Framework 기반 서버 구축 |
| **Database**    | MySQL 8.0.22                                           | 관계형 데이터베이스 시스템                                         |
| **Data Access** | MyBatis 3.5.7, HikariCP                                | SQL 중심의 개발 및 높은 성능의 DB Connection Pool 사용             |
| **Frontend**    | JSP, JavaScript (ES6), JSTL, AJAX (Axios)              | 서버사이드 렌더링 및 동적 UI 구현                                  |
| **UI/UX**       | Bootstrap 5, jQuery, FullCalendar, Flatpickr, Chart.js | 반응형 웹 디자인 및 인터랙티브한 데이터 시각화                     |
| **Server**      | Apache Tomcat 9.0.11                                   | WAS(Web Application Server)                                        |
| **Build Tool**  | Gradle                                                 | 의존성 관리 및 프로젝트 빌드 자동화                                |

### 1.5. 주요 아키텍처 및 설계

- **Layered Architecture (계층형 아키텍처)**

  - **Controller - Service - Mapper(Repository) - Domain**으로 역할을 명확히 분리하여 코드의 재사용성과 유지보수성을 높였습니다.
  - DTO(Data Transfer Object)를 사용하여 각 계층 간 필요한 데이터만 전달하도록 설계했습니다.

- **Spring MVC Framework**

  - `DispatcherServlet`을 중심으로 한 Front-Controller 패턴을 기반으로 웹 요청을 효율적으로 처리하고, `ViewResolver`를 통해 적절한 JSP 뷰를 렌더링합니다.

- **데이터베이스 중심의 비즈니스 로직 처리**
  - **Stored Procedures (저장 프로시저) 활용**: 신규 입고 요청, 수정, 관리자 최종 처리 등 여러 테이블에 걸친 복잡한 트랜잭션 로직을 Stored Procedure로 구현하여, 데이터의 일관성과 처리 속도를 보장했습니다.
  - **Triggers (트리거) 활용**: 입고 승인 시 '일별 창고 부하' 테이블을 자동으로 업데이트하거나, 입고 완료 시 '재고' 테이블에 수량을 반영하는 등, 특정 이벤트에 따른 후속 작업을 트리거로 자동화하여 데이터 정합성을 유지했습니다.
  - **CTE (Common Table Expressions) 활용**: 복잡한 '할당 가능 위치 조회' 쿼리에서 가독성을 높이고 로직을 구조화하기 위해 CTE(WITH 절)를 사용했습니다.

---

## 2. 프로젝트 구조

### 2.1. 패키지 구조 (입고 관리 파트)

> 본 프로젝트는 Spring Framework의 계층형 아키텍처(Layered Architecture)를 기반으로 각 패키지의 역할을 명확히 분리하여 설계되었습니다. 이를 통해 코드의 응집도를 높이고 결합도를 낮춰 유지보수성과 확장성을 확보했습니다.

```
com.ssg.meowcoffee
 ├─ controller       // 1. 웹 요청 처리 및 뷰 맵핑
 │  └─ InboundController.java
 ├─ service          // 2. 비즈니스 로직 처리
 │  ├─ InboundService.java
 │  └─ InboundServiceImpl.java
 ├─ mapper           // 3. 데이터베이스 연동 (DAO)
 │  └─ InboundMapper.java
 ├─ dto              // 4. 계층 간 데이터 전송 객체
 │  ├─ InboundCriteria.java
 │  ├─ InboundItemDetailDTO.java
 │  ├─ InboundProcessDTO.java
 │  └─ ...
 ├─ domain           // 5. 핵심 비즈니스 도메인 객체 (VO, Entity)
 │  ├─ InboundRequestVO.java
 │  ├─ InboundItemVO.java
 │  ├─ InboundStatus.java (Enum)
 │  └─ ...
 └─ util             // 6. 공통 유틸리티
    └─ InboundStatusTypeHandler.java
```

1.  **`controller`**: 웹 계층

    - 클라이언트의 HTTP 요청을 가장 먼저 수신하는 진입점입니다.
    - **`InboundController.java`**: `/inbounds`로 시작하는 모든 입고 관련 URL 요청을 처리합니다. `Service` 계층으로 비즈니스 로직 처리를 위임하고, 그 결과를 `Model`에 담아 적절한 JSP 뷰(`View`)로 포워딩하거나, `@ResponseBody`를 통해 RESTful API의 JSON 응답을 반환합니다.

2.  **`service`**: 비즈니스 로직 계층

    - 애플리케이션의 핵심 비즈니스 로직을 수행하는 계층입니다. 트랜잭션 처리(`@Transactional`)가 이루어지는 주요 지점입니다.
    - **`InboundService.java`**: 입고 관리 기능에 대한 명세(interface)를 정의합니다.
    - **`InboundServiceImpl.java`**: `InboundService`의 구현체로, `Controller`로부터 전달받은 데이터를 가공하고, `Mapper`를 호출하여 여러 데이터베이스 작업을 조합하는 등 복잡한 비즈니스 규칙을 처리합니다.

3.  **`mapper`**: 데이터 접근 계층 (DAO)

    - MyBatis 프레임워크를 사용하여 데이터베이스와 직접 통신하는 역할을 합니다.
    - **`InboundMapper.java`**: SQL 쿼리를 호출할 메소드를 정의하는 MyBatis 매퍼 인터페이스입니다. `resources/mappers/InboundMapper.xml`에 정의된 SQL과 1:1로 매핑됩니다. 복잡한 로직은 Stored Procedure를 호출하는 방식으로 구현되었습니다.

4.  **`dto` (Data Transfer Object)**: 데이터 전송 객체

    - 각 계층(특히 Controller와 View) 간에 데이터를 전달하기 위해 사용되는 객체입니다.
    - **`InboundItemDetailDTO.java`**: 여러 테이블(`inboundItems, inboundRequests, users, coffee` 등)을 조인한 상세 조회 결과를 한 번에 담기 위한 복합 DTO입니다.
    - **`InboundProcessDTO.java`**: 관리자가 입고 처리를 할 때, View에서 Controller로 필요한 데이터(상태, 확정일, 위치, 메모 등)를 전달하기 위해 사용됩니다.

5.  **`domain` (VO - Value Object)**: 도메인 객체

    - 데이터베이스 테이블의 구조와 밀접하게 매핑되는 핵심 데이터 객체입니다.
    - **`InboundRequestVO.java`**, **`InboundItemVO.java`**: 각각 `inboundRequests`, `inboundItems` 테이블의 한 행(Row)을 표현합니다.
    - **`InboundStatus.java`**: '승인대기', '승인완료', '입고완료', '반려' 등 입고 상태를 타입 안전(type-safe)하게 관리하기 위한 열거형(Enum) 타입입니다.

6.  **`util`**: 유틸리티
    - 특정 계층에 속하지 않는 공통 기능이나 보조 도구를 모아놓은 패키지입니다.
    - **`InboundStatusTypeHandler.java`**: MyBatis가 DB의 `VARCHAR` 타입(예: 'APPROVED')과 Java의 `InboundStatus` Enum 타입을 자동으로 변환할 수 있도록 처리해주는 커스텀 타입 핸들러입니다.

---

### 2.2. 데이터베이스 테이블 관계 (ERD)

입고 관리 기능은 입고 요청, 상세 항목, 재고, 창고 부하 등 여러 테이블이 유기적으로 연동되어 동작합니다. 주요 테이블과 그 관계는 다음과 같습니다.

#### 주요 테이블 설명

| 테이블명                   | 역할                | 주요 컬럼                                                                                                                      |
| -------------------------- | ------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `inboundRequests`          | 입고 요청 마스터    | `inReqId (PK)`, `comId (FK)`, `inDttmReq`, `inDateWish`, `isTempo`                                                             |
| `inboundItems`             | 입고 요청 상세 항목 | `inReqItemsId (PK)`, `inReqId (FK)`, `cfId (FK)`, `status`, `inQtyReq`, `inQty`, `inDttmInsp`, `inDttmRecv`, `locationId (FK)` |
| `stock`                    | 실물 재고           | `stkId (PK)`, `lpId (FK)`, `cfId (FK)`, `stkQuantity`                                                                          |
| `daily_warehouse_capacity` | 일별 창고 부하 요약 | `dateId (PK)`, `whId (PK)`, `used_storage_capacity`, `used_processing_capacity` 등                                             |
| `users`                    | 회원사(화주) 정보   | `userId (PK)`, `userCompanyName`                                                                                               |
| `coffee`                   | 커피 품목 마스터    | `cfId (PK)`, `cfName`, `cfCategory`                                                                                            |
| `locations`                | 창고 내 상세 위치   | `locationId (PK)`, `lpId (FK)`, `whId (FK)`                                                                                    |

#### 관계도 (ERD)

```
 [users] 1 --< [inboundRequests] 1 --< [inboundItems] >-- 1 [coffee]
 (회원사)          (입고 요청)           (상세 항목)         (품목)
    |                  |                      |
    |                  |                      |
    └- comId           └- inReqId              └- cfId, locationId
                                                  |
                                                  |
                                                  v 1
                                               [locations]
                                               (상세 위치)

  ============================== 트리거(Trigger)에 의한 연동 ==============================

 1. 입고 승인 시:
   [inboundItems] (UPDATE: status='APPROVED')
      -- (trg_update_daily_warehouse_capacity) --> [daily_warehouse_capacity] (INSERT or UPDATE)
                                                          (일별 창고 부하 업데이트)

 2. 실물 입고 완료 시:
   [inboundItems] (UPDATE: status='RECEIVED')
      -- (trg_add_stock_on_inbound_complete) --> [stock] (INSERT or UPDATE)
                                                       (실물 재고 반영)
```

#### 관계 설명

- **1:N (일대다) 관계**:

  - 하나의 `users`(회원사)는 여러 개의 `inboundRequests`(입고 요청)를 가질 수 있습니다.
  - 하나의 `inboundRequests`(입고 요청)는 여러 개의 `inboundItems`(상세 항목)를 포함할 수 있습니다.
  - 하나의 `coffee`(품목)나 `locations`(위치)는 여러 `inboundItems`에 기록될 수 있습니다.

- **트리거(Trigger)를 통한 자동화된 데이터 흐름**:
  1.  **입고 승인 연동**: 관리자가 특정 `inboundItems`의 `status`를 **'승인완료'(`APPROVED`)** 로 업데이트하면, `trg_update_daily_warehouse_capacity` 트리거가 자동으로 실행됩니다. 이 트리거는 해당 항목의 입고 예정일(`inDttmSchd`)과 창고(`whId`)를 기준으로 `daily_warehouse_capacity` 테이블의 그날짜 창고 부하(사용 용량, 배정 인원 등)를 증가시킵니다.
  2.  **재고 반영 연동**: 관리자가 '실물 입고 완료' 처리를 통해 `inboundItems`의 `status`를 **'입고완료'(`RECEIVED`)** 로 업데이트하면, `trg_add_stock_on_inbound_complete` 트리거가 자동으로 실행됩니다. 이 트리거는 해당 항목의 위치(`lpId`)와 품목(`cfId`)을 기준으로 `stock` 테이블에 재고가 있으면 수량을 더하고(`UPDATE`), 없으면 새로운 재고를 생성(`INSERT`)합니다.

이러한 구조를 통해, 관리자의 단순한 상태 변경 행위가 연관된 데이터(창고 부하, 실물 재고)에 자동으로 일관성 있게 반영되도록 시스템을 설계했습니다.

### 2.3 API 명세

> RESTful API 원칙에 따라 설계하려고 하였습니다. 입고 관리와 관련된 주요 API 목록입니다.

| Method | URI                                 | 설명                                                        |
| ------ | ----------------------------------- | ----------------------------------------------------------- |
| `GET`  | `/inbounds/api`                     | 입고 목록을 조건(검색, 필터링, 페이징)에 따라 조회합니다.   |
| `POST` | `/inbounds/req`                     | 신규 입고 요청을 등록합니다.                                |
| `GET`  | `/inbounds/api/{inReqId}`           | 특정 입고 요청의 상세 정보를 조회합니다.                    |
| `PUT`  | `/inbounds/{inReqId}`               | 입고 요청 정보를 수정합니다.                                |
| `POST` | `/inbounds/items/{inReqItemsId}`    | 관리자가 개별 입고 항목을 최종 처리(승인/반려)합니다.       |
| `GET`  | `/inbounds/api/available-locations` | 특정 날짜와 수량에 대해 할당 가능한 창고 위치를 조회합니다. |

---

## 3. 트러블 슈팅 (Troubleshooting)

> 프로젝트를 진행하면서 마주했던 주요 기술적 문제들과 이를 해결하기 위한 과정입니다.

### 3.1. 동적인 일자별 입고 가능 여부 판단의 어려움

#### 시행 착오

- **문제 상황**: 관리자가 입고 요청을 승인할 때, 특정 날짜에 창고가 수용 가능한지를 실시간으로 판단할 명확한 기준 데이터가 없었습니다. `inboundItems` 테이블의 예정일(`inDttmSchd`)을 매번 전체 조회하여 합산하는 방식은 데이터가 증가함에 따라 심각한 성능 저하를 유발할 수 있었습니다.
- **초기 접근**: 사용자가 날짜를 클릭할 때마다 실시간으로 모든 `inboundItems` 테이블을 집계하는 API를 구상했으나, 이는 DB에 과도한 부하를 주어 비효율적이라고 판단했습니다.

#### 해결 방안

- **해결책**: **일별 창고 부하 요약 테이블(`daily_warehouse_capacity`)** 을 새로 설계하고, **데이터베이스 트리거(`Trigger`)** 를 도입하여 문제를 해결했습니다.
- **구현 과정**:
  1.  `daily_warehouse_capacity` 테이블을 생성하여 `dateId`(날짜)와 `whId`(창고 ID)를 복합 기본 키로, `used_storage_capacity`(사용된 저장 공간), `used_processing_capacity`(사용된 처리량) 등의 컬럼을 두었습니다.
  2.  `inboundItems` 테이블의 `status`가 **'승인완료'(`APPROVED`)** 로 `UPDATE`될 때, `AFTER UPDATE` 트리거(`trg_update_daily_warehouse_capacity`)가 자동으로 실행되도록 설정했습니다.
  3.  트리거는 `INSERT ... ON DUPLICATE KEY UPDATE` 구문을 사용하여, 해당 날짜와 창고의 데이터가 있으면 기존 값에 입고량을 더하고, 없으면 새로운 행을 삽입하여 일별 부하를 미리 집계합니다.
- **결과**: 관리자가 날짜를 조회할 때, 복잡한 실시간 집계 쿼리 대신 미리 계산된 요약 테이블의 데이터를 매우 빠르게 조회할 수 있게 되었습니다. 이로써 DB 부하를 최소화하면서 사용자에게 즉각적인 피드백(창고 부하 상태 시각화)을 제공할 수 있었습니다.

### 3.2. MyBatis의 ENUM 타입 처리 오류

#### 시행 착오

- **문제 상황**: Java 코드에서는 타입 안정성을 위해 입고 상태를 `InboundStatus`라는 `Enum`으로 관리했지만, MyBatis는 데이터베이스의 `VARCHAR` 타입(예: 'APPROVED')을 Java의 `Enum` 타입으로 자동 변환하지 못하여 애플리케이션 실행 시 타입 변환 오류가 발생했습니다.

#### 해결 방안

- **해결책**: MyBatis의 **`TypeHandler`**를 커스텀으로 구현하여 `VARCHAR`와 `Enum` 간의 변환 로직을 명시적으로 정의했습니다.
- **구현 과정**:
  1.  `org.apache.ibatis.type.TypeHandler` 인터페이스를 구현한 `InboundStatusTypeHandler.java` 클래스를 작성했습니다.
  2.  DB로 파라미터를 보낼 때는 `Enum.name()`을 사용하여 `VARCHAR`로, DB에서 결과를 가져올 때는 `Enum.valueOf()`를 사용하여 `Enum` 객체로 변환하는 로직을 구현했습니다.
  3.  `mybatis-config.xml`에 `<typeHandlers>` 섹션을 추가하여 커스텀 핸들러를 등록하고, `InboundMapper.xml`의 `<resultMap>`에서 해당 `TypeHandler`를 사용하도록 지정했습니다.

### 3.3. JSP 환경에서의 JavaScript-EL 태그 충돌

#### 시행 착오

- **문제 상황**: JavaScript 코드 내에서 동적으로 HTML을 생성하기 위해 ES6의 템플릿 리터럴(백틱 ` `` `)을 사용했습니다. 하지만 JSP 렌더링 엔진이 템플릿 리터럴 내부의 `${...}` 구문을 EL(Expression Language) 태그로 먼저 해석하려고 시도하면서, 의도치 않은 서버 사이드 오류 또는 클라이언트 사이드 `ReferenceError`가 발생했습니다.

#### 해결 방안

- **해결책**: JSP 환경과의 호환성을 위해 템플릿 리터럴 사용을 지양하고, **문자열 결합(`+`) 방식**으로 코드를 수정했습니다.
- **예시**:
  - **기존**: `const html = \`<div>${item.name}</div>\`;`
  - **수정**: `const html = '<div>' + item.name + '</div>';`
- **결과**: 이를 통해 JSP 렌더링 단계에서의 파싱 충돌을 원천적으로 방지하고, JavaScript 코드가 클라이언트 사이드에서 의도한 대로 정상 동작하도록 보장했습니다.

### 3.4. Java 8 `LocalDateTime`과 Jackson/JSP 간의 파싱 문제

#### 시행 착오

- **문제 상황**:
  1.  **Controller -> View**: DTO의 `LocalDateTime` 필드를 JSP로 전달했을 때, JSTL의 `<fmt:formatDate>` 태그가 이를 인식하지 못하여 `Cannot convert ...` 타입 변환 예외가 발생했습니다.
  2.  **View -> Controller**: 클라이언트에서 `yyyy-MM-dd` 형식의 날짜 문자열을 JSON으로 전송했을 때, Spring Controller가 이를 `LocalDateTime` 타입의 DTO 필드에 자동으로 바인딩하지 못했습니다.

#### 해결 방안

- **해결책**:
  1.  **Controller -> View**: Controller에서 `LocalDateTime`을 `java.util.Date`로 변환하여 `Model`에 추가하는 방식을 채택했습니다. `Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant())` 코드를 사용하여 변환 후 JSP로 전달함으로써 `<fmt:formatDate>` 태그가 정상적으로 동작하도록 했습니다.
  2.  **View -> Controller**: DTO의 `LocalDateTime` 필드에 **`@JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")`** (또는 필요한 형식) 어노테이션을 추가했습니다. 이를 통해 Jackson 라이브러리가 JSON 문자열을 역직렬화(deserializing)할 때 지정된 패턴을 사용하여 `LocalDateTime` 객체로 정확하게 변환하도록 명시했습니다.

### 3.5. CSS 우선순위로 인한 UI 버튼 비활성화 실패

#### 시행 착오

- **문제 상황**: JavaScript에서 `element.style.display = 'none';` 코드를 사용하여 특정 버튼(예: '저장')을 숨기려고 했으나, Bootstrap의 CSS 규칙(`.d-flex` 등)이 더 높은 우선순위(Specificity)를 가져 스타일이 덮어씌워지면서 버튼이 계속 보이는 문제가 발생했습니다.

#### 해결 방안

- **해결책**: 인라인 스타일을 직접 제어하는 대신, Bootstrap에서 제공하는 유틸리티 클래스를 동적으로 추가/제거하는 방식으로 변경했습니다.
- **구현 과정**:
  - **`decisionButtons.style.display = 'none';`** 대신 **`decisionButtons.classList.add('d-none');`** 코드를 사용했습니다.
  - 다시 보여줄 때는 `classList.remove('d-none');`를 사용했습니다.
- **결과**: Bootstrap의 설계 철학에 맞는 방식으로 UI를 제어함으로써 CSS 우선순위 충돌 문제를 해결하고, 더 예측 가능하며 일관된 UI 동작을 구현했습니다.

### 3.6. FullCalendar의 월(Month) 단위 이벤트 조회 미스매치

#### 시행 착오

- **문제 상황**: FullCalendar는 월(Month) 뷰를 표시할 때, 해당 월의 1일부터 말일까지만 보여주는 것이 아니라, 달력 UI에 표시되는 이전 달의 일부 날짜와 다음 달의 일부 날짜를 포함하여 **총 42일(6주)**의 데이터를 요청합니다. 처음에는 현재 월의 데이터만 조회하여 전달하려고 했으나(Ex. 11.15일이면 11월의 데이터), 10월의 데이터를 조회 해오는 문제가 발생함.

#### 해결 방안

- **해결책**: FullCalendar의 이벤트 소스(events) 콜백 함수가 제공하는 `fetchInfo` 객체의 **`startStr`**와 **`endStr`** 속성을 활용했습니다.
- **구현 과정**:
  1.  `events: async function (fetchInfo) { ... }` 콜백 함수를 구현했습니다.
  2.  `fetchInfo.startStr` (달력 시작일)와 `fetchInfo.endStr` (달력 종료일)을 API의 `startDate`, `endDate` 파라미터로 그대로 전달하여, **화면에 보이는 정확한 기간(약 42일)**에 대한 데이터만 조회하도록 했습니다.
- **결과**: 해당월과 맞지 않는 데이터를 조회하지 않고, 달력에 표시되는 모든 날짜에 대해 이벤트를 정확하게 렌더링하여 정확성을 개선했습니다.

## 4. 향후 개선 및 발전 방향

### 4-1. **성능 개선**

현재 복잡한 `findAvailableLocations` 쿼리는 데이터 증가 시 성능 저하가 예상됩니다. 이를 쿼리 최적화, 비지니스 로직 분리(단순한 쿼리와 Java에서 연산으로 조합), 통한 배치(Batch) 작업으로 매일 자정에 예상 재고를 미리 계산해두는 요약 테이블 방식으로 리팩토링하여 조회 성능을 최적화할 계획입니다.

현재 쿼리

```sql
<!-- 할당 가능한 Zone 목록 조회 -->
  <select id="findAvailableLocations" resultMap="availableLocationMap">
    <![CDATA[
    WITH
    scheduled_inbounds AS (
    SELECT L.lpId, SUM(II.inQtyReq) as total_in_qty
    FROM inboundItems II JOIN locations L ON II.locationId = L.locationId
    WHERE II.status = '승인완료'
    AND DATE(II.inDttmSchd) = #{selectedDate}
    GROUP BY L.lpId
    ),
    scheduled_outbounds AS (
    SELECT S.lpId, SUM(OI.outQtyReq) as total_out_qty
    FROM outboundItems OI JOIN stock S ON OI.stkId = S.stkId
    WHERE OI.status = '승인완료'
    AND DATE(OI.outDttmSchd) = #{selectedDate}
    GROUP BY S.lpId
    )
    SELECT
    LP.lpId,
    LP.zoneName,
    W.whName,
        IFNULL(S.stkQuantity, 0) AS current_stock,
        IFNULL(SI.total_in_qty, 0) AS scheduled_inbound,
        IFNULL(SO.total_out_qty, 0) AS scheduled_outbound
    FROM
    location_places LP
    JOIN locations L ON LP.lpId = L.lpId
    JOIN warehouse W ON L.whId = W.whId
    LEFT JOIN daily_warehouse_capacity DWC ON W.whId = DWC.whId AND DWC.dateId = #{selectedDate}
    LEFT JOIN stock S ON LP.lpId = S.lpId
    LEFT JOIN scheduled_inbounds SI ON LP.lpId = SI.lpId
    LEFT JOIN scheduled_outbounds SO ON LP.lpId = SO.lpId
    WHERE
    (IFNULL(DWC.used_processing_capacity, 0) + #{requiredQty}) <= IFNULL(DWC.max_processing_capacity, 50)
    AND (IFNULL(DWC.used_storage_capacity, 0) + #{requiredQty}) <= W.whTotalCapa
    HAVING
    (current_stock + scheduled_inbound - scheduled_outbound + #{requiredQty}) <= 20
    ORDER BY
    W.whName, LP.zoneName, LP.lpId;
    ]]>
  </select>
```

#### 문제점

- 인덱스 사용 불가 : WHERE 절에 있는 `DATE(II.inDttmSchd) = #{selectedDate}`와 같은 구문은 최악의 성능 저하 원인임. `DATE()` 함수를 컬럼에 적용하면 데이터베이스는 해당 컬럼의 인덱스를 전혀 활용하지 못하고, `inboundItems`와 `outboundItems` 테이블 전체를 스캔(Full Table Scan)하게 됨. 데이터가 수만 건만 되어도 쿼리 속도는 급격히 느려질 수 있음.

- 다중 JOIN의 부하 : `location_places`, `locations`, `warehouse`, `daily_warehouse_capacity`, `stock` 등 여러 테이블을 JOIN하며, 여기에 CTE 결과까지 `LEFT JOIN`하면서 데이터베이스가 처리해야 할 중간 데이터의 양이 기하급수적으로 늘어날 수 있음.

- DB 연산 부하 : `scheduled_inbounds`, `scheduled_outbounds` CTE는 쿼리가 실행될 때마다 매번 `inboundItems`와 `outboundItems` 테이블을 읽어 `SUM` 집계를 수행합니다. 사용자가 날짜를 클릭할 때마다 이 비싼 연산이 반복적으로 일어나 DB에 큰 부하를 줌.

- HAVING 절의 비효율: `HAVING` 절은 `WHERE` 절로 모든 데이터가 필터링된 이후에 동작합니다. 즉, `(current_stock + scheduled_inbound - scheduled_outbound + #{requiredQty})` 계산을 가능한 모든 `lpId`에 대해 수행한 후, 그 결과값이 20 이하인 것만 남기는 식.

### 4-2. **WebSocket을 이용한 실시간 알림**

회원사의 입고 요청이 승인되거나 반려될 때, WebSocket을 도입하여 관리자 페이지와 회원사 페이지에 실시간으로 알림을 푸시하는 기능을 구현할 계획입니다.

### 4-3. **Spring Security 적용**

현재 임시로 사용 중인 사용자 인증/인가 로직을 Spring Security로 전환하여, 역할 기반(Role-Based) 접근 제어를 보다 체계적이고 안전하게 구현할 계획입니다.
