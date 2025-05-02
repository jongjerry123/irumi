package com.project.irumi.chatbot.model.dto;

import java.sql.Date;

/*
 * 
다양한 타입(job, spec, act, ss)을 하나의 형태로 묶어서 프론트에 전달
프론트에서는 title, content, type만 있으면 어떤 항목이든 UI에 표현 가능
서버에서는 topic에 따라 CareerItemDto로 추상화해서 응답
 * 
 */
public class CareerItemDto {
	private String itemId; // jobId, specId, actId, ssId 등 (선택적으로 사용)
	private String pId;   // 추가  
	private String title; // 화면에 표시할 이름
	private String explain; // 상세 내용, 설명 등
	private String type; // "job", "spec", "act", "ss"
	private Date schedule;
	private String state;

	public CareerItemDto() {
	}

	public CareerItemDto(String itemId, String title, String content, String explain) {
		this.itemId = null;
		this.title = title;
		this.explain = explain;
		this.type = null;
	}
	
	public CareerItemDto(String itemId, String pId, String explain, Date ssDate) {
		this.itemId = null;
		this.pId = null;
		this.explain = explain;
		this.schedule = ssDate;
		this.type = null;
	}
	
	public CareerItemDto(String itemId, String title, String state) {
		this.itemId = null;
		this.title = title;
		this.state = "N";
		this.type = null;
	}

	// Getter & Setter
	public String getItemId() {
		return itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getExplain() {
		return explain;
	}

	public void setExplain(String explain) {
		this.explain = explain;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Date getSchedule() {
		return schedule;
	}

	public void setSchedule(Date schedule) {
		this.schedule = schedule;
	}

	public String getpId() {
		return pId;
	}

	public void setpId(String pId) {
		this.pId = pId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}
	

}
