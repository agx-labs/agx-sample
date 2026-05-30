package com.agx.sample.biz.cache;

import com.agx.root.cache.redis.AbstractRedisCacheExtOperator;
import com.agx.sample.api.pojo.dto.DemoTestDTO;
import org.springframework.data.redis.core.RedisTemplate;

/**
 * 演示RedisCache
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30 19:07
 */
public class DemoTestRedisCache extends AbstractRedisCacheExtOperator<DemoTestDTO> {
/*
原生Redis操纵类
public class DemoTestRedisCache extends AbstractRedisCacheOperator<DemoTestDTO> {
*/

    /**
     * 构造方法
     * <p></p>
     *
     * @param redisTemplate {@link RedisTemplate}
     * @author gengchen
     * @since 2026/5/30
     */
    public DemoTestRedisCache(RedisTemplate<String, DemoTestDTO> redisTemplate) {
        super(redisTemplate);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getCommonKeyPrefix() {
        return "demo_test:";
    }
}
