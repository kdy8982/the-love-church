package org.thelovechurch.service;

import java.util.List;
import java.util.Map;

import org.thelovechurch.domain.FootprintsVO;

public interface IntroduceService {

	Map<String, List<FootprintsVO>> get();

	int add(FootprintsVO vo);

	int delete(FootprintsVO vo);

	boolean modify(FootprintsVO vo);
	
}
