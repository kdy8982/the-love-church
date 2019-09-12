package org.thelovechurch.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class GalleryVO {
	private Long gno;
	private String koreaName;
	private String engName;
	private Date regdate;
	private Date updatedate;
		
	private List<GalleryAttachVO> attachList;
}
