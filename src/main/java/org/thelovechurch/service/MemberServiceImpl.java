package org.thelovechurch.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.thelovechurch.domain.AuthVO;
import org.thelovechurch.domain.MemberVO;
import org.thelovechurch.event.UserAccountChangedEvent;
import org.thelovechurch.mapper.BoardMapper;
import org.thelovechurch.mapper.MemberMapper;
import org.thelovechurch.security.CustomUserDetailService;
import org.thelovechurch.security.domain.CustomUser;

import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	BoardMapper boardMapper;

	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	private ApplicationEventPublisher eventPublisher; // 스프링 이벤트 publish를 위한 객체 주입(별도로 등록하지 않아도 스프링에서 자동으로 주입해줌).

	@Override
	public boolean insert(MemberVO member) {
		log.info("call member service impl..!!  ");

		String encodedPw = passwordEncoder.encode(member.getUserpw());
		member.setUserpw(encodedPw);
		log.info(member);
		boolean insertResult = memberMapper.insert(member) == 1;
		log.info("insertResult : " + insertResult);
		
		ArrayList<AuthVO> authArrayList = new ArrayList<AuthVO>();
		authArrayList.add(new AuthVO());
		member.setAuthList(authArrayList);
		log.info("member.getAuthList().size() : " + member.getAuthList().size());


		if (insertResult && member.getAuthList().size() > 0) {
			member.getAuthList().forEach(auth -> {
				auth.setUserid(member.getUserid());
				auth.setAuth("ROLE_USER"); // 처음에는 무조건 ROLE_USER 단계로 가입된다. log.info(auth);
				// member.getAuthList().add(auth);
				memberMapper.authorize(auth); // 권한을 부여한다.
			});
		}
		return insertResult;
	}

	@Override
	public boolean changePassword(MemberVO vo, String newpw) {
		MemberVO getDbMember = memberMapper.read(vo.getUserid());

		log.info(vo.getUserpw());
		log.info(getDbMember.getUserpw());
		log.info(passwordEncoder.matches(vo.getUserpw(), getDbMember.getUserpw()));
		
		if(passwordEncoder.matches(vo.getUserpw(), getDbMember.getUserpw())) { // 디비의 password와 입력한 기존 password가 동일하면 .. 
			vo.setUserpw(passwordEncoder.encode(newpw));
			memberMapper.changePassword(vo);
			return true;
		} else {
			return false;
		}
		
	}

	@Override
	public void changeProfilePhoto(MemberVO vo) {
		int result = memberMapper.changeProfilePhoto(vo);
		
		if(result > 0) {
			UserAccountChangedEvent event = new UserAccountChangedEvent(this, vo.getUserid()); // 스프링 이벤트 처리
			eventPublisher.publishEvent(event);
		}
	}

	@Override
	public MemberVO get(MemberVO vo) {
		return memberMapper.read(vo.getUserid());
	}

	@Override
	public List<MemberVO> getList() {
		return memberMapper.getList();
	}

	@Override
	public boolean grantAuth(AuthVO auth) {
		return memberMapper.grantAuth(auth) == 1;
		
	}

	@Override
	public int checkIdIsSigned(String userid) {
		return memberMapper.checkIdIsSigned(userid);
	}

	@Override
	public int checkEmailIsSigned(String userid) {
		return memberMapper.checkEmailIsSigned(userid);
	}
	
//    protected Authentication createNewAuthentication(Authentication currentAuth, String username) {
//    	CustomUserDetailService cuds = new CustomUserDetailService();
//        UserDetails newPrincipal = cuds.loadUserByUsername(username);
//
//        UsernamePasswordAuthenticationToken newAuth =  new UsernamePasswordAuthenticationToken(newPrincipal, currentAuth.getCredentials(), newPrincipal.getAuthorities());
//
//        newAuth.setDetails(currentAuth.getDetails());
//
//        return newAuth;
//
//    }
}
