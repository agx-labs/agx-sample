package com.agx.sample.api.enums.demo;

import cn.hutool.core.util.StrUtil;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;

/**
 * 演示枚举
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/24
 */
@AllArgsConstructor
@Getter
public enum DemoTestEnum {

    SUCCESS("success", "成功"),

    FAIL("fail", "失败"),

    RUNNING("running", "运行中");

    /**
     * 编码
     */
    private final String code;
    /**
     * 名称
     */
    private final String name;

    /**
     * 根据编码获取枚举
     * <p></p>
     *
     * @param code 编码
     * @return 处理结果枚举 {@link DemoTestEnum}
     * @author gengchen
     * @since 2026/5/24
     */
    public static DemoTestEnum getEnum(String code) {
        return Arrays.stream(values()).filter(aEnum -> StrUtil.equals(code, aEnum.getCode())).findAny().orElse(null);
    }
}