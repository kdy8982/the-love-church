package org.thelovechurch.controller;
	
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;
import org.thelovechurch.domain.BoardAttachVO;
import org.thelovechurch.domain.BoardVO;
import org.thelovechurch.domain.Criteria;
import org.thelovechurch.domain.PageDTO;
import org.thelovechurch.service.BoardService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.GeneralSecurityException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping(value = {"/board/*"} )
@AllArgsConstructor
public class BoardController {

	private BoardService service;

	@RequestMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list:" + cri);
		model.addAttribute("list", service.getList(cri));
		// model.addAttribute("pageMaker", new PageDTO(cri, 123));
		// model.addAttribute("previewList", service.getPreviewImg());

		int total = service.getTotal(cri); // 페이징 처리를 위해, 전체 공지글 수를 구한다.
		log.info("total : " + total);

		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
	}
	
	@RequestMapping(value = "/getPreviewImg", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<BoardAttachVO>> getPreviewImg() {
		return new ResponseEntity<>(service.getPreviewImg(), HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()") // 스프링 시큐리티 애노테이션. 인증된 사용자 인지.
	@GetMapping("/register")
	public void register() {
	}
	
	@PreAuthorize("isAuthenticated()") // 스프링 시큐리티 애노테이션. 인증된 사용자 인지.
	@PostMapping("/register")
	public void register(BoardVO board, RedirectAttributes rttr) throws GeneralSecurityException, IOException {
		log.info("============================================================");
		log.info("register : " + board);

		if (board.getAttachList() != null) { // 첨부파일이 있으면,

			board.getAttachList().forEach(attach -> log.info(attach));
		}

		log.info("============================================================");
		
		board.setBoardType("notice"); // 임시로.....
		service.register(board);
		//rttr.adedirect:/board/list"dFlashAttribute("result", board.getBno());
	}
	
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {

		log.info("/get or modify");
		model.addAttribute("board", service.get(bno)); // jsp view에서 사용할 객체를 보낸다.
	}
	
	@PreAuthorize("isAuthenticated() and principal.username == #board.writer")
	@RequestMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify : " + board);
		log.info(board.getBno());
		
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}
		/*
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("keyword", cri.getKeyword());
		rttr.addAttribute("type", cri.getType());
		*/
		return "redirect:/board/list" + cri.getListLink();
	}
	
	/* 게시글 삭제 */
	@PreAuthorize("isAuthenticated() and principal.username == #writer")
	@RequestMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr, String writer) {
		log.info("remove : " + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno); // 첨부된 모든 파일의 정보를 구해온다. 
		
		
		if (service.remove(bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/board/list" + cri.getListLink();
	}

	
	@GetMapping(value = "/getAttachList", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody // 화면에 바로 출력하는 것이 아닌, 헤더에 Json데이터로 넘긴다. , @RestController가 선언되어있는 클래스는 모든 메서드에 ResponseBody가 적용된다.
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		log.info("getAttachList : " + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	
	/*일반 파일 및 이미지, 썸네일의 '실제 파일 삭제' 메서드*/
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files.........");
		log.info("attachList");
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\" + attach.getUploadPath()+"\\s_" + attach.getUuid() + "_" + attach.getFileName());
					Files.delete(thumbNail);
				}
				
			} catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}
	
	
	
}
