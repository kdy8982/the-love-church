package org.thelovechurch.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.PageDTO;
import org.thelovechurch.security.domain.CustomUser;
import org.thelovechurch.service.BoardService;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/photo/*")
public class PhotoController {

	@Autowired 
	BoardService boardService;
	
	@RequestMapping("/list")
	public void list (Criteria cri, Model model) {
		log.info("photo list ...");
		cri.setBoardType("photo");
		cri.calcStartEndNum();
		int total = boardService.getTotalNotice(cri);
		log.info(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("photoList", boardService.getList(cri));
	}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {
		log.info("photo register get ...");
	}
	
	@PreAuthorize("isAuthenticated()")
	@RequestMapping("/register")
	public String registerForm(BoardVO board) throws GeneralSecurityException, IOException {
		log.info("photo register post ...");
		boardService.register(board);
		return "redirect:/photo/list";
	}
	
	@GetMapping("/get")
	public void get(BoardVO vo, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("photo get ... !!");
		model.addAttribute("photo" , boardService.getBoard(vo));
	}
	

	@RequestMapping(value="/modify", method= {RequestMethod.POST})
	@PreAuthorize("isAuthenticated() and #vo.writer == principal.username") 
	public void modify(Model model, Criteria cri, BoardVO vo) {
		log.info("photo modify get ... "); 
		vo.setBoardType("photo"); 
		model.addAttribute("photo", boardService.getBoard(vo)); 
	}
 
	
	@RequestMapping ("/modifySubmit")
	@PreAuthorize("isAuthenticated() and #vo.writer == principal.username")
	public String modify(Criteria cri, BoardVO vo) {
		log.info("photo modify post ...");
		boardService.modify(vo);
		
		return "redirect:/photo/list" + cri.getListLink();
	}
	
	@RequestMapping(value= "/delete", produces= {MediaType.TEXT_PLAIN_VALUE, "text/plain;charset=UTF-8"})
	@PreAuthorize("isAuthenticated() and #vo.writer == principal.username")
	public String delete(BoardVO vo, Criteria cri, RedirectAttributes rttr ) {
		log.info("photo delete ....!!");
		
		List<BoardAttachVO> attachList = boardService.getAttachList(vo.getBno());
		
		if(boardService.remove(vo.getBno())) {
			//deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/photo/list" + cri.getListLink();
	}
	
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				log.info(file);
				Files.deleteIfExists(file);
					if(Files.probeContentType(file).startsWith("image")) {
						Path thumbNail = Paths.get("C:\\upload\\" + attach.getUploadPath()+"\\s_" + attach.getUuid() + "_" + attach.getFileName());
						Files.delete(thumbNail);
					}
				} catch (Exception e) {
					log.error("delete file error" + e.getMessage());
			}
		});
		
	}
	
}
