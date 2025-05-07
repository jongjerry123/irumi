package com.project.irumi.chatbot.model.dto;

import java.sql.Date;
import java.sql.Timestamp;

public class ChatMsg implements java.io.Serializable {

	private static final long serialVersionUID = -8536063013979132015L;
	private String msgId;
	

	public String getMsgId() {
		return msgId;
	}
	
	public ChatMsg() {}
	
	public ChatMsg(String userId, String convId, String convTopic, String convSubTopicJobId, String role) {
		super();
		this.userId = userId;
		this.convId = convId;
		this.convTopic = convTopic;
		this.convSubTopicJobId = convSubTopicJobId;
		this.role = role;
	}
	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getConvId() {
		return convId;
	}
	public void setConvId(String convId) {
		this.convId = convId;
	}
	public String getConvTopic() {
		return convTopic;
	}
	public void setConvTopic(String convTopic) {
		this.convTopic = convTopic;
	}
	public String getConvSubTopicJobId() {
		return convSubTopicJobId;
	}
	public void setConvSubTopicJobId(String convSubTopicJobId) {
		this.convSubTopicJobId = convSubTopicJobId;
	}
	public String getConvSubTopicSpecId() {
		return convSubTopicSpecId;
	}
	public void setConvSubTopicSpecId(String convSubTopicSpecId) {
		this.convSubTopicSpecId = convSubTopicSpecId;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getMsgContent() {
		return msgContent;
	}
	public void setMsgContent(String msgContent) {
		this.msgContent = msgContent;
	}
	public Timestamp getMsgTime() {
		return msgTime;
	}
	public void setMsgTime(Timestamp msgTime) {
		this.msgTime = msgTime;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String userId;
	private String convId;
	private String convTopic;
	private String convSubTopicJobId;
	private String convSubTopicSpecId;
	private String role;
	private String msgContent;
	private Timestamp msgTime;
	
	
	
	
	
}
