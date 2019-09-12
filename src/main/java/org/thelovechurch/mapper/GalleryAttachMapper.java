package org.thelovechurch.mapper;

import java.util.List;

import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.GalleryAttachVO;
import org.thelovechurch.domain.GalleryVO;

public interface GalleryAttachMapper {
	public List<GalleryVO> getGalleryList();
	public List<GalleryVO> getHomeGalleryList(Criteria cri);
	public void insert(GalleryAttachVO vo);
}
