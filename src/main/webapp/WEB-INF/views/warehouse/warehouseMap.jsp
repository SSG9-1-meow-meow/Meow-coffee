<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/_headerHead.jsp" %>
.select-filter {
width: 50%;
margin: 1rem auto;
}

.custom-nav {
border-bottom: 2px solid #000; /* 전체 하단 검은 선 */
padding-bottom: 0;
}

.custom-nav .nav-link {
color: #111;
font-size: 1.1rem;
font-weight: 500;
padding: 0.8rem 2rem;
position: relative;
text-align: center;
}

.custom-nav .nav-link:hover {
color: #000;
}

.custom-nav .nav-link.active {
font-weight: 600;
}

.custom-nav .nav-link.active::after {
content: "";
position: absolute;
bottom: -2px;
left: 0;
right: 0;
height: 3px;
background-color: #000;
}
<%@include file="/WEB-INF/views/includes/_headerNav.jsp"%>
<nav class="navbar navbar-expand-lg navbar-dark mb-4 py-2 custom-nav">
    <div class="container-fluid">
        <button
                class="navbar-toggler ms-auto"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#newNavbar"
                aria-controls="newNavbar"
                aria-expanded="false"
                aria-label="Toggle navigation"
        >
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="newNavbar">
            <ul class="navbar-nav w-100 nav-justified mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/warehouses">창고 조회</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fs-5" href="/warehouses/map">지도 보기</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<%--  카카오 API 띄우기 위한 키--%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=36b4847e34edaa397a3e4572992e270e&libraries=services"></script>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <h4 class="card-title">창고 위치 현황</h4>
            </div>
            <div class="card-body d-flex justify-content-center">
                <div id="map" style="width: 70%; height: 45rem"></div>
                <div id="explanation" style="width: 6rem; height: 6rem; border: 1px solid rgb(0,0,0); margin-left: 1rem; border-radius: 5px; padding: 1px">
                    <p><img src="/resources/components/blueMarker.png" style="width: 2rem; height: 2rem;"/>MAIN</p>
                    <p><img src="/resources/components/greenMarker.png" style="width: 2rem; height: 2rem;"/>SUB</p>
                    <p></p>
                </div>
            </div>

            <div class="card-footer d-flex justify-content-center align-items-center">

<%--                <button class="btn btn-outline-primary me-2" id="btnEdit">수정하기</button>--%>
<%--                <button class="btn btn-outline-danger me-2" id="btnDelete">삭제하기</button>--%>

<%--                <button class="btn btn-outline-dark" id="btnList">리스트로</button>--%>

            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/views/includes/_footerHead.jsp"%>
document.addEventListener("DOMContentLoaded", async () => {
try {
const response = await axios.get("/api/warehouses/search");

// fullAddressList만 꺼내기
const fullAddressList = response.data.fullAddressList;


var mapContainer = document.getElementById('map'), // 지도를 표시할 div
mapOption = {
center: new kakao.maps.LatLng(35.8999, 128), // 지도의 중심좌표
level: 13 // 지도의 확대 레벨
};
// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
var map = new kakao.maps.Map(mapContainer, mapOption);

var mapTypeControl = new kakao.maps.MapTypeControl();

// 지도에 컨트롤을 추가해야 지도위에 표시됩니다
// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
var zoomControl = new kakao.maps.ZoomControl();
map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);;

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

for (const wh of fullAddressList) {
if (!wh.whAddress) continue;

console.log(wh.whCode, wh.whName, wh.whGrade);

geocoder.addressSearch(wh.whAddress, function(result, status) {
if (status === kakao.maps.services.Status.OK) {
var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

let markerOptions = {
map: map,
position: coords,
clickable: true
};

var imageSrc;

//메인 창고는 초록색 서브 창고는 파란색
if (wh.whGrade === "main") {
imageSrc = "/resources/components/blueMarker.png";
} else{
imageSrc = "/resources/components/greenMarker.png";
}

var imageSize = new kakao.maps.Size(30, 38); // 이미지 크기
var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
markerOptions.image = markerImage;

var marker = new kakao.maps.Marker(markerOptions);

// 인포윈도우 내용 (whCode, whName, whGrade)
var iwContent = '<div style="padding:12px; font-size:13px; width: 180px">' +
'<b>'+ wh.whName+'</b> ' +  '<br/>' +
'창고코드: ' + '<b>'+wh.whCode+'</b>' +'<br/>' +
'창고등급: ' + '<b>'+wh.whGrade+'</b>' +'<br/>' +
'사용용량/최대용량: ' + '<b>'+ wh.whUseCapa+ '/'+ wh.whTotalCapa+ '</b>'+
'</div>';

var infowindow = new kakao.maps.InfoWindow({
content: iwContent,
removable: true
});

// 마커 클릭 시 인포윈도우 열기
kakao.maps.event.addListener(marker, 'click', function() {
infowindow.open(map, marker);
});
}
});
}
}catch(error) {
console.error(error);
alert("주소를 불러오지 못했습니다.");
}

});
<%@include file="/WEB-INF/views/includes/_footerTail.jsp"%>