package com.project.irumi;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component
@PropertySource("classpath:application.properties")
public class JobListInserter {

    // Oracle DB 연결 정보
    private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:xe"; // 실제 DB URL로 변경
    private static final String DB_USER = "c##irumi"; // 실제 사용자명으로 변경
    private static final String DB_PASSWORD = "irumi"; // 실제 비밀번호로 변경

    private static String jobApi = "1335ded918216a532600e25314a6e428";

	// 커리어넷 오픈 API URL
    private static final String API_URL = "https://www.career.go.kr/cnet/openapi/getOpenApi?apiKey=" + jobApi + "&svcType=api&svcCode=JOB&contentType=json&gubun=job_dic_list&perPage=500"; // 실제 API 키로 변경

    public static void main(String[] args) {
        try {
            // API 호출
            String jsonResponse = fetchApiData(API_URL);
                        
            // JSON 파싱
            JSONObject jsonObject = new JSONObject(jsonResponse);
            JSONArray jobList = jsonObject.getJSONObject("dataSearch").getJSONArray("content");

            // DB 연결
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String sql = "INSERT INTO TB_JOB_LIST (JOB_LIST_ID, JOB_NAME, JOB_TYPE, JOB_EXPLAIN) VALUES (?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    for (int i = 0; i < jobList.length(); i++) {
                        JSONObject job = jobList.getJSONObject(i);
                        pstmt.setString(1, job.getString("jobdicSeq"));
                        pstmt.setString(2, job.getString("job"));
                        pstmt.setString(3, job.getString("profession"));
                        pstmt.setString(4, job.getString("summary"));
                        pstmt.executeUpdate();
                    }
                }
            }

            System.out.println("데이터 삽입 완료");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // API 데이터 가져오기
    private static String fetchApiData(String apiUrl) throws Exception {
        StringBuilder result = new StringBuilder();
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        try (BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            String line;
            while ((line = rd.readLine()) != null) {
                result.append(line);
            }
        }
        return result.toString();
    }
}