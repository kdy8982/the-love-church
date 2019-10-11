package org.thelovechurch.google;

import static org.junit.Assert.fail;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.File;
import com.google.api.services.drive.model.FileList;

import lombok.extern.log4j.Log4j;
@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", "file:src/main/webapp/WEB-INF/spring/security-context.xml"})

public class DriveQuickstartTest {
	private Drive service;
	
	@Test
	public void testInit() throws IOException {
		this.service = getDriveService();
		getListFileId();
	}

	/** Email of the Service Account */
	private static final String SERVICE_ACCOUNT_EMAIL = "id-comunity@thelovecomunity.iam.gserviceaccount.com";
	/** Path to the Service Account's Private Key file */
	private static final String SERVICE_ACCOUNT_PKCS12_FILE_PATH = "C:\\Users\\dyKim\\Downloads\\TheLoveComunity-647958c96437.p12";
	// private static final String SERVICE_ACCOUNT_PKCS12_FILE_PATH = "/kdy8982/tomcat/webapps/ROOT/TheLoveComunity-647958c96437.p12"; 
	
	
    public static Drive getDriveService() {
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
	                        new java.io.File(SERVICE_ACCOUNT_PKCS12_FILE_PATH))
	                .build();
	        service = new Drive.Builder(httpTransport, JSON_FACTORY, null).setApplicationName("더사랑 교회")
	                .setHttpRequestInitializer(credential).build();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    	return service;
    }
    
    
	/**
	 * 구글 드라이브 파일 리스트 조회
	 * 
	 * @throws IOException
	 **/
	public List<String> getListFileId() throws IOException {
		String uuid = "4rPpxir5QHY9Bs3o1B8tY_";
		String query = "'1WZJIyKB8Ech3eYn8kgwiG_8ktJx3N5CI' in parents and mimeType != 'application/vnd.google-apps.folder' and trashed = false and name contains '" + uuid + "' and not name contains 's_'";
		FileList result = service.files().list().setQ(query)
				.setSpaces("drive").setFields("nextPageToken, files(id, name, parents)").execute();
		List<File> files = result.getFiles();
		List<String> fileIdList = new ArrayList<String>();

		if (files == null || files.isEmpty()) {
			System.out.println("No files found.");
		} else {
			for (File file : files) {
				log.info(file);
				fileIdList.add(file.getId());
			}
		}
		return fileIdList;
	}
    
    
    
    
}
