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
## 💻 화면 설계
<img src="/docs/화면설계%20-%20재고.png">

---
## ⚙️ 주요 기능
### 1. 재고 조회
- **전체 재고 조회**: `/api/stocks`
````
//controller
//재고 관리 controller
    @GetMapping("/api/stocks")
    public ResponseEntity<Map<String, Object>> readStockList(@ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = new StockSearchDTO(); //재고 전체 조회이니 searchDTO에 아무것도 설정 안해줘도 됨
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

//service (재고 조회 부분 모두 동일하게 사용)
    @Override
    public List<StockReadDTO> getStockList(Criteria criteria, StockSearchDTO stockSearchDTO) {
        try {
            List<StockReadDTO> list = stockMapper.selectStockList(criteria, stockSearchDTO);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 조회 리스트를 DB에서 불러오는 중 오류 발생");
        }
    }
    
````
- **카테고리(대분류)별 조회**: `/api/stocks/category/{cfCategory}`
````
//controller
 @GetMapping("/api/stocks/category/{cfCategory}") //카테고리(대분류)별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByCategory(@PathVariable("cfCategory") String cfCategory,
                                                                      @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfCategory(cfCategory).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }
````
- **품종(중분류)별 조회**: `/api/stocks/type/{cfType}`
````
//controller
@GetMapping("/api/stocks/type/{cfType}") //품종(중분류)별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByType(@PathVariable("cfType") String cfType,
                                                                  @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfType(cfType).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }
````
- **등급(소분류)별 조회**: `/api/stocks/grade/{cfGrade}`
````
//controller
@GetMapping("/api/stocks/grade/{cfGrade}") //등급(소분류)별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByGrade(@PathVariable("cfGrade") String cfGrade,
                                                                   @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfGrade(cfGrade).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }
````
- **품목별 조회**: `/api/stocks/{cfName}`
````
//controller
@GetMapping("/api/stocks/{cfName}") //품목별 재고 조회
    public ResponseEntity<Map<String, Object>> readStockListByName(@PathVariable("cfName") String cfName,
                                                                  @ModelAttribute Criteria criteria) {
        StockSearchDTO searchDTO = StockSearchDTO.builder().cfName(cfName).build();
        List<StockReadDTO> list = stockService.getStockList(criteria, searchDTO);

        Integer total = stockService.getListCount(searchDTO, "stock");
        PageDTO pageDTO = new PageDTO(criteria,total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }
````
  
페이징 정보는 Criteria 객체를 통해 전달되며, 총 개수와 페이지 정보를 PageDTO로 반환합니다.

---

### 2. 커피 정보 상세 조회
- **커피 정보 조회**: `/api/stocks/coffee/{cfName}`
````
//controller
@GetMapping("/api/stocks/coffee/{cfId}") //커피 정보 상세 조회
    public ResponseEntity<CoffeeDTO> readCoffeeByName(@PathVariable("cfId") String cfId) {
        CoffeeDTO coffeeDTO = stockService.getCoffee(cfId);

        return ResponseEntity.ok(coffeeDTO);
    }

//service
@Override
    public CoffeeDTO getCoffee(String cfName) {
        try {
            CoffeeVO cfVO = stockMapper.selectCoffee(cfName);

            return modelMapper.map(cfVO, CoffeeDTO.class);
        } catch (Exception e) {
            throw new DatabaseTransactionException("커피 상세 정보를 DB에서 불러오는 중 오류 발생");
        }
    }
````

품목별 조회 페이지에서 커피 정보 조회 버튼을 누르면 Modal로 해당 커피 상세 정보를 확인할 수 있습니다.

---

### 3. 창고 및 거래처 현황 조회
- **창고 현황 조회**: `/api/stocks/warehouse`
````
//controller
@GetMapping("/api/stocks/warehouse")
    public ResponseEntity<Map<String, Object>> readStocksByWarehouse(@ModelAttribute Criteria criteria, @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        //권한 확인
       UserRole role = customUserDetails.getUserRole();

        if(role != UserRole.ADMIN && role != UserRole.MANAGER) return ResponseEntity.ok(Map.of("authorized", false));

        List<StockReadDTO> list = stockService.getWarehouses(criteria);

        Integer total = stockService.getListCount(null, "warehouse");
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }

//service
 @Override
    public List<StockReadDTO> getWarehouses(Criteria criteria) {
        try {
            List<StockReadDTO> list = stockMapper.selectWarehouses(criteria);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("창고 현황 목록을 DB에서 불러오는 중 오류 발생");
        }

    }
````
- **거래처 현황 조회**: `/api/stocks/company`
````
//controller
@GetMapping("/api/stocks/company")
    public ResponseEntity<Map<String, Object>> readCompanyList(@ModelAttribute Criteria criteria, @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        //권한 확인
        UserRole role = customUserDetails.getUserRole();

        if(role != UserRole.ADMIN && role != UserRole.MANAGER) return ResponseEntity.ok(Map.of("authorized", false));

        List<CompanyReadDTO> list = stockService.getCompanyList(criteria);

        Integer total = stockService.getListCount(null, "company");
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);
        return ResponseEntity.ok(response);
    }
    
//service
@Override
    public List<CompanyReadDTO> getCompanyList(Criteria criteria) {
        try {
            List<CompanyReadDTO> list = stockMapper.selectCompanyList(criteria);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("거래처 현황 목록을 DB에서 불러오는 중 오류 발생");
        }
    }
````
- 창고 사용량(UseCapacity) 계산은 매일 자정 자동 업데이트(updateWarehouseUseCapaDaily)

창고 현황 조회를 통해 현재 창고에 적재된 모든 총 재고수량(plt)를 확인할 수 있으며, 
해당 총 재고수량은 스프링 프레임워크인 @Scheduled 매일 자정 자동으로 업데이트 하도록 설계되었습니다.

---

### 4. 재고 실사
- **재고 실사 목록 조회**: `/api/dueDiligences`
````
//controller
@GetMapping("/api/dueDiligences")
    public ResponseEntity<Map<String, Object>> readDueDiligenceList(@ModelAttribute Criteria criteria, @AuthenticationPrincipal CustomUserDetails customUserDetails) {

        UserRole role = customUserDetails.getUserRole();

        if(role != UserRole.ADMIN && role != UserRole.MANAGER) return ResponseEntity.ok(Map.of("authorized", false));

        List<DueDiligenceReadDTO> list = stockService.getDueDiligenceList(criteria);

        Integer total = stockService.getListCount(null, "dueDiligence");
        PageDTO pageDTO = new PageDTO(criteria, total);

        Map<String, Object> response = new HashMap<>();
        response.put("list", list);
        response.put("pageDTO", pageDTO);

        return ResponseEntity.ok(response);
    }

//service
@Override
    public List<DueDiligenceReadDTO> getDueDiligenceList(Criteria criteria) {
        try {
            List<DueDiligenceReadDTO> list = stockMapper.selectDueDiligenceList(criteria);

            return list;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 목록을 DB에서 불러오는 중 오류 발생");
        }
    }

````
- **재고 실사 상세 조회**: `/api/dueDiligences/{ddId}`
````
//controller
@GetMapping("/dueDiligences/{ddId}")
    public String dueDiligencePage(@PathVariable("ddId") Long ddId, @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        //권한 확인 필요 (총관리자 , 일반관리자)
        UserRole role = customUserDetails.getUserRole();

        if(role == UserRole.ADMIN) return "/stock/dueDiligenceTop"; //총관리자 페이지
        return "/stock/dueDiligenceWh"; //일반관리자 페이지
    }

//service
@Override
    public DueDiligenceReadDTO getDueDiligence(Long ddId) {
        try {
            DueDiligenceReadDTO dto = stockMapper.selectDueDiligence(ddId);

            return dto;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 상세 정보를 DB에서 불러오는 중 오류 발생");
        }
    }
    

````
- **재고 실사 등록**: `/api/dueDiligence` (POST)
````
//controller
@GetMapping("/api/dueDiligence")
    public ResponseEntity<List<String>> createDueDiligenceForm(@AuthenticationPrincipal CustomUserDetails customUserDetails) {
        //총관리자인 경우 권한없음 띄우기
        UserRole role = customUserDetails.getUserRole();
        if(role == UserRole.ADMIN) return ResponseEntity.ok(null);

        List<String> codeList = stockService.getWarehouseCodeList();

        return ResponseEntity.ok(codeList);
    }
    
@PostMapping("/api/dueDiligence") //프론트에서 Result 받아서 -1이면 권한 없음 띄우기
    public ResponseEntity<Integer> createDueDiligence(@Valid @RequestBody DueDiligenceDTO dto, @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        //dto에 maId 추가하기
        dto.setMaId(customUserDetails.getUserId());
        Integer result = stockService.registerDueDiligence(dto);

        return ResponseEntity.ok(result);
    }    

//service
@Override
    public DueDiligenceReadDTO getDueDiligence(Long ddId) {
        try {
            DueDiligenceReadDTO dto = stockMapper.selectDueDiligence(ddId);

            return dto;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 상세 정보를 DB에서 불러오는 중 오류 발생");
        }
    }
````
- **재고 실사 수정**: `/api/dueDiligences/{ddId}/update` (PUT)
````
//controller
@GetMapping("/api/dueDiligences/{ddId}/update")
    public ResponseEntity<DueDiligenceReadDTO> updateDueDiligenceForm(@PathVariable("ddId") Long ddId){
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId);

        return ResponseEntity.ok(readDTO);
    }

@PutMapping("/api/dueDiligences/{ddId}/update") //받은 객체가 -1인 경우 권한 없음 띄우기
    public ResponseEntity<Integer> updateDueDiligence(@PathVariable("ddId") Long ddId,
                                                      @Valid @RequestBody DueDiligenceDTO dto,
                                                      @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        dto.setDdId(ddId);
        dto.setMaId(customUserDetails.getUserId()); //dto에 현재 로그인한 아이디 추가
        Integer result = stockService.modifyDueDiligence(dto);

        return ResponseEntity.ok(result);
    }

//service
 @Override
    @Transactional
    public Integer modifyDueDiligence(DueDiligenceDTO dueDiligenceDTO) {
        try {//권한 확인
            Integer checked = stockMapper.selectDueDiligenceAuthority(dueDiligenceDTO.getWhCode(), dueDiligenceDTO.getMaId());

            if(checked <= 0) return -1; //로그인한 사람이 해당 창고의 관리자가 아닌경우
        } catch (Exception e) {
            throw new DatabaseTransactionException("관리자 권한 확인 중 DB에서 오류 발생");
        }

        try {
            Integer result = stockMapper.updateDueDiligence(dueDiligenceDTO);

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 수정 중 DB에서 오류 발생");
        }
    }
````
- **재고 실사 삭제**: `/api/dueDiligences/{ddId}` (PUT)
````
//controller
@PutMapping("/api/dueDiligences/{ddId}")
    public ResponseEntity<Integer> deleteDueDiligence(@PathVariable("ddId") Long ddId,
                                                      @RequestBody DueDiligenceDTO dueDiligenceDTO,
                                                      @AuthenticationPrincipal CustomUserDetails customUserDetails) {
        DueDiligenceReadDTO readDTO = stockService.getDueDiligence(ddId); //현재 정보를 불러와야 권한 확인 가능
        dueDiligenceDTO.setDdId(ddId);
        dueDiligenceDTO.setWhCode(readDTO.getWhCode());
        dueDiligenceDTO.setMaId(customUserDetails.getUserId());

        Integer result = stockService.removeDueDiligence(dueDiligenceDTO);
        return ResponseEntity.ok(result);
        //프론트에서 받은 값이 -1이라면 권한 없음 띄우기
    }

//service
    @Override
    @Transactional
    public Integer removeDueDiligence(DueDiligenceDTO dueDiligenceDTO) {
        try {//권한 확인
            Integer checked = stockMapper.selectDueDiligenceAuthority(dueDiligenceDTO.getWhCode(), dueDiligenceDTO.getMaId());

            if(checked <= 0) return -1; //로그인한 사람이 해당 창고의 관리자가 아닌경우
        } catch (Exception e) {
            throw new DatabaseTransactionException("관리자 권한 확인 중 DB에서 오류 발생");
        }

        try {
            Integer result = stockMapper.deleteDueDiligence(dueDiligenceDTO.getDdId());

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 삭제 중 DB에서 오류 발생");
        }
    }
````
- **승인/거부** : `/api/dueDiligences/{ddId}/{ddApproval}` (GET)
````
//controller
@GetMapping("/api/dueDiligences/{ddId}/{ddApproval}")//프론트에서 버튼에 따라 ddApproval이 정해져서 유효성검사 필요없음
    public ResponseEntity<Integer> updateApprovalStatus(@PathVariable("ddApproval") String ddApproval,
                                                        @PathVariable("ddId") Long ddId) {
        Integer result = stockService.modifyApprovalStatus(ddApproval, ddId);
        //result값이 0이면 승인/거부 할 수 있는 상태가 아님
        return ResponseEntity.ok(result);
    }

//service
    @Override
    @Transactional
    public Integer modifyApprovalStatus(String ddApproval, Long ddId) {
        try {
            Integer result = stockMapper.updateApprovalStatus(ddApproval, ddId);

            return result;
        } catch (Exception e) {
            throw new DatabaseTransactionException("재고 실사 승인/거부 중 DB에서 오류 발생");
        }
    }
````

재고 실사 등록, 수정, 삭제는 일반관리자의 창고 관리 권한 확인 후 가능하도록 구현했으며, 
총관리자가 재고 실사의 승인 여부를 결정하여 시스템 재고에 실제 입력 재고가 반영되도록 했습니다.

---
## 설계한 MYSQL Query 및 Procedure
````
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "https://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.ssg.meowcoffee.mapper.StockMapper">
    <sql id="search">
        <choose>
            <when test="searchDTO.cfCategory != null">
                where cf.cfCategory = #{searchDTO.cfCategory}
            </when>
            <when test="searchDTO.cfType != null">
                where cf.cfType = #{searchDTO.cfType}
            </when>
            <when test="searchDTO.cfGrade != null">
                where cf.cfGrade = #{searchDTO.cfGrade}
            </when>
            <when test="searchDTO.cfName != null">
                where cf.cfName = #{searchDTO.cfName}
            </when>
        </choose>
    </sql>

    <select id="selectStockList" resultType="com.ssg.meowcoffee.dto.StockReadDTO">
        select stk.stkId, stk.stkQuantity, cf.cfName, cf.cfCategory, cf.cfGrade, cf.cfType,
        lp.zoneName, lp.rackName, lp.cellName, wh.whName, wh.whCode
        from stock stk join coffee cf on stk.cfId = cf.cfId
        join location_places lp on stk.lpId = lp.lpId
        join locations l on l.lpId = lp.lpId
        join warehouse wh on wh.whId = l.whId
        <include refid="search"/>
        limit #{criteria.skip}, #{criteria.amount}
    </select>

    <select id="selectCoffee" resultType="com.ssg.meowcoffee.domain.CoffeeVO">
        select * from coffee where cfName = #{cfName}
    </select>

    <select id="selectWarehouses" resultType="com.ssg.meowcoffee.dto.StockReadDTO">
        select wh.whCode, wh.whName, wh.whGrade, wh.whAddress, IFNULL(sum(stk.stkQuantity), 0) as stkQuantity
        from warehouse wh
        left join locations l on wh.whId = l.whId
        left join location_places lp on l.lpId = lp.lpId
        left join stock stk on stk.lpId = lp.lpId
        group by wh.whCode, wh.whName, wh.whGrade, wh.whAddress
        limit #{skip}, #{amount}
    </select>

    <select id="selectCompanyList" resultType="com.ssg.meowcoffee.dto.CompanyReadDTO">
        select comId, comName, comCode, comEmail, comPhone, comStartDate, comExpiredDate
        from companies
        limit #{skip}, #{amount}
    </select>

    <select id="selectDueDiligenceList" resultType="com.ssg.meowcoffee.dto.DueDiligenceReadDTO">
        select distinct dd.ddId, wh.whCode, stk.stkId, dd.ddStatus, dd.ddApproval, dd.ddDate, dd.ddUpdateDate
        from stock stk join due_diligence dd on dd.stkId = stk.stkId
        join location_places lp on lp.lpId = stk.lpId
        join locations l on l.lpId = lp.lpId
        join warehouse wh on wh.whId = l.whId
        where dd.isDelete = 0
        order by dd.ddId desc
        limit #{skip}, #{amount}
    </select>

    <select id="selectDueDiligence" resultType="com.ssg.meowcoffee.dto.DueDiligenceReadDTO">
        select distinct stk.stkId, wh.whCode, lp.zoneName, lp.rackName, lp.cellName, stk.stkQuantity, dd.realStkQuantity,
        dd.ddDate, dd.maId, dd.ddLog, dd.ddApproval
        from stock stk join due_diligence dd on dd.stkId = stk.stkId
        join location_places lp on lp.lpId = stk.lpId
        join locations l on l.lpId = lp.lpId
        join warehouse wh on wh.whId = l.whId
        where dd.ddId = #{ddId} and dd.isDelete = 0
    </select>

    <insert id="insertDueDiligence" statementType="CALLABLE">
        {call insertDueDiligence( #{insertDTO.stkId, mode=IN, jdbcType=VARCHAR},
        #{insertDTO.realStkQuantity, mode=IN, jdbcType=INTEGER},
        #{insertDTO.ddLog, mode=IN, jdbcType=VARCHAR},
        #{insertDTO.maId, mode=IN, jdbcType=VARCHAR})}
    </insert>

    <update id="updateDueDiligence" statementType="CALLABLE">
        {call updateDueDiligence(#{updateDTO.ddId, mode=IN, jdbcType=BIGINT},
        #{updateDTO.stkQuantity, mode=IN, jdbcType=INTEGER},
        #{updateDTO.realStkQuantity, mode=IN, jdbcType=INTEGER},
        #{updateDTO.ddLog, mode=IN, jdbcType=VARCHAR})}
    </update>

    <delete id="deleteDueDiligence">
        update due_diligence set isDelete = 1 where ddId = #{ddId}
    </delete>

    <select id="selectDueDiligenceInfo" resultType="com.ssg.meowcoffee.dto.DueDiligenceDTO">
        select stk.stkQuantity
        from stock stk join location_places lp on lp.lpId = stk.lpId
        join locations l on l.lpId = lp.lpId
        join warehouse wh on wh.whId = l.whId
        where stk.stkId = #{stkId} and wh.whCode = #{whCode}
    </select>

    <update id="updateApprovalStatus" statementType="CALLABLE">
        {call updateApprovalStatus(#{ddApproval, mode=IN, jdbcType=VARCHAR},
        #{ddId, mode=IN, jdbcType=BIGINT})}
    </update>

    <select id="selectDueDiligenceAuthority" resultType="int">
        select count(*)
        from warehouse wh join warehouse_management wm on wh.whId = wm.whId
        where wh.whCode = #{whCode} and wm.userId = #{maId}
    </select>

    <select id="selectWarehouseCodeList" resultType="string">
        select distinct whCode from warehouse
    </select>

    <select id="countStockTotal" resultType="int">
        select count(*)
        from stock stk join coffee cf on stk.cfId = cf.cfId
        join location_places lp on stk.lpId = lp.lpId
        join locations l on l.lpId = lp.lpId
        join warehouse wh on wh.whId = l.whId
        <include refid="search"/>
    </select>

    <select id="countDueDiligenceTotal" resultType="int">
        select count(*)
        from stock stk join due_diligence dd on dd.stkId = stk.stkId
        join location_places lp on lp.lpId = stk.lpId
        join locations l on l.lpId = lp.lpId
        join warehouse wh on wh.whId = l.whId
        where dd.isDelete = 0
    </select>

    <select id="countWarehouseTotal" resultType="int">
        select count(*)
        from ( select wh.whCode, wh.whName, wh.whGrade, wh.whAddress
        from warehouse wh
        left join locations l on wh.whId = l.whId
        left join location_places lp on l.lpId = lp.lpId
        left join stock stk on stk.lpId = lp.lpId
        group by wh.whCode, wh.whName, wh.whGrade, wh.whAddress) as mySub
    </select>

    <select id="countCompanyTotal" resultType="int">
        select count(*) from companies
    </select>

    <!-- StockMapper.xml -->
    <update id="updateWarehouseUseCapa">
        UPDATE warehouse w
        LEFT JOIN (
        SELECT
        wh.whId,
        IFNULL(SUM(stk.stkQuantity), 0) AS totalQuantity
        FROM warehouse wh
        LEFT JOIN locations l ON wh.whId = l.whId
        LEFT JOIN location_places lp ON l.lpId = lp.lpId
        LEFT JOIN stock stk ON stk.lpId = lp.lpId
        GROUP BY wh.whId
        ) t ON w.whId = t.whId
        SET w.whUseCapa = t.totalQuantity;
    </update>

</mapper>

//프로시저
--  등록 프로시저
delimiter ##
create procedure insertDueDiligence(
    in stk_Id varchar(12),
    in real_StkQuantity int,
    in dd_Log varchar(255),
    in ma_Id varchar(30)
)
begin
    declare status varchar(10);
    declare quantity int;
select stk.stkQuantity into quantity
from stock stk
where stk.stkId = stk_Id;
if quantity = real_StkQuantity then set status = 'CORRECT';
else set status = 'INCORRECT';
end if;
insert into due_diligence (stkId, ddStatus, maId, ddLog, realStkQuantity)
values(stk_Id, status, ma_id, dd_Log, real_StkQuantity);

end ##
delimiter ;

 -- 수정 프로시저
delimiter ##
create procedure updateDueDiligence(
    in dd_Id BIGINT,
    in stk_Quantity int,
    in real_StkQuantity int,
    in dd_Log VARCHAR(255)
)
begin
    declare status varchar(10);

    if stk_Quantity = real_StkQuantity then set status = 'CORRECT';
else set status = 'INCORRECT';
end if;

update due_diligence set ddStatus=status, ddLog = dd_Log,
                         ddUpdateDate = now(), realStkQuantity = real_StkQuantity
where  ddId = dd_Id and isDelete = 0;

end ##
delimiter ;

 -- 총관리자 승인 프로시저
delimiter ##
create procedure updateApprovalStatus(
    in dd_Approval VARCHAR(10),
    in dd_Id BIGINT
)
begin
    declare real_quantity int;
    declare stk_id varchar(12);
    declare cur_status varchar(10);
    declare is_deleted tinyint;

select realStkQuantity, stkId, ddApproval, isDelete into real_quantity, stk_id, cur_status, is_deleted
from due_diligence where ddId = dd_Id;

if dd_Approval = 'APPROVED' and cur_status = 'PENDING' and is_deleted = 0 then
update stock set stkQuantity = real_quantity
where stkId = stk_id;
update due_diligence set ddApproval = dd_Approval
where ddId= dd_Id;
elseif dd_Approval = 'REJECTED' and cur_status= 'PENDING' and is_deleted = 0 then
update due_diligence set ddApproval = dd_Approval
where ddId= dd_Id;
end if;
end ##
delimiter ;
drop procedure if exists updateApprovalStatus;
````

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

## 📦 데이터베이스 구조
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
## 🎨 프론트 상세 구현 사항
<img src="/src/main/resources/static/components/stockNav.png" alt="stockNav">

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

---
## 🔥 트러블 슈팅(Trouble Shooting)
### 1. jsp파일의 EL태그 미인식으로 인한 오류

**문제 상황:** 화면 설계를 기반으로 한 프론트 설계를 먼저 해둔 뒤, 해당 내용을 jsp파일에 붙여넣기했으나
EL태그를 jsp파일에서 인식하지 못하여 페이지 로드 자체가 안되는 문제가 발생했다.

**해결 방법:** EL태그로 작업한 부분을 모두 string concatenation으로 수정하였다.

### 2. 스프링 시큐리티 부분 적용으로 인한 오류

**문제 상황:** 스프링 시큐리티 개발 후 재고 부분에 입히는 과정에서 코드 설계에 문제가 생겨 권환
확인이 제대로 이루어지지 않았다. 따라서 유효하지 않은 권한에도 해당 페이지가 들어가지는 문제가 발생했다.

**해결 방법:** 직접 변수를 집어넣는 방식으로 테스트하고, 이후 리팩토링 과정에서 spring security를
적용한 코드를 추가하였다.
---

