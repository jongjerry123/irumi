<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    .stage-select {
      margin-top: 30px;
    }
    select, button.start-btn {
      padding: 8px 14px;
      font-size: 16px;
      background-color: #222;
      color: white;
      border: 1px solid #A983A3;
      border-radius: 8px;
      margin: 5px;
      cursor: pointer;
    }
    .round-info {
      font-size: 18px;
      margin-top: 20px;
      color: #ccc;
    }
    .match-container {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 40px;
      margin-top: 40px;
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
      transition: transform 0.3s ease, background-color 0.2s;
    }
    .match-btn:hover {
      transform: scale(1.05);
      background-color: #333;
    }
    .slide-up {
      animation: slideUp 0.4s ease forwards;
    }
    @keyframes slideUp {
      0% { transform: translateY(0); opacity: 1; }
      100% { transform: translateY(-100px); opacity: 0; }
    }
  </style>
</head>
<body>
<c:import url="/WEB-INF/views/common/header.jsp" />
  <div class="title">직업 이상형 월드컵</div>

  <div class="stage-select" id="stageControl">
    <label for="stageCount">시작 라운드: </label>
    <select id="stageCount">
      <option value="32">32강</option>
      <option value="64">64강</option>
      <option value="128">128강</option>
    </select>
    <button class="start-btn" id="startBtn">시작하기</button>
  </div>

  <div class="round-info" id="roundInfo" style="display:none;"></div>

  <div class="match-container" id="matchContainer" style="display:none;">
    <button id="left" class="match-btn" onclick="choose('left')"></button>
    <span style="font-size: 20px;">VS</span>
    <button id="right" class="match-btn" onclick="choose('right')"></button>
  </div>

  <!-- JSON 직업 데이터 삽입 -->
  <script id="jobData" type="application/json">
    ${jobListJson}
  </script>

  <script>
    let allJobs = [];
    let roundJobs = [], nextRound = [], currentIndex = 0, totalStage = 0;

    document.addEventListener("DOMContentLoaded", function () {
      try {
        allJobs = JSON.parse(document.getElementById("jobData").textContent.trim());
      } catch (e) {
        alert("직업 데이터를 불러오지 못했습니다.");
        return;
      }

      document.getElementById("startBtn").addEventListener("click", startTournament);
    });

    function shuffleArray(arr) {
      return arr.map(v => ({ v, r: Math.random() }))
                .sort((a, b) => a.r - b.r)
                .map(({ v }) => v);
    }

    function startTournament() {
      const selected = parseInt(document.getElementById("stageCount").value);
      if (allJobs.length < selected) {
        alert("직업 데이터가 부족합니다.");
        return;
      }

      roundJobs = shuffleArray(allJobs).slice(0, selected);
      nextRound = [];
      currentIndex = 0;
      totalStage = selected;

      document.getElementById("stageControl").style.display = "none";
      document.getElementById("matchContainer").style.display = "flex";
      document.getElementById("roundInfo").style.display = "block";

      showMatch();
    }

    function showMatch() {
      if (roundJobs.length === 1) {
        document.querySelector(".title").innerText = `🏆 우승: ${roundJobs[0].jobName}`;
        document.getElementById("matchContainer").style.display = "none";
        document.getElementById("roundInfo").style.display = "none";
        return;
      }

      const left = roundJobs[currentIndex];
      const right = roundJobs[currentIndex + 1];

      document.getElementById("left").innerText = left.jobName;
      document.getElementById("right").innerText = right.jobName;
      document.getElementById("left").dataset.value = JSON.stringify(left);
      document.getElementById("right").dataset.value = JSON.stringify(right);

      const currentRound = roundJobs.length;
      const matchNumber = Math.floor(currentIndex / 2) + 1;
      const totalMatches = Math.floor(currentRound / 2);
      document.getElementById("roundInfo").innerText = `${currentRound}강 - ${matchNumber} / ${totalMatches}`;
    }

    function choose(side) {
      const chosenBtn = document.getElementById(side);
      chosenBtn.classList.add("slide-up");

      setTimeout(() => {
        const chosen = JSON.parse(chosenBtn.dataset.value);
        nextRound.push(chosen);
        currentIndex += 2;
        chosenBtn.classList.remove("slide-up");

        if (currentIndex >= roundJobs.length) {
          roundJobs = nextRound;
          nextRound = [];
          currentIndex = 0;
        }

        showMatch();
      }, 400);
    }
  </script>
</body>
</html>