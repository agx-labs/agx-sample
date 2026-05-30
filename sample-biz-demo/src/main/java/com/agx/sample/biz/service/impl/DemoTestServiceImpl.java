package com.agx.sample.biz.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.convert.Convert;
import cn.stylefeng.roses.kernel.cache.api.CacheOperatorApi;
import cn.stylefeng.roses.kernel.db.api.factory.PageFactory;
import cn.stylefeng.roses.kernel.db.api.factory.PageResultFactory;
import cn.stylefeng.roses.kernel.db.api.pojo.page.PageResult;
import cn.stylefeng.roses.kernel.office.api.OfficeExcelApi;
import cn.stylefeng.roses.kernel.office.api.pojo.report.ExcelExportParam;
import com.agx.sample.api.exception.DemoException;
import com.agx.sample.api.exception.enums.DemoExceptionEnum;
import com.agx.sample.api.pojo.bo.DemoTestExcelBO;
import com.agx.sample.api.pojo.dto.DemoTestDTO;
import com.agx.sample.api.pojo.request.DemoTestRequest;
import com.agx.sample.biz.entity.DemoTest;
import com.agx.sample.biz.mapper.DemoTestMapper;
import com.agx.sample.biz.service.DemoTestService;
import com.alibaba.excel.support.ExcelTypeEnum;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

/**
 * 演示Service实现类
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
@Service
@Slf4j
public class DemoTestServiceImpl extends ServiceImpl<DemoTestMapper, DemoTest> implements DemoTestService {

    @Resource
    private OfficeExcelApi officeExcelApi;

    @Resource(name = "demoTestCache")
    private CacheOperatorApi<DemoTestDTO> demoTestCache;

    /**
     * 根据入参获取LambdaQueryWrapper
     * <p></p>
     *
     * @param request 入参 {@link DemoTestRequest}
     * @return {@link LambdaQueryWrapper}
     * @author gengchen
     * @since 2026/5/25
     */
    private LambdaQueryWrapper<DemoTest> getLambdaQueryWrapper(DemoTestRequest request) {
        return new LambdaQueryWrapper<DemoTest>()
                .eq(request.getId() != null, DemoTest::getId, request.getId())
                .eq(request.getStatus() != null, DemoTest::getStatus, request.getStatus());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public DemoTestDTO get(DemoTestRequest request) {
        DemoTest byId = this.getById(request.getId());
        if (byId == null) {
            throw new DemoException(DemoExceptionEnum.DATA_NOT_FOUND);
        }
        return BeanUtil.toBean(byId, DemoTestDTO.class);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public DemoTestDTO getOrNull(DemoTestRequest request) {
        try {
            return get(request);
        } catch (Exception ignored) {
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public DemoTestDTO getWithCache(DemoTestRequest request) {
        return demoTestCache.get(request.getId().toString());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<DemoTestDTO> getList(DemoTestRequest request) {
        List<DemoTest> list = this.list(getLambdaQueryWrapper(request).orderByDesc(DemoTest::getCreateTime));
        return Convert.toList(DemoTestDTO.class, list);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public PageResult<DemoTestDTO> getPage(DemoTestRequest request) {
        Page<DemoTest> page = this.page(PageFactory.defaultPage(request), getLambdaQueryWrapper(request).orderByDesc(DemoTest::getCreateTime));
        List<DemoTestDTO> pageDto = Convert.toList(DemoTestDTO.class, page.getRecords());
        return PageResultFactory.createPageResult(pageDto, page.getTotal(), Convert.toInt(page.getSize()), Convert.toInt(page.getCurrent()));
    }

    private void validate(DemoTestRequest request) {
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void add(DemoTestRequest request) {
        validate(request);
        DemoTest DemoTest = BeanUtil.toBean(request, DemoTest.class);
        this.save(DemoTest);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void edit(DemoTestRequest request) {
        validate(request);
        DemoTest task = BeanUtil.toBean(request, DemoTest.class);
        this.updateById(task);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delete(DemoTestRequest request) {
        DemoTestDTO DemoTest = get(request);
        this.removeById(DemoTest.getId());
    }


    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStatus(DemoTestRequest request) {
        DemoTestDTO DemoTest = get(request);
        DemoTest.setStatus(request.getStatus());
        this.updateById(BeanUtil.toBean(DemoTest, DemoTest.class));
    }


    @Override
    public void upload(DemoTestRequest request) throws IOException {
        List<DemoTestExcelBO> list = officeExcelApi.easyReadToList(request.getFile().getInputStream(), DemoTestExcelBO.class);
        //process business
    }

    @Override
    public void download(DemoTestRequest request, HttpServletResponse response) {
        List<DemoTestDTO> list = getList(request);
        List<DemoTestExcelBO> excelBOList = Convert.toList(DemoTestExcelBO.class, list);
        ExcelExportParam excelExportParam = new ExcelExportParam();
        excelExportParam.setExcelTypeEnum(ExcelTypeEnum.XLSX);
        excelExportParam.setClazz(DemoTestExcelBO.class);
        excelExportParam.setDataList(excelBOList);
        excelExportParam.setResponse(response);
        excelExportParam.setFileName("演示下载");
        this.officeExcelApi.easyExportDownload(excelExportParam);
    }

}