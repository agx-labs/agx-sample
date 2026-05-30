package com.agx.sample.biz.cache;

import cn.hutool.cache.impl.TimedCache;
import cn.stylefeng.roses.kernel.cache.memory.AbstractMemoryCacheOperator;
import com.agx.sample.api.pojo.dto.DemoTestDTO;

/**
 * 演示内存Cache
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30 19:07
 */
public class DemoTestMemoryCache extends AbstractMemoryCacheOperator<DemoTestDTO> {

    /**
     * 构造方法
     * <p></p>
     *
     * @param timedCache {@link TimedCache}
     * @author gengchen
     * @since 2026/5/30
     */
    public DemoTestMemoryCache(TimedCache<String, DemoTestDTO> timedCache) {
        super(timedCache);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String getCommonKeyPrefix() {
        return "demo_test:";
    }
}
