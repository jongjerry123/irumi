package com.project.irumi.board.model.dto;

import java.time.LocalDateTime;

public class PostDTO {
    private Long postId;
    private String postWriter;
    private String postType;
    private String postTitle;
    private String postContent;
    private LocalDateTime postTime;
    private int postViewCount;
    private int postReportCount;
    private int postRecommend;
    private String postSavedName;
    private String postOriginalName;

    public PostDTO() {}

    public PostDTO(Long postId, String postWriter, String postType, String postTitle, String postContent,
                   LocalDateTime postTime, int postViewCount, int postReportCount, int postRecommend,
                   String postSavedName, String postOriginalName) {
        this.postId = postId;
        this.postWriter = postWriter;
        this.postType = postType;
        this.postTitle = postTitle;
        this.postContent = postContent;
        this.postTime = postTime;
        this.postViewCount = postViewCount;
        this.postReportCount = postReportCount;
        this.postRecommend = postRecommend;
        this.postSavedName = postSavedName;
        this.postOriginalName = postOriginalName;
    }

    public Long getPostId() { return postId; }
    public void setPostId(Long postId) { this.postId = postId; }

    public String getPostWriter() { return postWriter; }
    public void setPostWriter(String postWriter) { this.postWriter = postWriter; }

    public String getPostType() { return postType; }
    public void setPostType(String postType) { this.postType = postType; }

    public String getPostTitle() { return postTitle; }
    public void setPostTitle(String postTitle) { this.postTitle = postTitle; }

    public String getPostContent() { return postContent; }
    public void setPostContent(String postContent) { this.postContent = postContent; }

    public LocalDateTime getPostTime() { return postTime; }
    public void setPostTime(LocalDateTime postTime) { this.postTime = postTime; }

    public int getPostViewCount() { return postViewCount; }
    public void setPostViewCount(int postViewCount) { this.postViewCount = postViewCount; }

    public int getPostReportCount() { return postReportCount; }
    public void setPostReportCount(int postReportCount) { this.postReportCount = postReportCount; }

    public int getPostRecommend() { return postRecommend; }
    public void setPostRecommend(int postRecommend) { this.postRecommend = postRecommend; }

    public String getPostSavedName() { return postSavedName; }
    public void setPostSavedName(String postSavedName) { this.postSavedName = postSavedName; }

    public String getPostOriginalName() { return postOriginalName; }
    public void setPostOriginalName(String postOriginalName) { this.postOriginalName = postOriginalName; }

    @Override
    public String toString() {
        return "PostDTO{" +
                "postId=" + postId +
                ", postWriter='" + postWriter + '\'' +
                ", postType='" + postType + '\'' +
                ", postTitle='" + postTitle + '\'' +
                ", postContent='" + postContent + '\'' +
                ", postTime=" + postTime +
                ", postViewCount=" + postViewCount +
                ", postReportCount=" + postReportCount +
                ", postRecommend=" + postRecommend +
                ", postSavedName='" + postSavedName + '\'' +
                ", postOriginalName='" + postOriginalName + '\'' +
                '}';
    }
}