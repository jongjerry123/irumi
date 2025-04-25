package com.project.irumi.dashboard.model.dto;

public class Spec implements java.io.Serializable {
	
	private static final long serialVersionUID = -4359621743790225482L;
	private String specId;
	private String specName;
	private String specType;
	private String specExplain;
	private String specState;
	
	public Spec() {
		super();
	}

	public Spec(String specId, String specName, String specType, String specExplain, String specState) {
		super();
		this.specId = specId;
		this.specName = specName;
		this.specType = specType;
		this.specExplain = specExplain;
		this.specState = specState;
	}

	public String getSpecId() {
		return specId;
	}

	public void setSpecId(String specId) {
		this.specId = specId;
	}

	public String getSpecName() {
		return specName;
	}

	public void setSpecName(String specName) {
		this.specName = specName;
	}

	public String getSpecType() {
		return specType;
	}

	public void setSpecType(String specType) {
		this.specType = specType;
	}

	public String getSpecExplain() {
		return specExplain;
	}

	public void setSpecExplain(String specExplain) {
		this.specExplain = specExplain;
	}

	public String getSpecState() {
		return specState;
	}

	public void setSpecState(String specState) {
		this.specState = specState;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "Spec [specId=" + specId + ", specName=" + specName + ", specType=" + specType + ", specExplain="
				+ specExplain + ", specState=" + specState + "]";
	}

}
