package org.thelovechurch.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.thelovechurch.domain.AttachFileDTO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.service.UploadService;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	@Autowired
	UploadService uploadSerivce;
	
	@Value("${file.upload.path}")
	private String fileUploadPath;
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {// 파라미터로 선언된 uploadFile, 여러 파일들을 배열형태로 저장한 변수. 
		
		String uploadFolder = this.fileUploadPath;
		log.info(fileUploadPath);
		for(MultipartFile multipartFile : uploadFile) {
			
			log.info("---------------------------------");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch(Exception e) {
				log.error(e.getMessage());
			}
			
		}
	}
	
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload Ajax...");
	}
	
	
	/* 파일 업로드 ajax요청(정해진 로컬 경로에 파일을 생성한다. DB와 상관없음.) */
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/uploadAjaxAction", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("update ajax post..........");
		log.info(this.fileUploadPath);
		
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = this.fileUploadPath;
		String uploadFolderPath = getFolder();
		
		// make folder -------------------
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("upload path : " + uploadPath);
		
		// make yyyy/MM/dd folder
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile : uploadFile) { // MultipartFile배열에, 요소 하나하나를 uploadFile 변수에 넣고 반복한다. 
			log.info("-----------------------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename()); 
			log.info("Upload File Size: " + multipartFile.getSize());
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// IE의 경우 전체 path가 출력되기에, 파일명만 남겨놓기 위해 작업을 한다.
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1); 
			log.info("only File Name : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			// 파일이 중복될경우 기존 파일이 사라지는 문제를 해결하기 위해, 자바 UUID를 사용
			UUID uuid = UUID.randomUUID(); 
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			log.info("uploadFileName : " + uploadFileName);
			
			// File saveFile  = new File(uploadFolder, uploadFileName);
			log.info("uploadPath : " + uploadPath);
			
			try {
				File saveFile  = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				log.info("uploadFolderPath : " + uploadFolderPath);
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				
				// check image type file
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 470, 336);
					thumbnail.close();
				}
				list.add(attachDTO);
			} catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@GetMapping("/display")
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("fileName : " + fileName);
		
		File file = new File("C:\\upload\\" + fileName);
		
		log.info("file : " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			log.info("Files.probeContentType(file.toPath()) : " + Files.probeContentType(file.toPath()));
			header.add("Content-type", Files.probeContentType(file.toPath()));
			
			result = new ResponseEntity<> (FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch(IOException e ) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value="/download", produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent")String userAgent, String fileName) {
		log.info("Download file : " + fileName);
		
		Resource resource = new FileSystemResource("C:\\upload\\" + fileName);
		log.info("resource : " + resource);
		
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND); 
		}
		
		String resourceName = resource.getFilename();
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			
			/* @RequestHeader 파라미터로 날라온 userAgent 값을 이용하여, 클라이언트의 접속 브라우저를 판단한다. */
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			} else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8");
			} else {
				log.info("Chrome browser");
				downloadName = new String (resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			log.info("downloadName : " + downloadName);
			headers.add("Content-Disposition", "attachment; filenmame=" + downloadName); 
			
			
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/deleteFile" , produces= {MediaType.TEXT_PLAIN_VALUE, "text/plain;charset=UTF-8"})
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String uploadPath) {
		log.info("deleteFile : " + fileName);
		log.info("uploadPath : " + uploadPath);
		
		try {
			Path file = Paths.get("C:\\upload\\" + uploadPath + "\\"+ fileName);
			if(Files.deleteIfExists(file)){
				Path thumbNail = Paths.get("C:\\upload\\" + uploadPath + "\\s_" + fileName);
				Files.delete(thumbNail);
			};
		} catch(Exception e ) {
			log.error("delete file erro" + e.getMessage() );
		}
		
		return new ResponseEntity<String> ("첨부파일이 삭제되었습니다." , HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/deleteAttachFile" , produces= {MediaType.TEXT_PLAIN_VALUE, "text/plain;charset=UTF-8"})
	@ResponseBody
	public ResponseEntity<String> deleteAttachFile(AttachFileDTO attachFileDto) {
		log.info(attachFileDto);
		if(uploadSerivce.removeAttachFile(attachFileDto)) {
			return new ResponseEntity<String> ("첨부파일이 삭제되었습니다." , HttpStatus.OK);
		} else {
			return new ResponseEntity<String> ("삭제에 실패했습니다." , HttpStatus.INTERNAL_SERVER_ERROR); 
		}
	}

	// 파일 저장할 때, 날짜별로 폴더를 디렉토리를 생성하는 메서드 
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		log.info("Date : " + date);
		String str = sdf.format(date);
		log.info(str);
		log.info("str.replace(\"-\", File.separator) : " + str.replace("-", File.separator));
		return str.replace("-", File.separator);
	}
	
	// 업로드된 파일이 이미지 종류인지 체크
	private boolean checkImageType(File file) {
		try {
			log.info("file.toPath() : " + file.toPath());
			String contentType = Files.probeContentType(file.toPath());
			log.info("Files.probeContentType(file.toPath()) : " + contentType);
			return contentType.startsWith("image"); 
			
		} catch(IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
}
