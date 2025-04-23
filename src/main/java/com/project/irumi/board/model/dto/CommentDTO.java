package com.project.irumi.board.model.dto;

import java.time.LocalDateTime;

public class CommentDTO {
    private Long comId;
    private String comWrId;
    private Long postId;
    private Long comParentId;
    private String comContent;
    private LocalDateTime comTime;
    private int comRecommend;
    private int comReportCount;

    public CommentDTO() {}

    public CommentDTO(Long comId, String comWrId, Long postId, Long comParentId, String comContent,
                      LocalDateTime comTime, int comRecommend, int comReportCount) {
        this.comId = comId;
        this.comWrId = comWrId;
        this.postId = postId;
        this.comParentId = comParentId;
        this.comContent = comContent;
        this.comTime = comTime;
        this.comRecommend = comRecommend;
        this.comReportCount = comReportCount;
    }

    public Long getComId() { return comId; }
    public void setComId(Long comId) { this.comId = comId; }

    public String getComWrId() { return comWrId; }
    public void setComWrId(String comWrId) { this.comWrId = comWrId; }

    public Long getPostId() { return postId; }
    public void setPostId(Long postId) { this.postId = postId; }

    public Long getComParentId() { return comParentId; }
    public void setComParentId(Long comParentId) { this.comParentId = comParentId; }

    public String getComContent() { return comContent; }
    public void setComContent(String comContent) { this.comContent = comContent; }

    public LocalDateTime getComTime() { return comTime; }
    public void setComTime(LocalDateTime comTime) { this.comTime = comTime; }

    public int getComRecommend() { return comRecommend; }
    public void setComRecommend(int comRecommend) { this.comRecommend = comRecommend; }

    public int getComReportCount() { return comReportCount; }
    public void setComReportCount(int comReportCount) { this.comReportCount = comReportCount; }

    @Override
    public String toString() {
        return "CommentDTO{" +
                "comId=" + comId +
                ", comWrId='" + comWrId + '\'' +
                ", postId=" + postId +
                ", comParentId=" + comParentId +
                ", comContent='" + comContent + '\'' +
                ", comTime=" + comTime +
                ", comRecommend=" + comRecommend +
                ", comReportCount=" + comReportCount +
                '}';
    }
}
