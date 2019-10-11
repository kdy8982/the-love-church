package org.thelovechurch.controller;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.thelovechurch.domain.AttachFileDTO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.google.DriveQuickstart;
import org.thelovechurch.service.UploadService;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import net.coobird.thumbnailator.Thumbnails;

@Controller
@Log4j
public class UploadController {
	
	@Autowired
	UploadService uploadSerivce;
	
	@Value("${file.upload.path}")
	private String fileUploadPath;

	DriveQuickstart driveQuickstart = null;
	
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
	
	
	@RequestMapping(value="/uploadAjaxAction", method = RequestMethod.POST)
	public @ResponseBody  ResponseEntity<List<AttachFileDTO>> uploads(@RequestParam("uploadFile") MultipartFile[] files) throws GeneralSecurityException, IOException{
		log.info("update ajax post..........");
		log.info(this.fileUploadPath); // c:/upload
		
		if(this.driveQuickstart == null) {
			this.driveQuickstart = new DriveQuickstart();
			this.driveQuickstart.init();
		}
		
		List<AttachFileDTO> list = new ArrayList<>(); // AttachFileDTO는 DB에 저장할 정보를 담기위해 선언해준다. 
		String uploadFolder = this.fileUploadPath;
		String uploadFolderPath = getFolder();
		
		// make folder -------------------
		File uploadPath = new File(uploadFolder);
		log.info("upload path : " + uploadPath);
		
		// make yyyy/MM/dd folder
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile : files) { // MultipartFile배열에, 요소 하나하나를 uploadFile 변수에 넣고 반복한다. 
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
			String shortUuid = toUnsignedString(uuid.getMostSignificantBits(), 6) + toUnsignedString(uuid.getLeastSignificantBits(), 6);
			uploadFileName = shortUuid + "_" + uploadFileName;
			// uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			log.info("uploadFileName : " + uploadFileName);
			log.info("uploadPath : " + uploadPath);
			
			try {
				// File saveThumbFile = new File(uploadFolder, "s_"+uploadFileName);
				File saveFile  = new File(uploadFolder, uploadFileName); // 새로 만들 파일에 대한 정보를 java 객체로 만든다. 
				// File saveFile  = new File("/kdy8982/tomcat/webapps/ROOT", uploadFileName);
				multipartFile.transferTo(saveFile); // 실제 파일을 지정한 정보를 토대로 만든다. 
				
				log.info("uploadFolderPath : " + uploadFolderPath);
				attachDTO.setUuid(shortUuid);
				attachDTO.setImage(true);
				attachDTO.setUploadPath(this.driveQuickstart.insertFileToGoogleDrive(uploadFileName, saveFile.toPath().toString()));
				log.info("saveFile.toPath().toString() : " + saveFile.toPath().toString());
				
				/*
				// check image type file
				if(checkImageType(saveFile)) {
					log.info("Create thumbnail.....");
					attachDTO.setImage(true);
					
					Thumbnails.of(saveFile).size(470, 336).toFile(saveThumbFile);
					
					//FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					//Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 470, 336);
					//thumbnail.close();
					//saveThumbFile  = new File(uploadFolder, "s_"+uploadFileName); // 새로 만들 파일에 대한 정보를 java 객체로 만든다. 
					log.info(saveThumbFile.toPath().toString());
					attachDTO.setThumbNailPath(this.driveQuickstart.insertFileToGoogleDrive("s_" + uploadFileName, saveThumbFile.toPath().toString()));
				}
				*/
				list.add(attachDTO);
				
				saveFile.delete(); // 서버에 임시로 생성된 이미지 파일을 지운다. 	
				//saveThumbFile.delete(); // 서버에 임시로 생성된 이미지 파일을 지운다. 
			} catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		// uploadPath.delete(); // 서버에 임시로 생성된 이미지 폴더를 지운다.
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	/* 파일 업로드 ajax요청(정해진 로컬 경로에 파일을 생성한다. DB와 상관없음.) */
	/* 로직 : 구글 드라이브에 올리기 전에, 서버의 임시 공간을 만들어 올리고 -> 구글 드라이브로 올린뒤 -> 서버의 임시공간을 삭제한다. */
	/*
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/uploadAjaxAction", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) throws GeneralSecurityException, IOException {
		log.info("update ajax post..........");
		log.info(this.fileUploadPath); // c:/upload
		
		if(this.driveQuickstart == null) {
			this.driveQuickstart = new DriveQuickstart();
			this.driveQuickstart.init();
		}
		
		List<AttachFileDTO> list = new ArrayList<>(); // AttachFileDTO는 DB에 저장할 정보를 담기위해 선언해준다. 
		String uploadFolder = this.fileUploadPath;
		String uploadFolderPath = getFolder();
		
		// make folder -------------------
		File uploadPath = new File(uploadFolder);
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
			String shortUuid = toUnsignedString(uuid.getMostSignificantBits(), 6) + toUnsignedString(uuid.getLeastSignificantBits(), 6);
			uploadFileName = shortUuid + "_" + uploadFileName;
			// uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			log.info("uploadFileName : " + uploadFileName);
			log.info("uploadPath : " + uploadPath);
			
			try {
				File saveThumbFile = new File(uploadFolder, "s_"+uploadFileName);
				File saveFile  = new File(uploadFolder, uploadFileName); // 새로 만들 파일에 대한 정보를 java 객체로 만든다. 
				// File saveFile  = new File("/kdy8982/tomcat/webapps/ROOT", uploadFileName);
				multipartFile.transferTo(saveFile); // 실제 파일을 지정한 정보를 토대로 만든다. 
				
				log.info("uploadFolderPath : " + uploadFolderPath);
				attachDTO.setUuid(shortUuid);
				attachDTO.setImage(true);
				attachDTO.setUploadPath(this.driveQuickstart.insertFileToGoogleDrive(uploadFileName, saveFile.toPath().toString()));
				log.info("saveFile.toPath().toString() : " + saveFile.toPath().toString());
				
				// check image type file
				if(checkImageType(saveFile)) {
					log.info("Create thumbnail.....");
					attachDTO.setImage(true);
					
					Thumbnails.of(saveFile).size(470, 336).toFile(saveThumbFile);
					
					//FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					//Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 470, 336);
					//thumbnail.close();
					//saveThumbFile  = new File(uploadFolder, "s_"+uploadFileName); // 새로 만들 파일에 대한 정보를 java 객체로 만든다. 
					log.info(saveThumbFile.toPath().toString());
					attachDTO.setThumbNailPath(this.driveQuickstart.insertFileToGoogleDrive("s_" + uploadFileName, saveThumbFile.toPath().toString()));
				}
				list.add(attachDTO);
				
				saveFile.delete(); // 서버에 임시로 생성된 이미지 파일을 지운다. 	
				//saveThumbFile.delete(); // 서버에 임시로 생성된 이미지 파일을 지운다. 
			} catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		// uploadPath.delete(); // 서버에 임시로 생성된 이미지 폴더를 지운다.
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	*/
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
	
	/*
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
	*/
	/*
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
	*/
	
	/** UUID로 원본 파일의 사진을 가지고 온다. 
	 * @throws GeneralSecurityException **/
	@GetMapping("/getOriginFileId")
	@ResponseBody
	public String getOriginFileId(String uuid) throws IOException, GeneralSecurityException {
		log.info(uuid);
		if(this.driveQuickstart == null) {
			driveQuickstart = new DriveQuickstart();
			driveQuickstart.init();
		}
		return driveQuickstart.getOriginFileId(uuid);
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
	
	
    public static String toUnsignedString(long i, int shift) {
        char[] buf = new char[62];
        int charPos = 62;
        int radix = 1 << shift;
        long mask = radix - 1;
        long number = i;
        
        do {
            buf[--charPos] = digits[(int) (number & mask)];
            number >>>= shift;
        } while (number != 0);
        return new String(buf, charPos, (62 - charPos));
    }

    final static char[] digits = {
            '0', '1', '2', '3', '4', '5', '6', '7',
            '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
            'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
            'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D',
            'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
            'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
            'U', 'V', 'W', 'X', 'Y', 'Z', '_', '-' // '.', '-'
    };
	
    
    private void makeThumbnail (File saveFile, File saveThumbFile) {
        try {
            //썸네일 가로사이즈
            int thumbnail_width = 100;
            //썸네일 세로사이즈
            int thumbnail_height = 100;
            //원본이미지파일의 경로+파일명
            File origin_file_name = saveFile;
            //생성할 썸네일파일의 경로+썸네일파일명
            File thumb_file_name = saveThumbFile;
 
            BufferedImage buffer_original_image = ImageIO.read(origin_file_name);
            BufferedImage buffer_thumbnail_image = new BufferedImage(thumbnail_width, thumbnail_height, BufferedImage.TYPE_3BYTE_BGR);
            Graphics2D graphic = buffer_thumbnail_image.createGraphics();
            graphic.drawImage(buffer_original_image, 0, 0, thumbnail_width, thumbnail_height, null);
            ImageIO.write(buffer_thumbnail_image, "jpg", thumb_file_name);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
