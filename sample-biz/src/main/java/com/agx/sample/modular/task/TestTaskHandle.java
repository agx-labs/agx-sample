package com.agx.sample.modular.task;

import com.agx.root.task.api.engine.TaskExecutionContext;
import com.agx.root.task.api.handler.TaskHandler;
import org.springframework.stereotype.Component;

/**
 *
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/27 22:48
 */
@Component
public class TestTaskHandle implements TaskHandler {

    @Override
    public String getName() {
        return "测试任务处理";
    }

    @Override
    public void execute(String params) throws Exception {
        TaskExecutionContext.log("测试");
    }
}
