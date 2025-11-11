<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <title>냥냥 커피 WMS 시스템</title>
  <meta
      content="width=device-width, initial-scale=1.0, shrink-to-fit=no"
      name="viewport"
  />
  <link
      rel="icon"
      href="/resources/assets/img/meow/favicon.ico"
      type="image/x-icon"
  />

  <!-- Fonts and icons -->
  <script src="/resources/assets/js/plugin/webfont/webfont.min.js"></script>
  <script>
      WebFont.load({
          google: {families: ["Public Sans:300,400,500,600,700"]},
          custom: {
              families: [
                  "Font Awesome 5 Solid",
                  "Font Awesome 5 Regular",
                  "Font Awesome 5 Brands",
                  "simple-line-icons",
              ],
              urls: ["/resources/assets/css/fonts.min.css"],
          },
          active: function () {
              sessionStorage.fonts = true;
          },
      });
  </script>

  <!-- CSS Files -->
  <link rel="stylesheet" href="/resources/assets/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="/resources/assets/css/plugins.min.css"/>
  <link rel="stylesheet" href="/resources/assets/css/kaiadmin.min.css"/>

  <!-- CSS Just for demo purpose -->
  <link rel="stylesheet" href="/resources/assets/css/demo.css" />

  <style>
      /* Sidebar 제거에 따른 전체 폭 사용 */
      .main-panel {
          width: 100%;
          margin-left: 0 !important;
      }

      .wrapper {
          padding-left: 0 !important;
      }
  /*    인라인 스타일링 필요 시 include */
