package com.agx.sample.biz.task;

import com.agx.root.task.api.engine.TaskExecutionContext;
import com.agx.root.task.api.handler.BeanTaskHandler;
import org.springframework.stereotype.Component;

/**
 * 演示任务
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/27 22:48
 */
@Component
public class DemoTestTask implements BeanTaskHandler {

    /**
     * {@inheritDoc}
     */
    @Override
    public String getName() {
        return "测试任务处理";
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void execute(String params) throws Exception {
        TaskExecutionContext.log("测试");
    }
}
