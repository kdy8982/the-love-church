package org.thelovechurch.domain;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;

import lombok.Data;
import lombok.extern.log4j.Log4j;

@Data
@Log4j
public class ReplyVO {

	private Long rno;
	private Long bno;
	private Long parent;
	
	private String reply;
	private String replyer;
	private Date replyDate;
	private Date updateDate;
	private String username;
	
	private String photo;
	private String thumbPhoto;
	private Long deleted;
	
}
