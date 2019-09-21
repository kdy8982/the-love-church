package org.thelovechurch.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.log4j.Log4j;

@Getter
@Setter
@ToString
@Log4j
public class Criteria {
	private int pageNum;
	private int amount;
	private int startNum;
	private int endNum;
	
	private String type;
	private String keyword;
	
	private String boardType;
	
	public Criteria() {
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
		this.startNum = (pageNum - 1) * amount;
		this.endNum = pageNum * amount;
	}

	public Criteria(int pageNum, int amount, String boardType) {
		this.pageNum = pageNum;
		this.amount = amount;
		this.boardType = boardType;
		this.startNum = (pageNum - 1) * amount;
		this.endNum = pageNum * amount;
	}
	
	
	// 마이바티스 동적 쿼리를 위한 메서드
	public String[] getTypeArr() { 
		return type==null? new String[] {} : type.split("");
	}
	
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		
		return builder.toUriString();
	}
	
	public void calcStartEndNum() {
		if(this.pageNum == 0 || this.amount == 0 ) {
			if(this.boardType.equals("notice")) {
				this.pageNum = 1;
				this.amount = 10;
			} else if (this.boardType.equals("photo")) {
				this.pageNum = 1;
				this.amount = 12;
			} else if (this.boardType.equals("essay")) {
				this.pageNum = 1;
				this.amount = 6;
			} else { 
				this.pageNum = 1;
				this.amount = 10;
			}
			log.info(this.boardType);
		}
		
		this.startNum = (this.pageNum - 1) * this.amount;
		this.endNum = this.pageNum * this.amount;
	}

}
