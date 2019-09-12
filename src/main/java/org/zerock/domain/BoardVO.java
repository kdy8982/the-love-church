package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {

	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updatedate;
	
	private String boardType;
	
	private int replyCnt;
	private int photoCnt;
	private int videoCnt;
	
	private List<BoardAttachVO> attachList;
	
}
