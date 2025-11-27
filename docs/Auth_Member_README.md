# 1. 프로젝트 개요

## 프로젝트 소개

**Meow Coffee WMS 기본 소개**

- Meow Coffee WMS는 커피 유통 비즈니스에 특화된 전문 창고 관리 시스템(Warehouse Management System)입니다. 본 프로젝트는 거래처(화주)의 상품 입고 요청부터 창고 내 적치, 재고
  관리, 출고 지시에 이르기까지 창고 운영의 전 과정을 효율적으로 디지털화하고 자동화하는 것을 목표로 합니다.

**계정 기능 소개**

- 승인된 회원은 로그인을 진행하여 자신의 회원유형에 따라 Meow Coffee WMS가 제공하는 서비스를 이용할 수 있습니다.

**회원관리 기능 소개**

- Meow Coffee WMS에 등록된 개별 회원들은 프로필 페이지를 통해 자신의 회원정보를 조회, 수정하거나 관리자에게 휴면회원 전환을 요청할 수 있습니다.
- Meow Coffee WMS의 창고관리자와 총관리자는 검색필터를 사용하여 현재 WMS에 등록된 거래처, 관리자, 배송기사의 현황을 파악할 수 있습니다. 또한, WMS에 등록된 회원들의 현황을 승인대기, 승인완료,
  휴면대기, 휴면상태의 4가지 상태로 구분하여 관리합니다.

## 주요 기능

| 기능 분류         | 주요 기능          | 상세 설명                                                                                                                                                                                |
|---------------|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 로그인 관련        | 로그인            | - 입력한 아이디, 비밀번호에 해당하는 회원의 계정으로 창고관리시스템에 접속합니다.<br/>- 로그인한 회원의 데이터는 로그아웃할 때까지 세션에 보관됩니다.                                                                                              |
|               | 로그아웃           | 현재 로그인한 회원의 정보를 로그인 세션에서 삭제하고 로그인 페이지로 이동합니다.                                                                                                                                        |
|               | 회원등록 신청        | - 선택한 회원가입유형에 따라 회원등록 신청 절차를 진행합니다.<br/>- 신규 회원등록 신청 폼 제출 시 해당 회원의 계정은 ‘승인대기’ 상태가 됩니다.                                                                                               |
|               | 아이디 찾기         | 입력한 사업자등록번호(거래처, 배송기사)/직원명(관리자)과 이메일이 모두 일치하는 계정의 아이디를 조회합니다.                                                                                                                        |
|               | 비밀번호 재설정       | 입력한 아이디, 이메일이 모두 일치하는 계정의 비밀번호를 사용자가 입력한 비밀번호로 재설정합니다.                                                                                                                               |
| 회원관리(공통)      | 프로필 조회         | 현재 로그인한 회원 자신의 상세정보를 조회합니다.                                                                                                                                                          |
|               | 프로필 수정         | 현재 로그인한 회원 자신의 비밀번호, 이메일, 연락처를 변경합니다.                                                                                                                                                |
|               | 휴면회원 전환 신청     | 현재 로그인한 회원 자신을 ‘휴면대기’ 상태로 전환합니다.                                                                                                                                                     |
| 회원관리(관리자용)    | 회원리스트 조회/회원 검색 | - 승인/미승인 회원들의 목록을 조회합니다.<br/>- 관리자는 회원리스트를 통해 각 회원별 아이디, 회원유형, 이름, 회원상태, 회원등록일, 마지막 로그인 일자를 조회합니다.<br/>- 회원리스트 상단의 검색필터(회원권한, 계정상태, 키워드검색, 기간)를 적용하여 WMS에 등록된 승인/미승인 회원을 검색할 수 있습니다. |
|               | 회원정보 상세조회      | - 관리자는 회원리스트를 통해 특정 회원에 관한 상세정보를 조회할 수 있습니다.                                                                                                                                         |
| 회원관리(총관리자 전용) | 계정상태 변경        | - 회원리스트에서 선택한 회원의 계정상태를 변경할 수 있습니다.<br/>- 총관리자는 회원가입을 승인하거나, 휴면대기 상태인 회원을 휴면회원으로 전환할 때 이 기능을 사용할 수 있습니다.                                                                             
|               | 휴면회원 전환        | 회원리스트에서 선택한 회원을 휴면회원으로 변경합니다.<br/> 이 기능은 마지막 로그인 날짜 이후로 1년 이상 WMS에 접속하지 않은 회원에게만 수행할 수 있습니다.                                                                                         |

---

# 2. 프로젝트 구조

## 로그인/회원관리 기능 관련 패키지 구조

```
src
└── main
    ├── java
    │   └── com.ssg.meowcoffee
    │       ├── controller                   
    │       │   ├── AuthController.java         # 계정(로그인, 회원가입) 관련 컨트롤러
    │       │   └── MemberController.java       # 회원관리(주로 회원정보 관련) 기능 관련 컨트롤러
    │       ├── domain
    │       │   ├── UserVO.java                 # 회원정보 VO
    │       │   ├── UserRole.java               # 회원권한 enum
    │       │   └── UserStatus.java             # 계정상태 enum
    │       ├── dto
    │       │   ├── CustomUserDetails.java      # 커스텀 UserDetails(SecurityContext에 현재 로그인한 계정 등록 시 사용되는 DTO)
    │       │   ├── FindIDDTO.java              # 아이디 찾기 폼 입력데이터 저장용 DTO
    │       │   ├── FindIDResultDTO.java        # 아이디 찾기 결과 반환용 DTO
    │       │   ├── ForgotPwdDTO.java           # 비밀번호 찾기 폼 입력데이터(아이디, 이메일) 저장용 DTO
    │       │   ├── ManagerDetailDTO.java       # 창고관리자/총관리자 데이터 관련 DTO
    │       │   ├── ResetPwdDTO.java            # 비밀번호 재설정 폼 입력데이터 저장용 DTO
    │       │   ├── UserCriteria.java           # 회원리스트 페이지네이션 적용 & 선택한 검색옵션 저장용 DTO   
    │       │   ├── UserDetailDTO.java          # 회원관리 기능 전용 회원정보조회 DTO
    │       │   ├── UserInfoUpdateDTO.java      # 회원정보 VO(전체 회원정보 조회, 회원가입,수정용 VO)
    │       │   ├── UserPageDTO.java            # 페이지, 검색필터 적용 후 조회결과 저장용 DTO
    │       │   └── UserStatUpdateDTO.java      # 계정상태 변경용 DTO
    │       ├── mapper
    │       │   └── MemberMapper.java           # 로그인/회원관리 기능 관련 Mapper 인터페이스
    │       ├── service
    │       │   ├── AuthService.java                  # 로그인 계정 조회용 서비스(@AuthenticationPrinciple 관련 오류 해결용)
    │       │   ├── CustomUserDetailsService.java     # 로그인 완료된 사용자에 관한 커스텀 UserDetailsService(스프링 시큐리티 기능 적용)  
    │       │   ├── MemberService.java                # 회원관리 서비스 기능 정의 인터페이스
    │       │   └── MemberServiceImpl.java            # 회원관리 서비스 로직 구현 클래스
    │       └── util                            
    │           ├── UserEnum.java               # 회원 관련 Enum 업캐스팅용 인터페이스 -> 커스텀 EnumTypeHandler 적용 대상으로 범주화
    │           └── CustomEnumTypeHandler.java  # Java Enum을 DB의 enum 타입으로 변환하기 위한 커스텀 EnumTypeHandler
    ├── resources
    │   └── mappers
    │       └── MemberMapper.xml                # 로그인/회원관리 기능 관련 MyBatis SQL 매퍼
    └── webapp
        └── WEB-INF
            └── spring
                ├── root-context.xml            # 전역 Bean 설정
                ├── security-context.xml        # 스프링 시큐리티 관련 설정 파일
                └── servlet-context.xml         # DispatcherServlet 설정

```

---

# 3. 트러블 슈팅

- [로그인/회원관리 기능 관련 주요 트러블슈팅 내용 정리](https://www.notion.so/2a7f68be603780af8473f26909a5142e?pvs=21)

---

# 4. 향후 개선 및 발전 방향

## DB 뷰 2차 분리

- 현재의 DB 구조에서는 회원정보 테이블로부터 거래처, 관리자, 배송기사에 관한 뷰를 생성했는데, 이를 회원정보 테이블에서 승인완료된 회원들의 데이터만 포함하는 뷰를 1차적으로 만든 다음, 이 뷰를 바탕으로
  거래처, 관리자, 배송기사에 관한 뷰를 생성하는 방식으로 개선함으로써, 아이디 찾기 기능에 관한 쿼리를 간소화할 계획입니다.

    <details>
        <summary>현재의 단일 회원정보 조회 쿼리</summary>

        ```xml
        <select id="findUserId" resultType="com.ssg.meowcoffee.dto.FindIDResultDTO">
          select userId, userRole from users
        <choose>
          <when test="userInfo.targetRole == 'COMPANY'">
            where userEmail = (
              select comEmail
              from companies
              where comCode = #{userInfo.userCode} and comEmail = #{userInfo.userEmail}
            )
          </when>
          <when test="userInfo.targetRole == 'MANAGER' or userInfo.targetRole == 'ADMIN'">
            where userEmail = (
              select managerEmail
              from managers
              where managerName = #{userInfo.userName}
              and managerEmail = #{userInfo.userEmail}
              and managerRole = #{userInfo.targetRole}
            )
          </when>
          <when test="userInfo.targetRole == 'DELIVERYMAN'">
            where userEmail = (
              select delivEmail
              from deliverymen
              where delivCode = #{userInfo.userCode}
              and delivEmail = #{userInfo.userEmail}
            )
          </when>
        </choose>
        </select>
        ```

    </details>

    <details>
        <summary>현재의 회원관리 기능 관련 DB 구조를 다시 개선한 뷰</summary>

        ```sql
        # 승인 완료된 회원들을 1차적으로 조회하기 위한 뷰
        # 원본 테이블인 users가 먼저 생성되어 있어야 뷰 생성 가능
        drop view if exists members;
        create view members
        as select * from users where userStatus = 'APPROVAL';
        
        # 원본 테이블인 users, members를 먼저 생성해야 관리자 뷰를 생성
        drop view if exists managers;
        create view managers(
            managerId, managerName, managerPwd, managerCode,
            managerPhone, managerEmail, managerImgPath,
            managerHireDate, managerLastLogin, managerRole, managerStatus
        )
        as select
               userId, userName, userPwd, userCode,
               userPhone, userEmail, userImgPath,
               userJoinDate, userLastLogin, userRole,userStatus
        from members
        where userRole in ('MANAGER', 'ADMIN');
        
        # 원본 테이블인 users와 members를 먼저 생성해야 거래처 뷰를 정상적으로 생성
        drop table if exists companies;
        create view companies(
            comId, comName, comCeoName, comPwd, comPhone,
            comEmail, comCode, comRoadAddr, comDetailAddr, comImgPath,
            comStartDate, comExpiredDate, comLastLogin, comStatus
        )
        as select
               userId, userCompanyName, userName, userPwd, userPhone,
               userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath,
               userJoinDate, date_add(userJoinDate, interval 1 year), userLastLogin, userStatus
           from members
        where userRole = 'COMPANY';
        
        # 원본 테이블인 users와 members, vehicles를 먼저 생성해야 배송기사 뷰를 생성
        drop view if exists deliverymen;
        create view deliverymen (
            delivId, delivName, delivPwd, delivPhone,
            delivCode, delivImgPath, delivVhcId, delivVhcModel,
            delivStatus, delivLastLogin
        ) as select
         u.userId, u.userName, u.userPwd, u.userPhone,
         u.userCode, u.userImgPath, v.vehicleId, v.vehicleModel,
         u.userStatus, u.userLastLogin
        from members u join vehicles v on u.vehicleId = v.vehicleId
        where userRole = 'DELIVERYMAN';
        ```
  </details>

## 휴면회원 일괄 전환 기능 도입

- 회원 리스트 기능에서 여러 명의 장기 미접속 회원을 휴면 회원으로 전환하려면 개별적으로 해당 작업을 수행해야 한다는 점에서 비효율적이므로, 이를 개선하기 위해 휴면회원 일괄 전환 기능을 수행할 수 있는 UI를
  추가하거나, DB의 이벤트 스케줄러를 활용하여 특정 시점마다 자동으로 전환하는 방식을 도입할 계획입니다.