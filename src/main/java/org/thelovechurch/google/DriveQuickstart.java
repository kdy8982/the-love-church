package org.thelovechurch.google;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.FileContent;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;

import lombok.extern.log4j.Log4j;

@Log4j
public class DriveQuickstart {
	// private static final String APPLICATION_NAME = "Google Drive API Java Quickstart";
	private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
	private static final String TOKENS_DIRECTORY_PATH = "tokens";

	/** Email of the Service Account */
	private static final String SERVICE_ACCOUNT_EMAIL = "id-comunity@thelovecomunity.iam.gserviceaccount.com";
	/** Path to the Service Account's Private Key file */
	private static final String SERVICE_ACCOUNT_PKCS12_FILE_PATH = "TheLoveComunity.p12";
	
	/** Folder PATH **/
	// 테스트용
	private static final String SERVICE_FOLDER_PATH = "1A-YhkL2YgQnsiUe3zLhQVhJkfCacSjiV";
	// 실제용
	// private static final String SERVICE_FOLDER_PATH = "1WZJIyKB8Ech3eYn8kgwiG_8ktJx3N5CI";
	
	
	private static final List<String> SCOPES = Collections.singletonList(DriveScopes.DRIVE);
	private static final String CREDENTIALS_FILE_PATH = "/client_secret.json";

	private Drive service;

	/** 구글 드라이브 서비스를 초기화 한다 **/
	public void init() throws GeneralSecurityException, IOException {
		final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
		this.service = getDriveService();
	}

	/**
	 * 구글 드라이브에 파일을 저장한다
	 * @param imsiFilePath
	 * @throws IOException
	 **/
	public String insertFileToGoogleDrive(String FileName, String imsiFilePath) throws IOException {
		String folderId = SERVICE_FOLDER_PATH; // 구글드라이브에서 저장할 폴더를 지정 ("더사랑교회"폴더);
		log.info(folderId);
		File fileMetadata = new File();
		fileMetadata.setName(FileName); // 구글 드라이브에 올라갈 파일명을 지정
		fileMetadata.setParents(Collections.singletonList(folderId));
		java.io.File filePath = new java.io.File(imsiFilePath); // 사용자가 지정한, 로컬피씨에 이미지 파일이 있는 경로.
		FileContent mediaContent = new FileContent("image/jpeg", filePath);
		File file = service.files().create(fileMetadata, mediaContent).setFields("id, parents").execute();
		System.out.println("File ID: " + file.getId());
		return file.getId();
	}

	/**
	 * 구글 드라이브 파일 리스트 조회
	 * 
	 * @throws IOException
	 **/
	public List<String> getListFileId() throws IOException {
		FileList result = service.files().list().setQ("'" + SERVICE_FOLDER_PATH +"' in parents and mimeType != 'application/vnd.google-apps.folder' and trashed = false")
				.setSpaces("drive").setFields("nextPageToken, files(id, name, parents)").execute();
		List<File> files = result.getFiles();
		List<String> fileIdList = new ArrayList<String>();

		if (files == null || files.isEmpty()) {
			System.out.println("No files found.");
		} else {
			for (File file : files) {
				fileIdList.add(file.getId());
			}
		}
		return fileIdList;
	}
	
	/** DB에 없는, 구글 드라이브의 파일을 삭제한다. **/
	public void removeOldFile(List<String> oldFileList) throws IOException {
		for(int i=0; i<oldFileList.size(); i++) {
			service.files().delete(oldFileList.get(i)).execute();
		}
	}
	
	/** 썸네일 파일과 같은 이름의 원본 사진 id를 가져온다 
	 * @throws IOException **/
	public String getOriginFileId(String uuid) throws IOException {
		log.info(uuid);
		String query = "'" + SERVICE_FOLDER_PATH + "' in parents and mimeType != 'application/vnd.google-apps.folder' and trashed = false and name contains '" + uuid + "' and not name contains 's_'";
		
		FileList result = service.files().list().setQ(query)
				.setSpaces("drive").setFields("nextPageToken, files(id, name, parents)").execute();
		List<File> files = result.getFiles();
		String originFileId = null;
		if (files == null || files.isEmpty()) {
			System.out.println("No files found.");
		} else {
			for (File file : files) {
				originFileId = file.getId();
				log.info(originFileId);
			}
		}
		return originFileId;
	}
	
	/** 구글 연결 부분 **/
    private static Drive getDriveService() {
	    HttpTransport httpTransport = new NetHttpTransport();
	    JacksonFactory JSON_FACTORY = new JacksonFactory();
	    GoogleCredential credential;
	    Drive service = null;
	    List<String> scopes = Arrays.asList(DriveScopes.DRIVE);
	    try {
	        credential = new GoogleCredential.Builder()
	                .setTransport(httpTransport)
	                .setJsonFactory(JSON_FACTORY)
	                .setServiceAccountId(SERVICE_ACCOUNT_EMAIL)
	                .setServiceAccountScopes(scopes)
	                .setServiceAccountPrivateKeyFromP12File(
	                		new java.io.File("C:\\Users\\dyKim\\Downloads\\TheLoveComunity-647958c96437.p12"))
	                		// new java.io.File("/kdy8982/tomcat/webapps/ROOT/TheLoveComunity-647958c96437.p12"))
	                .build();
	        service = new Drive.Builder(httpTransport, JSON_FACTORY, null).setApplicationName("더사랑 교회")
	                .setHttpRequestInitializer(credential).build();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    	return service;
    }

	
}