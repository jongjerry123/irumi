package com.project.irumi.common;

import java.util.Arrays;

public class Search implements java.io.Serializable {
	
	private static final long serialVersionUID = 2958209360488257355L;
	private String keyword;  //제목, 내용, 아이디 (작성자, 회원) 검색 키워드
	private String[] type;
	private int startRow;    //한 페이지에 출력할 목록의 시작행
	private int endRow;     //한 페이지에 출력할 목록의 끝행
	
	public Search() {
		super();
	}



	public Search(String keyword, String[] type, int startRow, int endRow) {
		super();
		this.keyword = keyword;
		this.type = type;
		this.startRow = startRow;
		this.endRow = endRow;
	}



	public String[] getType() {
		return type;
	}



	public void setType(String[] type) {
		this.type = type;
	}



	public static long getSerialversionuid() {
		return serialVersionUID;
	}


	//getters and setters
	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}



	@Override
	public String toString() {
		return "Search [keyword=" + keyword + ", type=" + Arrays.toString(type) + ", startRow=" + startRow + ", endRow="
				+ endRow + "]";
	}


	

	

	
}
