package org.thelovechurch.domain;

import lombok.Data;

@Data
public class AttachFileDTO {

	private String fileName; // 파일 이름
	private String uploadPath; // 파일 경로
	private String uuid; // uuid값(고유한 값을 만들어주기 위함)
	private boolean image; // 업로드 파일의 확장자가 이미지인지 ?
	
	private String thumbNailPath;
	
	
}
