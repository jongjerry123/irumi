package com.project.irumi.board.dto;

// CommentReportDTO.java
import java.sql.Timestamp;

public class CommentReportDTO {
    private Long reportId;
    private Long targetId;
    private String reportReason;
    private String reportedBy;
    private Timestamp reportDate;

    public CommentReportDTO() {}

    public CommentReportDTO(Long reportId, Long targetId, String reportReason, String reportedBy, Timestamp reportDate) {
        this.reportId = reportId;
        this.targetId = targetId;
        this.reportReason = reportReason;
        this.reportedBy = reportedBy;
        this.reportDate = reportDate;
    }

    public Long getReportId() { return reportId; }
    public void setReportId(Long reportId) { this.reportId = reportId; }

    public Long getTargetId() { return targetId; }
    public void setTargetId(Long targetId) { this.targetId = targetId; }

    public String getReportReason() { return reportReason; }
    public void setReportReason(String reportReason) { this.reportReason = reportReason; }

    public String getReportedBy() { return reportedBy; }
    public void setReportedBy(String reportedBy) { this.reportedBy = reportedBy; }

    public Timestamp getReportDate() { return reportDate; }
    public void setReportDate(Timestamp reportDate) { this.reportDate = reportDate; }

    @Override
    public String toString() {
        return "CommentReportDTO{" +
                "reportId=" + reportId +
                ", targetId=" + targetId +
                ", reportReason='" + reportReason + '\'' +
                ", reportedBy='" + reportedBy + '\'' +
                ", reportDate=" + reportDate +
                '}';
    }
}