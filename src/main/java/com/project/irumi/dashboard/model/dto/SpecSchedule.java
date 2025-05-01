package com.project.irumi.dashboard.model.dto;

import java.sql.Date;

public class SpecSchedule implements java.io.Serializable {

	private static final long serialVersionUID = -598248087542729698L;
	private String ssId;
	private String specId;
	private String ssType;
	private Date ssDate;
	
	public SpecSchedule() {
		super();
	}

	public SpecSchedule(String ssId, String specId, String ssType, Date ssDate) {
		super();
		this.ssId = ssId;
		this.specId = specId;
		this.ssType = ssType;
		this.ssDate = ssDate;
	}
	
	public String getSpecId() {
		return specId;
	}

	public String getSsId() {
		return ssId;
	}

	public void setSsId(String ssId) {
		this.ssId = ssId;
	}

	public void setSpecId(String specId) {
		this.specId = specId;
	}

	public String getSsType() {
		return ssType;
	}

	public void setSsType(String ssType) {
		this.ssType = ssType;
	}

	public Date getSsDate() {
		return ssDate;
	}

	public void setSsDate(Date ssDate) {
		this.ssDate = ssDate;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "SpecSchedule [ssId=" + ssId + ", specId=" + specId + ", ssType=" + ssType + ", ssDate=" + ssDate + "]";
	}
	
}
