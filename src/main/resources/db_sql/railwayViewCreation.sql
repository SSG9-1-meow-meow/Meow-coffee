# 원본 테이블인 users를 먼저 생성해야 관리자 뷰를 생성할 수 있습니다.
# erdcloud에서 생성된 sql문의 create table managers ~ 대신 아래의 create view문을 사용
# 로그인/회원관리 기능 제외 WMS의 다른 기능이 창고관리자/총관리자를 조회할 때는 아래 뷰를 사용

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
   from users
   where userStatus = 'APPROVAL' and userRole in ('MANAGER', 'ADMIN');


# 원본 테이블인 users를 먼저 생성해야 거래처 뷰를 정상적으로 생성할 수 있습니다.
# erdcloud의 sql문에서 create table companies ~ 대신 아래의 create view문을 사용
# 로그인/회원관리 기능을 제외한 WMS의 다른 기능이 거래처를 조회할 때는 아래의 뷰를 사용
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
   from users
   where userStatus = 'APPROVAL' and userRole = 'COMPANY';

# 원본 테이블인 users와 vehicles를 먼저 생성하셔야 배송기사 뷰를 생성할 수 있습니다.
# erdcloud의 sql문에서 create table companies ~ 대신 아래의 create view문을 사용
# 로그인/회원관리 기능을 제외한 WMS의 다른 기능이 배송기사를 조회할 때는 아래의 뷰를 사용

drop view if exists deliverymen;
create view deliverymen (
                         delivId, delivName, delivPwd, delivPhone, delivEmail,
                         delivCode, delivImgPath, delivVhcId, delivVhcModel,
                         delivStatus, delivLastLogin
    ) as select
             u.userId, u.userName, u.userPwd, u.userPhone, u.userEmail,
             u.userCode, u.userImgPath, v.vehicleId, v.vehicleModel,
             u.userStatus, u.userLastLogin
         from users u join vehicles v on u.vehicleId = v.vehicleId
         where userStatus = 'APPROVAL' and userRole = 'DELIVERYMAN';