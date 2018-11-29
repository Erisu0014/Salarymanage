package com.bean.Mybean;

import lombok.Data;

@Data
public class EntityName {
	String name;
	String define;
	String sentence;

	@Override
	public String toString() {
		return "EntityName{" +
				"name='" + name + '\'' +
				", define='" + define + '\'' +
				", sentence='" + sentence + '\'' +
				'}';
	}
}
