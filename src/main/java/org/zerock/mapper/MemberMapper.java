package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.AuthVO;
import org.zerock.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid); 
	public List<MemberVO> getList(); // 모든 회원 목록 조회.
	
	public int insert(MemberVO vo); // 회원가입
	public int authorize(AuthVO authVo); // 회원가입(권한부여)

	public int changePassword(MemberVO vo);
	public int changeProfilePhoto(MemberVO vo);
	
	public int grantAuth(AuthVO auth);
	
	public int checkIdIsSigned(String userid);
	public int checkEmailIsSigned(String userid);

}
