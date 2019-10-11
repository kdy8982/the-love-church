package org.thelovechurch.domain;


import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.extern.log4j.Log4j;

@Data
@Log4j
public class MemberVO {
	private String userid;
	private String userpw;
	private String username;
	private String enabled;
	
	private Date regDate;
	private Date updateDate;
	
	private String photo;
	//private String thumbPhoto;
	
	private String useremail;
	
	private List<AuthVO> authList; // 하나의 사용자는 여러개의 권한을 가질 수 있다(user, member, admin).
	
	/*
	public void setThumbPhoto() throws UnsupportedEncodingException {
		String fileName = this.photo.substring(this.photo.indexOf("_", 11)+1);
		log.info("File Name : " + fileName);
		
		String[] photoInfoArr = this.photo.split("_");
		String fileCallPath = photoInfoArr[0] + "/s_" + photoInfoArr[1]+"_" + fileName;
		this.thumbPhoto = URLEncoder.encode(fileCallPath, "UTF-8");
	}
	*/
	
	
}
