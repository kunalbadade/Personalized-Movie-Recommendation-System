package com.data.manager.entity;

public class Label {

	private String key;
	
	private String value;
	
	private String value1;
	
	private String ifChecked = "";
	
	public Label(String _key, String _value){
		this.key = _key;
		this.value = _value;
	}
	
	public Label(String _key, String _value, String _value1){
		this.key = _key;
		this.value = _value;
		this.value1 = _value1;
	}
	
	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
	public String getValue1() {
		return value1;
	}

	public void setValue1(String value1) {
		this.value1 = value1;
	}
	
	public String getIfChecked() {
		return ifChecked;
	}

	public void setIfChecked(String ifChecked) {
		this.ifChecked = ifChecked;
	}
}
