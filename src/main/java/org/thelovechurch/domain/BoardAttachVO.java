package org.thelovechurch.domain;

import lombok.Data;

@Data
public class BoardAttachVO {

	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	
	private boolean previewImg;

	private Long bno;
	
	
	private String previewFilePath;
	
	private String wholeFilePath;
}
