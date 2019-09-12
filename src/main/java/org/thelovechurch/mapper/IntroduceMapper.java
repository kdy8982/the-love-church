package org.thelovechurch.mapper;

import java.util.List;

import org.thelovechurch.domain.FootprintsVO;

public interface IntroduceMapper {

	List<FootprintsVO> get();

	int add(FootprintsVO vo);

	int delete(FootprintsVO vo);

	int modify(FootprintsVO vo);

}
