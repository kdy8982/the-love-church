package org.zerock.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.AuthVO;
import org.zerock.domain.MemberVO;
import org.zerock.service.MemberService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping(value= {"/admin/*"})
public class AdminController {

	@Autowired
	MemberService memberService;

	
	@RequestMapping("/main")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public void main(Model model) {
		log.info("admin main page call..!");
		
		model.addAttribute("memberList", memberService.getList());
	}
	
	@RequestMapping("/memberDetail")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public void memberDetail(Model model, MemberVO vo) throws UnsupportedEncodingException {
		log.info("admin memberDetail page call..!");
		vo = memberService.get(vo);
		if(vo.getPhoto() != null) {
			vo.setThumbPhoto(); // 화면에 출력할 수 있도록, MemberVO 객체에 있는 메서드를 이용하여 , 알맞게 포맷을 변경해준다.
		}
		
		model.addAttribute("member", vo);
	}
	
	@RequestMapping("/grantAuth")
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	public String grantAuth(Model model, MemberVO vo, String auth, RedirectAttributes rttr) {
		log.info("admin grantAuth call..!");
		
		AuthVO authVO = new AuthVO();
		authVO.setAuth(auth);
		authVO.setUserid(vo.getUserid());
		
		if (memberService.grantAuth(authVO)) {
			rttr.addFlashAttribute("result", "성공적으로 처리하였습니다.");
		};
		
		return "redirect:/admin/memberDetail?userid=" + vo.getUserid();
	}
}
