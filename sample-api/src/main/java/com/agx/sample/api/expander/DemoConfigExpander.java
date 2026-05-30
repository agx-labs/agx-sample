package com.agx.sample.api.expander;

import cn.stylefeng.roses.kernel.config.api.context.ConfigContext;
import cn.stylefeng.roses.kernel.rule.enums.YesOrNotEnum;

/**
 * 演示系统配置
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30 18:35
 */
public class DemoConfigExpander {

    /**
     * 演示获取系统配置
     * <p></p>
     *
     * @return 值
     * @author gengchen
     * @since 2026/5/30
     */
    public static String getTestEnable() {
        return ConfigContext.me().getSysConfigValueWithDefault("TEST_ENABLE", String.class, YesOrNotEnum.N.getCode());
    }

}
