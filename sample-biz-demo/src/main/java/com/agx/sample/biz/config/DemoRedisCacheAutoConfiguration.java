package com.agx.sample.biz.config;

import cn.stylefeng.roses.kernel.cache.api.CacheOperatorApi;
import cn.stylefeng.roses.kernel.cache.redis.util.CreateRedisTemplateUtil;
import com.agx.root.cache.api.CacheOperatorExtApi;
import com.agx.sample.api.pojo.dto.DemoTestDTO;
import com.agx.sample.biz.cache.DemoTestRedisCache;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;

/**
 * 演示Redis缓存自动配置类
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30
 */
@Configuration
@ConditionalOnClass(name = "org.springframework.data.redis.connection.RedisConnectionFactory")
public class DemoRedisCacheAutoConfiguration {

    /**
     * 演示Redis缓存的 Bean 定义
     * <p></p>
     *
     * @param redisConnectionFactory {@link RedisConnectionFactory}
     * @return {@link CacheOperatorApi}
     * @author gengchen
     * @since 2026/5/30
     */
    @Bean
    public CacheOperatorExtApi<DemoTestDTO> demoTestCache(RedisConnectionFactory redisConnectionFactory) {
        RedisTemplate<String, DemoTestDTO> redisTemplate = CreateRedisTemplateUtil.createObject(redisConnectionFactory);
        return new DemoTestRedisCache(redisTemplate);
    }


    /*
    原生Redis缓存的 Bean 定义
    @Bean
    public CacheOperatorApi<DemoTestDTO> demoTestCache(RedisConnectionFactory redisConnectionFactory) {
        RedisTemplate<String, DemoTestDTO> redisTemplate = CreateRedisTemplateUtil.createObject(redisConnectionFactory);
        return new DemoTestRedisCache(redisTemplate);
    }*/
}
