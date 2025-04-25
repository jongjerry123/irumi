package com.project.irumi.dashboard.model.dto;

public class Specific implements java.io.Serializable {

	private static final long serialVersionUID = -1767230312561089097L;
	private String userId;
	private String jobId;
	private String specId;
	private String actId;
	
	public Specific() {
		super();
	}

	public Specific(String userId, String jobId, String specId, String actId) {
		super();
		this.userId = userId;
		this.jobId = jobId;
		this.specId = specId;
		this.actId = actId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getJobId() {
		return jobId;
	}

	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public String getSpecId() {
		return specId;
	}

	public void setSpecId(String specId) {
		this.specId = specId;
	}

	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "Specific [userId=" + userId + ", jobId=" + jobId + ", specId=" + specId + ", actId=" + actId + "]";
	}

}
