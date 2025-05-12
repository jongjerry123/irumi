<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 맨 위로 버튼 -->
<div id="backToTopBtn" onclick="scrollToTop()">▲ TOP</div>

<style>
  #backToTopBtn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    background-color: #222;
    color: #fff;
    padding: 10px 16px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: bold;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
    cursor: pointer;
    opacity: 0.7;
    z-index: 9999;
    display: none; /* 처음엔 숨김 */
    transition: all 0.3s ease;
  }

  #backToTopBtn:hover {
    background-color: #555;
    color: #000;
    opacity: 1;
    transform: translateY(-2px);
  }
</style>

<script>
  function scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  window.addEventListener("scroll", function () {
    const btn = document.getElementById("backToTopBtn");
    if (window.scrollY > 100) {
      btn.style.display = "block";
    } else {
      btn.style.display = "none";
    }
  });
</script>