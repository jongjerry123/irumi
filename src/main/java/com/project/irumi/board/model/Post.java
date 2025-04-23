package com.project.irumi.board.model;

public class Post {
    private Long postId;
    private String postWriter;
    private String postTitle;
    private String postTime;
    private String postType;

    public Post() {}

    public Post(Long postId, String postWriter, String postTitle, String postTime, String postType) {
        this.postId = postId;
        this.postWriter = postWriter;
        this.postTitle = postTitle;
        this.postTime = postTime;
        this.postType = postType;
    }

    public Long getPostId() {
        return postId;
    }

    public void setPostId(Long postId) {
        this.postId = postId;
    }

    public String getPostWriter() {
        return postWriter;
    }

    public void setPostWriter(String postWriter) {
        this.postWriter = postWriter;
    }

    public String getPostTitle() {
        return postTitle;
    }

    public void setPostTitle(String postTitle) {
        this.postTitle = postTitle;
    }

    public String getPostTime() {
        return postTime;
    }

    public void setPostTime(String postTime) {
        this.postTime = postTime;
    }

    public String getPostType() {
        return postType;
    }

    public void setPostType(String postType) {
        this.postType = postType;
    }
}