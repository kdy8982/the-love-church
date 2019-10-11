package org.thelovechurch.task;

import static org.junit.Assert.*;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.thelovechurch.google.DriveQuickstart;
import org.thelovechurch.mapper.BoardAttachMapper;
import org.zerock.service.BoardServiceTests;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/security-context.xml"})
public class FileCheckTaskTest {
	
	@Autowired
	private BoardAttachMapper attachMapper;

	@Test
	public void testCheckFiles() throws GeneralSecurityException, IOException {
		// DB에 저장되어있는 것들 중, 바로 전날에 등록된 첨부파일들의 목록을 불러온다. 
		List<String> DBFileList = attachMapper.getOldFiles(); 
		
		
        DriveQuickstart driveQuickstart = new DriveQuickstart();
        driveQuickstart.init();
        List<String> googleDriveFileIdList = driveQuickstart.getListFileId();
        
        List<String> removeFiles = new ArrayList<String>();

        for(int i=0; i<googleDriveFileIdList.size(); i++) {
        	if(DBFileList.contains(googleDriveFileIdList.get(i)) == false) {
        		removeFiles.add(googleDriveFileIdList.get(i));
        	};
        }
        log.info("Remove File is... ");
        log.info(removeFiles);
        driveQuickstart.removeOldFile(removeFiles);
	}

}
