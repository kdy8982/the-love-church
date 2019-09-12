package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.FootprintsVO;

public interface IntroduceMapper {

	List<FootprintsVO> get();

	int add(FootprintsVO vo);

	int delete(FootprintsVO vo);

	int modify(FootprintsVO vo);

}
