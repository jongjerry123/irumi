package com.project.irumi.chatbot.model.dto;

import java.sql.Date;

public class ChatMsg implements java.io.Serializable {

	private static final long serialVersionUID = -8536063013979132015L;
	private String msgId;
	private String userId;
	private String convId;
	private String convTopic;
	private String convSubTopic;
	private String msgContent;
	private Date msgTime;
	
	public ChatMsg() {
		super();
	}
	
	public ChatMsg(String msgId, String userId, String convId, String convTopic, String convSubTopic, String msgContent,
			Date msgTime) {
		super();
		this.msgId = msgId;
		this.userId = userId;
		this.convId = convId;
		this.convTopic = convTopic;
		this.convSubTopic = convSubTopic;
		this.msgContent = msgContent;
		this.msgTime = msgTime;
	}
	public String getMsgId() {
		return msgId;
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
	public String getConvSubTopic() {
		return convSubTopic;
	}
	public void setConvSubTopic(String convSubTopic) {
		this.convSubTopic = convSubTopic;
	}
	public String getMsgContent() {
		return msgContent;
	}
	public void setMsgContent(String msgContent) {
		this.msgContent = msgContent;
	}
	public Date getMsgTime() {
		return msgTime;
	}
	public void setMsgTime(Date msgTime) {
		this.msgTime = msgTime;
	}

	@Override
	public String toString() {
		return "ChatMsg [msgId=" + msgId + ", userId=" + userId + ", convId=" + convId + ", convTopic=" + convTopic
				+ ", convSubTopic=" + convSubTopic + ", msgContent=" + msgContent + ", msgTime=" + msgTime + "]";
	}
	
	
	
}
