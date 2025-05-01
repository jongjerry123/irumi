package com.project.irumi.chatbot.model.dto;

import java.util.List;

import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.Spec;

public class SessionTopicOpts {
	private List<CareerItemDto> jobList;
    private List<CareerItemDto> specList;  // 예시로 스펙 클래스
    
	public List<CareerItemDto> getJobList() {
		return jobList;
	}
	public void setJobList(List<CareerItemDto> jobList) {
		this.jobList = jobList;
	}
	public List<CareerItemDto> getSpecList() {
		return specList;
	}
	public void setSpecList(List<CareerItemDto> specList) {
		this.specList = specList;
	}
    
    
}
