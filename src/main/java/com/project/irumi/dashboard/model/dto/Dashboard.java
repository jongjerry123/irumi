package com.project.irumi.dashboard.model.dto;

public class Dashboard implements java.io.Serializable {
	
	private static final long serialVersionUID = -8470789168126716637L;
	private String userUniversity;
	private String userDegree;
	private String userGraduate;
	private double userPoint;
	
	public Dashboard() {
		super();
	}
	
	public Dashboard(String userUniversity, String userDegree, String userGraduate, double userPoint) {
		super();
		this.userUniversity = userUniversity;
		this.userDegree = userDegree;
		this.userGraduate = userGraduate;
		this.userPoint = userPoint;
	}
	
	public String getUserUniversity() {
		return userUniversity;
	}
	public void setUserUniversity(String userUniversity) {
		this.userUniversity = userUniversity;
	}
	public String getUserDegree() {
		return userDegree;
	}
	public void setUserDegree(String userDegree) {
		this.userDegree = userDegree;
	}
	public String getUserGraduate() {
		return userGraduate;
	}
	public void setUserGraduate(String userGraduate) {
		this.userGraduate = userGraduate;
	}
	public double getUserPoint() {
		return userPoint;
	}
	public void setUserPoint(double userPoint) {
		this.userPoint = userPoint;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	@Override
	public String toString() {
		return "Dashboard [userUniversity=" + userUniversity + ", userDegree=" + userDegree + ", userGraduate="
				+ userGraduate + ", userPoint=" + userPoint + "]";
	}

}
