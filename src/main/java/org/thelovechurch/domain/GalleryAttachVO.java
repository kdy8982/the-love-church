package org.thelovechurch.domain;

import lombok.Data;

@Data
public class GalleryAttachVO {
	private String fileName;
	private String uploadPath;
	private String fileType;
	private String uuid;
	private String previewImg;
	
	private Long gano;
		
	private String wholeFilePath;
	
}
