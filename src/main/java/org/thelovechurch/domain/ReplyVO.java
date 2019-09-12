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
	
	private String photo;
	private String thumbPhoto;
	private Long deleted;
	
	public void setThumbPhoto() throws UnsupportedEncodingException {
		if(this.photo == null) {
			this.thumbPhoto = "";
			return;
		}
		
		String fileName = this.photo.substring(this.photo.indexOf("_", 11)+1);
		log.info("File Name : " + fileName);
		
		String[] photoInfoArr = this.photo.split("_");
		String fileCallPath = photoInfoArr[0] + "/s_" + photoInfoArr[1]+"_" + fileName;
		this.thumbPhoto = URLEncoder.encode(fileCallPath, "UTF-8");
	}
}
