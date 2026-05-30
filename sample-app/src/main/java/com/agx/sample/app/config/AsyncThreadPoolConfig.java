package com.agx.sample.app.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * 异步线程池配置类
 * <p></p>
 *
 * @author gengchen
 * @since 2026/5/30
 */
@EnableAsync
@Configuration
@Slf4j
public class AsyncThreadPoolConfig implements AsyncConfigurer {
    /**
     * 默认核心线程数
     */
    private static final int DEFAULT_CORE_POOL_SIZE = 50;
    /**
     * 默认最大线程数
     */
    private static final int DEFAULT_MAX_POOL_SIZE = 100;
    /**
     * 默认队列大小
     */
    private static final int DEFAULT_QUEUE_CAPACITY = 99999;

    /**
     * 配置异步线程池
     * <p></p>
     *
     * @return 定义bean
     * @author gengchen
     * @since 2026/5/30
     */
    @Bean
    public Executor taskExecutor() {
        // Spring 默认配置是核心线程数大小为1，最大线程容量大小不受限制，队列容量也不受限制。
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        // 核心线程数
        executor.setCorePoolSize(DEFAULT_CORE_POOL_SIZE);
        // 最大线程数
        executor.setMaxPoolSize(DEFAULT_MAX_POOL_SIZE);
        // 队列大小
        executor.setQueueCapacity(DEFAULT_QUEUE_CAPACITY);
        // 当最大池已满时，此策略保证不会丢失任务请求，但是可能会影响应用程序整体性能。
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.setThreadNamePrefix("异步线程-");
        executor.initialize();
        return executor;
    }

}