package org.zerock.domain;

import org.junit.Test;
import org.thelovechurch.domain.MemberVO;
//import org.zerock.util.JSencodeURIComponent;

import lombok.extern.log4j.Log4j;

@Log4j
public class MemberVOTests {
	
	MemberVO vo = new MemberVO();
	
	@Test
	public void testGetThumbPhoto() {
		String a = "2019\\07\\31_ac92dfe7-0c94-44fa-a166-e359bc801667_Hydrangeas.jpg";
		
		//log.info(vo.getThumbPhoto(a));
	}
	
}
