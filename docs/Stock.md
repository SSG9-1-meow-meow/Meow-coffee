# MeowCoffee Stock
Spring 기반의 웹 애플리케이션을 기반으로 재고 관리 및 재고 실사 기능을 구현했습니다.
MyBatis를 사용하여 데이터베이스와 연동하며, RESTFUL 방식을 이용하여 서버는 데이터를 json 형태로 응답합니다. 


---
## 📦 프로젝트 구조
````
com.ssg.meowcoffee
├─ controller
│   └─ StockController.java      # 재고, 재고 실사, 창고, 거래처 관련 HTTP 요청 처리
├─ service
│   ├─ StockService.java         # 서비스 인터페이스
│   └─ StockServiceImpl.java     # 서비스 구현체, 비즈니스 로직 처리
├─ mapper
│   └─ StockMapper.java          # MyBatis Mapper 인터페이스
├─ domain
│   └─ CoffeeVO.java             # 커피 도메인 객체
├─ dto
│   ├─ StockReadDTO.java         # 재고 조회용 DTO
│   ├─ StockSearchDTO.java       # 재고 검색용 DTO
│   ├─ CoffeeDTO.java            # 커피 상세 정보 DTO
│   ├─ CompanyReadDTO.java       # 거래처 정보 DTO
│   ├─ DueDiligenceDTO.java      # 재고 실사 DTO
│   ├─ DueDiligenceReadDTO.java  # 재고 실사 조회 DTO
│   ├─ Criteria.java             # 페이징 정보(pageNum, amount) DTO
│   └─ PageDTO.java              # 페이징 DTO
resources
  └─ mappers
      └─ StockMapper.xml       # MyBatis SQL 매퍼
````
---
## ⚙️ 주요 기능
### 1. 재고 조회
- **전체 재고 조회**: `/api/stocks`
- **카테고리(대분류)별 조회**: `/api/stocks/category/{cfCategory}`
- **품종(중분류)별 조회**: `/api/stocks/type/{cfType}`
- **등급(소분류)별 조회**: `/api/stocks/grade/{cfGrade}`
- **품목별 조회**: `/api/stocks/{cfName}`
  
페이징 정보는 Criteria 객체를 통해 전달되며, 총 개수와 페이지 정보를 PageDTO로 반환합니다.

---

### 2. 커피 정보 상세 조회
- **커피 정보 조회**: `/api/stocks/coffee/{cfName}`

품목별 조회 페이지에서 커피 정보 조회 버튼을 누르면 Modal로 해당 커피 상세 정보를 확인할 수 있습니다.

---

### 3. 창고 및 거래처 현황 조회
- **창고 현황 조회**: `/api/stocks/warehouse`
- **거래처 현황 조회**: `/api/stocks/company`
- 창고 사용량(UseCapacity) 계산은 매일 자정 자동 업데이트(updateWarehouseUseCapaDaily)

창고 현황 조회를 통해 현재 창고에 적재된 모든 총 재고수량(plt)를 확인할 수 있으며, 
해당 총 재고수량은 스프링 프레임워크인 @Scheduled 매일 자정 자동으로 업데이트 하도록 설계되었습니다.

---

### 4. 재고 실사
- **재고 실사 목록 조회**: `/api/dueDiligences`
- **재고 실사 상세 조회**: `/api/dueDiligences/{ddId}`
- **재고 실사 등록**: `/api/dueDiligence` (POST)
- **재고 실사 수정**: `/api/dueDiligences/{ddId}/update` (PUT)
- **재고 실사 삭제**: `/api/dueDiligences/{ddId}` (PUT)
- **승인/거부** : `/api/dueDiligences/{ddId}/{ddApproval}` (GET)

재고 실사 등록, 수정, 삭제는 일반관리자의 창고 관리 권한 확인 후 가능하도록 구현했으며, 
총관리자가 재고 실사의 승인 여부를 결정하여 시스템 재고에 실제 입력 재고가 반영되도록 했습니다.

---

## 🔧 기술 스택
- **Backend**: Spring Boot 3.x, Spring MVC, Spring Transaction
- **ORM / Mapper**: MyBatis
- **DTO / Mapper Tool**: ModelMapper
- **DB**: MySQL
- **Logging**: Log4j2
- **Scheduler**: Spring @Scheduled
- **Validation**: javax.validation (@Valid, @NotBlank 등)
- **Server**: Tomcat 9.0.111

--- 

## 🗂️ 데이터베이스 구조
- **stock**: 재고
- **coffee**: 커피 품목 정보
- **warehouse**: 창고 정보
- **locations**: 창고 내 보관 위치 지정
- **location_places**: 창고 내 보관 위치(존,렉,셀)
- **companies**: 거래처(view)
- **due_diligence**: 재고 실사
- **warehouse_management**: 창고 관리

--- 
## ⚠️   참고 사항
1. DueDiligence 관련 기능은 `관리자 권한 체크`가 필수입니다.
2. MyBatis XML에서 Stored Procedure를 사용합니다 (insertDueDiligence, updateDueDiligence, updateApprovalStatus).
3. 삭제는 물리적 삭제가 아닌 `isDelete 플래그를 통한 논리 삭제`로 처리됩니다.
4. 검색 필터는 `StockSearchDTO`로 처리하며, cfCategory, cfType, cfGrade, cfName 중 하나를 기반으로 조회합니다.

--- 
## 💻 프론트 상세 구현 사항
<img src="/resources/static/components/stockNav.png" alt="stockNav">

재고 페이지에서의 nav바를 기준으로 각각 jsp 파일을 생성하였고, 상세 조회 페이지도 별도의 jsp파일로 분리하였습니다.
````
WEB-INF/views
─ stock
    ├─ stockSearch.jsp      # 검색 엔진을 이용한 재고 조회 리스트 페이지
    ├─ stockCfName.jsp      # 품목별 재고 조회 리스트 페이지
    ├─ stockWarehouse.jsp   # 창고 현황 리스트 페이지
    ├─ stockCompany.jsp     # 거래처 현황 리스트 페이지
    ├─ dueDiligenceList.jsp # 재고 실사 현황 페이지
    ├─ dueDiligenceTop.jsp  # 총관리자용 재고 실사 상세 페이지(승인하기, 거부하기 버튼)
    └─ dueDiligenceWh.jsp   # 일반관리자용 재고 실사 상세 페이지(수정하기, 삭제하기 버튼)
````
