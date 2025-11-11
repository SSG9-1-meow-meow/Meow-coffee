<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

$("#lineChart").sparkline([102, 109, 120, 99, 110, 105, 115], {
type: "line",
height: "70",
width: "100%",
lineWidth: "2",
lineColor: "#177dff",
fillColor: "rgba(23, 125, 255, 0.14)",
});

// ... 나머지 인라인 스크립트 ...
</script>
</body>
</html>
<!-- _footer.jsp 종료 -->