package org.thelovechurch.service;

import java.util.List;

import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.GalleryAttachVO;
import org.thelovechurch.domain.GalleryVO;

public interface GalleryService {
	public List<GalleryVO> getList();
	
	public List<GalleryVO> getHomeList(Criteria cri);
	
	public void register(GalleryVO gallery);
	
}
