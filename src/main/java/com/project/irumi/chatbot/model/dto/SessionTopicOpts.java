package com.project.irumi.chatbot.model.dto;

import java.util.List;

import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.Spec;

public class SessionTopicOpts {
	private List<Job> jobList;
    private List<Spec> specList;  // 예시로 스펙 클래스
    
	public List<Job> getJobList() {
		return jobList;
	}
	public void setJobList(List<Job> jobList) {
		this.jobList = jobList;
	}
	public List<Spec> getSpecList() {
		return specList;
	}
	public void setSpecList(List<Spec> specList) {
		this.specList = specList;
	}
    
    
}
