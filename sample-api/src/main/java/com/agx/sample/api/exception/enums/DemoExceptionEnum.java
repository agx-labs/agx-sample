package com.agx.sample.api.exception.enums;

import cn.stylefeng.roses.kernel.rule.constants.RuleConstants;
import cn.stylefeng.roses.kernel.rule.exception.AbstractExceptionEnum;
import com.agx.sample.api.constants.DemoConstants;
import lombok.Getter;

/**
 * 异常枚举
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30
 */
@Getter
public enum DemoExceptionEnum implements AbstractExceptionEnum {

    PARAM_VALIDATION_FAILED(RuleConstants.USER_OPERATION_ERROR_TYPE_CODE, "100", "业务参数校验失败 {}"),

    DATA_NOT_FOUND(RuleConstants.BUSINESS_ERROR_TYPE_CODE, "102", "数据不存在 {}"),

    HTTP_REQUEST_ERROR(RuleConstants.THIRD_ERROR_TYPE_CODE, "103", "HTTP 请求失败 {}"),
    ;

    /**
     * 错误编码
     */
    private final String errorCode;

    /**
     * 提示用户信息
     */
    private final String userTip;

    /**
     * 构造方法
     * <p></p>
     *
     * @param errorType 错误类型
     * @param errorCode 错误码
     * @param userTip   用户提示
     * @author gengchen
     * @since 2026/5/24 23:15
     */
    DemoExceptionEnum(String errorType, String errorCode, String userTip) {
        this.errorCode = errorType + DemoConstants.EXCEPTION_STEP_CODE + errorCode;
        this.userTip = userTip;
    }
}
