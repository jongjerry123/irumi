package com.project.irumi.dashboard.model.dto;

public class JobList implements java.io.Serializable {

	private static final long serialVersionUID = 5310891836311572557L;
	private String jobListId;
	private String jobName;
	private String jobType;
	private String jobExplain;
	
	public JobList() {
		super();
	}

	public JobList(String jobListId, String jobName, String jobType, String jobExplain) {
		super();
		this.jobListId = jobListId;
		this.jobName = jobName;
		this.jobType = jobType;
		this.jobExplain = jobExplain;
	}

	public String getJobListId() {
		return jobListId;
	}

	public void setJobListId(String jobListId) {
		this.jobListId = jobListId;
	}

	public String getJobName() {
		return jobName;
	}

	public void setJobName(String jobName) {
		this.jobName = jobName;
	}

	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}

	public String getJobExplain() {
		return jobExplain;
	}

	public void setJobExplain(String jobExplain) {
		this.jobExplain = jobExplain;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "JobList [jobListId=" + jobListId + ", jobName=" + jobName + ", jobType=" + jobType + ", jobExplain="
				+ jobExplain + "]";
	}

}
