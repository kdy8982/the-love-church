package org.zerock.service;

import java.util.List;

import org.zerock.domain.AuthVO;
import org.zerock.domain.MemberVO;

public interface MemberService {
	
	public MemberVO get(MemberVO vo);
	public List<MemberVO> getList();
	
	public boolean insert(MemberVO vo);
	public boolean changePassword(MemberVO vo, String newpw);
	public void changeProfilePhoto(MemberVO vo);
	
	public boolean grantAuth(AuthVO authVO);
	
	public int checkIdIsSigned(String userid);
	public int checkEmailIsSigned(String userid);
	
}
