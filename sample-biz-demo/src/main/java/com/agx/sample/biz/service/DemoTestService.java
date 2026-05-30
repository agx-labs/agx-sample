package com.agx.sample.biz.service;

import com.agx.sample.api.DemoTestApi;
import com.agx.sample.api.pojo.request.DemoTestRequest;
import com.agx.sample.biz.entity.DemoTest;
import com.baomidou.mybatisplus.extension.service.IService;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 演示服务接口
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
public interface DemoTestService extends IService<DemoTest>, DemoTestApi {

    /**
     * 演示添加
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @author gengchen
     * @since 2026/5/25
     */
    void add(DemoTestRequest request);

    /**
     * 编演示辑
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @author gengchen
     * @since 2026/5/25
     */
    void edit(DemoTestRequest request);

    /**
     * 演示删除
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @author gengchen
     * @since 2026/5/25
     */
    void delete(DemoTestRequest request);

    /**
     * 演示更新状态
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @author gengchen
     * @since 2026/5/25
     */
    void updateStatus(DemoTestRequest request);

    /**
     * 演示上传
     * <p></p>
     *
     * @param request 入参{@link DemoTestRequest}
     * @author gengchen
     * @since 2026/5/30
     */
    void upload(DemoTestRequest request) throws IOException;

    /**
     * 演示下载
     * <p></p>
     *
     * @param request  入参 {@link DemoTestRequest}
     * @param response 出参 {@link HttpServletResponse}
     * @author gengchen
     * @since 2026/5/30
     */
    void download(DemoTestRequest request, HttpServletResponse response);
}