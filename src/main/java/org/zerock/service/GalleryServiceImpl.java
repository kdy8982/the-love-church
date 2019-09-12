package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.Criteria;
import org.zerock.domain.GalleryAttachVO;
import org.zerock.domain.GalleryVO;
import org.zerock.mapper.GalleryAttachMapper;
import org.zerock.mapper.GalleryMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class GalleryServiceImpl implements GalleryService{

	
	@Autowired
	GalleryMapper galleryMapper;
	
	
	@Autowired 
	GalleryAttachMapper galleryAttachMapper;
	
	@Override
	public List<GalleryVO> getList() {
		return galleryAttachMapper.getGalleryList();
	}
	
	@Override
	public List<GalleryVO> getHomeList(Criteria cri) {
		return galleryAttachMapper.getHomeGalleryList(cri);
	}


	@Override
	public void register(GalleryVO gallery) {
		
		galleryMapper.insertSelectKey(gallery);
		
		if(gallery.getAttachList() == null || gallery.getAttachList().size() <= 0) {
			return;
		}
		
		gallery.getAttachList().forEach(attach -> {
			// attach.setBno(gallery.getGno());
			
			log.info(attach);
			galleryAttachMapper.insert(attach); 
		});
		
	}


}
