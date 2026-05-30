package com.agx.sample.api;

import cn.stylefeng.roses.kernel.db.api.pojo.page.PageResult;
import com.agx.sample.api.pojo.dto.DemoTestDTO;
import com.agx.sample.api.pojo.request.DemoTestRequest;

import java.util.List;

/**
 * 演示API接口
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
public interface DemoTestApi {

    /**
     * 演示获取数据
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 出参 {@link DemoTestDTO}
     * @author gengchen
     * @since 2026/5/25
     */
    DemoTestDTO get(DemoTestRequest request);

    /**
     * 演示获取数据
     * <p>为空返回null</p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 出参 {@link DemoTestDTO}
     * @author gengchen
     * @since 2026/5/25
     */
    DemoTestDTO getOrNull(DemoTestRequest request);

    /**
     * 演示获取缓存数据
     * <p>为空返回null</p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 出参 {@link DemoTestDTO}
     * @author gengchen
     * @since 2026/5/25
     */
    DemoTestDTO getWithCache(DemoTestRequest request);

    /**
     * 演示获取数据列表
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 出参
     * @author gengchen
     * @since 2026/5/30
     */
    List<DemoTestDTO> getList(DemoTestRequest request);

    /**
     * 演示获取数据分页
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 出参 {@link PageResult}
     * @author gengchen
     * @since 2026/5/30
     */
    PageResult<DemoTestDTO> getPage(DemoTestRequest request);
}
