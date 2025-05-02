package com.project.irumi.dashboard.model.dto;

public class Activity implements java.io.Serializable {

	private static final long serialVersionUID = 8940489800584224704L;
	private String actId;
	private String actContent;
	private String actState;
	
	public Activity() {
		super();
	}
	
	public Activity(String actContent) {
		super();
		this.actContent = actContent;
	}
	
	public Activity(String actId, String actContent, String actState) {
		super();
		this.actId = actId;
		this.actContent = actContent;
		this.actState = actState;
	}
	
	public Activity(String actId, String actContent) {
		super();
		this.actId = actId;
		this.actContent = actContent;
	}


	public String getActId() {
		return actId;
	}

	public void setActId(String actId) {
		this.actId = actId;
	}

	public String getActContent() {
		return actContent;
	}

	public void setActContent(String actContent) {
		this.actContent = actContent;
	}

	public String getActState() {
		return actState;
	}

	public void setActState(String actState) {
		this.actState = actState;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "Activity [actId=" + actId + ", actContent=" + actContent + ", actState=" + actState + "]";
	}
	
}
