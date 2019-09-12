package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthVO {
	public AuthVO() {
	}
	String userid;
	String auth;
}
