package org.thelovechurch.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_= {@Autowired})
	private BoardAttachMapper attachMapper;

	
	/** 어제 날짜의 폴더 경로를 구한다. **/
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
	}
	
	@Scheduled(cron="0 0 10 * * *")
	public void checkFiles() throws Exception {
		log.warn("File Check Task run............");
		log.warn(new Date());
		// DB에 저장되어있는 것들 중, 바로 전날에 등록된 첨부파일들의 목록을 불러온다. 
		List<BoardAttachVO> fileList = attachMapper.getOldFiles(); 
		
		// 위에서 불러온 첨부파일 목록(VO)을 java.nio.file.Path로 바꿔서 배열을 만들어준다.
		List<Path> fileListPaths = fileList.stream().map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName())).collect(Collectors.toList());
		
		// 위에서 만들어진 첨부파일과 함께 생성되었던, 썸네일을 함께 배열에 넣어준다.
		fileList.stream().filter(vo -> vo.isFileType() == true).map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName())).forEach(p->fileListPaths.add(p));
		
		log.warn("===============================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		// 실제 파일이 저장되어있는 파일의 경로를 구한다.
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		log.info(targetDir);
		
		// 실제 파일의 경로에 저장되어있는 파일들의 목록과 DB에 저장된 첨부파일 목록을 비교하여, DB에 없지만 경로에만 남아있는 파일의 모아서 배열로 만들어준다. 
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		log.warn("-------------------------------");
		
		// removeFiles의 파일들을 삭제한다.
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}
	
	
}
