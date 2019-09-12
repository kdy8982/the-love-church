package org.thelovechurch.security;

import java.io.UnsupportedEncodingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.thelovechurch.domain.MemberVO;
import org.thelovechurch.mapper.MemberMapper;
import org.thelovechurch.security.domain.CustomUser;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailService implements UserDetailsService {
	
	@Setter(onMethod_={@Autowired})
	private MemberMapper memberMapper;
	
	@Override
	public UserDetails loadUserByUsername(String userid) throws UsernameNotFoundException { // input의 name과 파라미터로 선언하는 변수명은 대소문자를 구분하지 않는다.
		log.info("Call loadUserByUsername..!");
		log.warn("Load User by UserName : " + userid);
		
		MemberVO vo = memberMapper.read(userid);
		
		if(vo.getPhoto() != null) { // vo에 회원 프로필 사진이 있다면..
			try {
				vo.setThumbPhoto();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		log.warn("quried by member mapper : " + vo);
		
		// 다양한 인증 방법을 설정하기 위해, org.springframework.security.core.userdetails.User클래스를 상속하여 만든,
		// CustomUser 클래스를 리턴한다.
		return vo == null ? null : new CustomUser(vo);
		
	}

}
