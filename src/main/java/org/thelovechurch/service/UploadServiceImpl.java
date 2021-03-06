package org.thelovechurch.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.thelovechurch.domain.AttachFileDTO;
import org.thelovechurch.mapper.BoardAttachMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class UploadServiceImpl implements UploadService {

	@Autowired
	private BoardAttachMapper attachMapper;
	
	
	@Override
	public boolean removeAttachFile(AttachFileDTO attachFileDto) {
		log.info("removeAttachFile method call.. ");
		
		return attachMapper.delete(attachFileDto.getUuid()) != 0 ? true : false;
	}

}
