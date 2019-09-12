package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.GalleryAttachVO;
import org.zerock.domain.GalleryVO;

public interface GalleryService {
	public List<GalleryVO> getList();
	
	public List<GalleryVO> getHomeList(Criteria cri);
	
	public void register(GalleryVO gallery);
	
}
