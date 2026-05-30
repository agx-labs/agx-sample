package com.agx.sample.api.exception;

import cn.hutool.core.util.StrUtil;
import cn.stylefeng.roses.kernel.rule.exception.AbstractExceptionEnum;
import cn.stylefeng.roses.kernel.rule.exception.base.ServiceException;
import com.agx.sample.api.constants.DemoConstants;

/**
 * 业务模块异常类
 * <p></p>
 *
 * @author gengchen
 * @since 2026/4/16
 */
public class DemoException extends ServiceException {

    /**
     * 构造方法
     * <p></p>
     *
     * @param exception {@link AbstractExceptionEnum}
     * @param params    自定义参数
     * @author gengchen
     * @since 2026/4/16
     */
    public DemoException(AbstractExceptionEnum exception, Object... params) {
        super(DemoConstants.MODULE_NAME, exception.getErrorCode(), StrUtil.format(exception.getUserTip(), params));
    }

    /**
     * 构造方法
     * <p></p>
     *
     * @param exception {@link AbstractExceptionEnum}
     * @author gengchen
     * @since 2026/4/16 16:25
     */
    public DemoException(AbstractExceptionEnum exception) {
        super(DemoConstants.MODULE_NAME, exception);
    }
}