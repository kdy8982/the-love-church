package org.zerock.domain;

import lombok.Data;

/**
 * @author 하영
 * RequestBody 예제를 위한 클래스.
 */
@Data
public class Ticket {

	private int tno;
	private String owner;
	private String grade;
	
}
