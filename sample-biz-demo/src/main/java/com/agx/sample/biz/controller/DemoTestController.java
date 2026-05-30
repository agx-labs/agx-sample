package com.agx.sample.biz.controller;

import cn.stylefeng.roses.kernel.db.api.pojo.page.PageResult;
import cn.stylefeng.roses.kernel.rule.pojo.request.BaseRequest;
import cn.stylefeng.roses.kernel.rule.pojo.response.ResponseData;
import cn.stylefeng.roses.kernel.rule.pojo.response.SuccessResponseData;
import cn.stylefeng.roses.kernel.scanner.api.annotation.ApiResource;
import cn.stylefeng.roses.kernel.scanner.api.annotation.PostResource;
import com.agx.sample.api.pojo.dto.DemoTestDTO;
import com.agx.sample.api.pojo.request.DemoTestRequest;
import com.agx.sample.biz.entity.DemoTest;
import com.agx.sample.biz.service.DemoTestService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

/**
 * 演示控制器
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
@RestController
@Slf4j
@ApiResource(name = "演示控制器", path = "/demo/test")
public class DemoTestController {

    @Resource
    private DemoTestService demoTestService;

    /**
     * 演示添加
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 响应结果
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示添加", path = "/add")
    public ResponseData<?> add(@RequestBody @Validated(BaseRequest.add.class) DemoTestRequest request) {
        demoTestService.add(request);
        return new SuccessResponseData<>();
    }

    /**
     * 演示编辑
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 响应结果
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示编辑", path = "/edit")
    public ResponseData<?> edit(@RequestBody @Validated(BaseRequest.edit.class) DemoTestRequest request) {
        demoTestService.edit(request);
        return new SuccessResponseData<>();
    }

    /**
     * 演示删除
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 响应结果
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示删除", path = "/delete")
    public ResponseData<?> delete(@RequestBody @Validated(BaseRequest.delete.class) DemoTestRequest request) {
        demoTestService.delete(request);
        return new SuccessResponseData<>();
    }

    /**
     * 演示获取详情
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return {@link DemoTest}
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示获取详情", path = "/get")
    public ResponseData<DemoTestDTO> get(@RequestBody DemoTestRequest request) {
        return new SuccessResponseData<>(demoTestService.get(request));
    }

    /**
     * 演示获取列表
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 列表
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示获取列表", path = "/list")
    public ResponseData<List<DemoTestDTO>> list(@RequestBody DemoTestRequest request) {
        return new SuccessResponseData<>(demoTestService.getList(request));
    }

    /**
     * 演示获取分页
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 分页
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示获取分页", path = "/page")
    public ResponseData<PageResult<DemoTestDTO>> page(@RequestBody DemoTestRequest request) {
        return new SuccessResponseData<>(demoTestService.getPage(request));
    }

    /**
     * 演示更新状态
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 响应结果
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示更新状态", path = "/updateStatus")
    public ResponseData<?> updateStatus(@RequestBody DemoTestRequest request) {
        demoTestService.updateStatus(request);
        return new SuccessResponseData<>();
    }


    /**
     * 演示上传
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return 响应结果
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示上传", path = "/upload")
    public ResponseData<?> upload(@RequestBody DemoTestRequest request) throws IOException {
        demoTestService.upload(request);
        return new SuccessResponseData<>();
    }


    /**
     * 演示下载
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @author gengchen
     * @since 2026/5/25
     */
    @PostResource(name = "演示下载", path = "/download")
    public void download(DemoTestRequest request, HttpServletResponse response) {
        demoTestService.download(request, response);
    }

}