<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>직업 이상형 월드컵</title>
  <style>
    body {
      background-color: #000;
      color: white;
      font-family: 'Noto Sans KR', sans-serif;
      text-align: center;
    }
    .title {
      margin-top: 30px;
      font-size: 28px;
    }
    .match-container {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 40px;
      margin-top: 50px;
    }
    .match-btn {
      width: 280px;
      height: 160px;
      font-size: 20px;
      font-weight: bold;
      border: 2px solid #A983A3;
      border-radius: 12px;
      background-color: #1a1a1a;
      color: #fff;
      cursor: pointer;
      transition: transform 0.2s ease;
    }
    .match-btn:hover {
      transform: scale(1.05);
      background-color: #333;
    }
    .round-info {
      font-size: 18px;
      margin-top: 20px;
      color: #ccc;
    }
  </style>
</head>
<body>
  <div class="title">직업 이상형 월드컵</div>
  <div class="round-info" id="roundInfo">32강</div>

  <div class="match-container">
    <button id="left" class="match-btn" onclick="choose('left')"></button>
    <span style="font-size: 20px;">VS</span>
    <button id="right" class="match-btn" onclick="choose('right')"></button>
  </div>

  <script>
    // 예시용 직업 목록 (Controller에서 model에 담아 넘길 수 있음)
    const allJobs = ${jobListJson}; // 예: jobListJson은 400개 직업 JSON 문자열

    let roundJobs = shuffleArray(allJobs).slice(0, 32);
    let nextRound = [];
    let currentIndex = 0;

    function shuffleArray(arr) {
      return arr.map(value => ({ value, sort: Math.random() }))
                .sort((a, b) => a.sort - b.sort)
                .map(({ value }) => value);
    }

    function showMatch() {
      if (roundJobs.length === 1) {
        document.querySelector('.title').innerText = `🏆 우승: ${roundJobs[0].jobName}`;
        document.querySelector('.match-container').style.display = 'none';
        document.getElementById("roundInfo").style.display = 'none';
        return;
      }

      const left = roundJobs[currentIndex];
      const right = roundJobs[currentIndex + 1];

      document.getElementById("left").innerText = left.jobName;
      document.getElementById("left").dataset.value = JSON.stringify(left);
      document.getElementById("right").innerText = right.jobName;
      document.getElementById("right").dataset.value = JSON.stringify(right);

      document.getElementById("roundInfo").innerText = `${roundJobs.length}강 ${currentIndex/2 + 1} / ${roundJobs.length / 2}`;
    }

    function choose(side) {
      const chosen = JSON.parse(document.getElementById(side).dataset.value);
      nextRound.push(chosen);
      currentIndex += 2;

      if (currentIndex >= roundJobs.length) {
        roundJobs = nextRound;
        nextRound = [];
        currentIndex = 0;
      }

      showMatch();
    }

    window.onload = showMatch;
  </script>
</body>
</html>