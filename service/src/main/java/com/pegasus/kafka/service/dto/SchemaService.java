package com.pegasus.kafka.service.dto;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.google.common.base.Splitter;
import com.pegasus.kafka.common.annotation.TranRead;
import com.pegasus.kafka.common.annotation.TranSave;
import com.pegasus.kafka.entity.dto.TopicRecord;
import com.pegasus.kafka.mapper.SchemaMapper;
import com.pegasus.kafka.service.property.PropertyService;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.sql.DataSource;

/**
 * The service for initiate the database and tables.
 * <p>
 * *****************************************************************
 * Name               Action            Time          Description  *
 * Ning.Zhang       Initialize         11/7/2019      Initialize   *
 * *****************************************************************
 */
@Service
public class SchemaService extends ServiceImpl<SchemaMapper, TopicRecord> {
    
    @Value("classpath:schema.sql")
    private Resource sql;
    
    @Autowired
    public DataSource dataSource;
    
    private final PropertyService propertyService;
    
    public SchemaService(PropertyService propertyService) {
        this.propertyService = propertyService;
    }
    
    @TranSave
    public void createTableIfNotExists() {
        try (Connection connection = dataSource.getConnection()) {
            byte[] test = IOUtils.toByteArray(sql.getInputStream());
            String sqlString = new String(test, StandardCharsets.UTF_8);
            List<String> sqls = Splitter.on(';').omitEmptyStrings().splitToList(sqlString);
            for (String s : sqls) {
                PreparedStatement preparedStatement = connection.prepareStatement(s);
                preparedStatement.execute();
            }
        } catch (Exception e) {
            log.error("execute error {}", ExceptionUtils.getRootCause(e));
        }
    }
    
    @TranSave
    public void deleteExpired(Set<String> tableNames) {
        Date now = new Date();
        Date date = DateUtils.addDays(now, -propertyService.getDbRetentionDays());
        this.baseMapper.deleteExpired(propertyService.getDbName(), tableNames, date);
    }
    
    @TranRead
    public Set<String> listTables() {
        //String databaseName = Common.trim(propertyService.getDbName(), "");
        return this.baseMapper.listTables(propertyService.getDbName());
    }
}
