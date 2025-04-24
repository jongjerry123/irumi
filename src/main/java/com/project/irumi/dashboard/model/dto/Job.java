package com.project.irumi.dashboard.model.dto;

public class Job implements java.io.Serializable {
	
	private static final long serialVersionUID = -8308408613355781814L;
	private String jobId;
	private String jobExplain;
	private String jobName;
	
	public Job() {
		super();
	}
	
	public Job(String jobId, String jobExplain, String jobName) {
		super();
		this.jobId = jobId;
		this.jobExplain = jobExplain;
		this.jobName = jobName;
	}

	public String getJobId() {
		return jobId;
	}

	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public String getJobExplain() {
		return jobExplain;
	}

	public void setJobExplain(String jobExplain) {
		this.jobExplain = jobExplain;
	}

	public String getJobName() {
		return jobName;
	}

	public void setJobName(String jobName) {
		this.jobName = jobName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "Job [jobId=" + jobId + ", jobExplain=" + jobExplain + ", jobName=" + jobName + "]";
	}
	
}
