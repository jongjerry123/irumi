package com.project.irumi.chatbot.model.dto;

import java.util.List;

import com.project.irumi.dashboard.model.dto.Job;
import com.project.irumi.dashboard.model.dto.Spec;

public class TopicOptsDTO {
	private List<CareerItemDTO> jobList;
    private List<CareerItemDTO> specList;  
    
	public List<CareerItemDTO> getJobList() {
		return jobList;
	}
	public void setJobList(List<CareerItemDTO> jobList) {
		this.jobList = jobList;
	}
	public List<CareerItemDTO> getSpecList() {
		return specList;
	}
	public void setSpecList(List<CareerItemDTO> specList) {
		this.specList = specList;
	}
    
    
}
