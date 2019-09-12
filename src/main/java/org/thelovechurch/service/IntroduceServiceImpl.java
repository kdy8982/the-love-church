package org.thelovechurch.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.springframework.stereotype.Service;
import org.thelovechurch.domain.FootprintsVO;
import org.thelovechurch.mapper.IntroduceMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class IntroduceServiceImpl implements IntroduceService {

	IntroduceMapper introduceMapper;
	
	@Override
	public Map<String, List<FootprintsVO>> get() {
		
		List<FootprintsVO> footDBList = introduceMapper.get();
		Map<String, List<FootprintsVO>> footprintsMap = new TreeMap<String, List<FootprintsVO>>(Collections.reverseOrder()); // 연도를 순서대로 나열하기 위해, Collections.reverseOrder()을 사용한다.
		
		for(int i=0; i < footDBList.size(); i++) {
			footprintsMap.put(footDBList.get(i).getYear(), null);
		}

		for( String key : footprintsMap.keySet() ) {
			List<FootprintsVO> imsiList = new ArrayList<FootprintsVO>();
			for(int i=0; i < footDBList.size(); i++) {
				if( key.equals(footDBList.get(i).getYear()) ) {
					imsiList.add(footDBList.get(i));
				}
			}
			log.info(imsiList);
			Collections.sort(imsiList, new Comparator<FootprintsVO>() {
				@Override
				public int compare(FootprintsVO obj1, FootprintsVO obj2) { // 같은 연도안에서, 월을 순서대로 나열하기 위해 Collection.sort를 호출한다. 
					return obj2.getMonth().compareTo(obj1.getMonth());
				}
			});
			footprintsMap.put(key, imsiList);
		}
		return footprintsMap;
	}

	@Override
	public int add(FootprintsVO vo) {
		return introduceMapper.add(vo);
	}

	@Override
	public int delete(FootprintsVO vo) {
		return introduceMapper.delete(vo);
	}

	@Override
	public boolean modify(FootprintsVO vo) {
		return introduceMapper.modify(vo) == 1 ? true : false;
	}

}
