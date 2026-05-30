package com.agx.sample.biz.context;

import cn.hutool.extra.spring.SpringUtil;
import com.agx.sample.biz.service.DemoTestService;

/**
 * 演示服务上下文工具类
 * <p>提供静态方法获取任务相关的服务实例</p>
 *
 * @author gengchen
 * @since 2026/5/25
 */
public class DemoServiceContext {

    /**
     * 演示获取Service接口
     * <p></p>
     *
     * @return {@link DemoTestService}
     * @author gengchen
     * @since 2026/5/25
     */
    public static DemoTestService demoTestService() {
        return SpringUtil.getBean(DemoTestService.class);
    }

}
