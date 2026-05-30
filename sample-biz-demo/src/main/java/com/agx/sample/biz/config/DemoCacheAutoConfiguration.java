package com.agx.sample.biz.config;

import cn.hutool.cache.CacheUtil;
import cn.hutool.cache.impl.TimedCache;
import cn.stylefeng.roses.kernel.cache.api.CacheOperatorApi;
import cn.stylefeng.roses.kernel.sys.api.constants.SysConstants;
import com.agx.sample.api.pojo.dto.DemoTestDTO;
import com.agx.sample.biz.cache.DemoTestMemoryCache;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingClass;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 演示内存缓存的自动配置类
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30
 */
@Configuration
@ConditionalOnMissingClass("org.springframework.data.redis.connection.RedisConnectionFactory")
public class DemoCacheAutoConfiguration {

    /**
     * 演示内存缓存的 Bean 定义
     * <p></p>
     *
     * @return {@link CacheOperatorApi}
     * @author gengchen
     * @since 2026/5/30
     */
    @Bean
    public CacheOperatorApi<DemoTestDTO> demoTestCache() {
        TimedCache<String, DemoTestDTO> themeCache = CacheUtil.newTimedCache(1000 * SysConstants.DEFAULT_SYS_CACHE_TIMEOUT_SECONDS);
        return new DemoTestMemoryCache(themeCache);
    }

}
