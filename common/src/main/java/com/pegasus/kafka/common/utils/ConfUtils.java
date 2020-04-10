package com.pegasus.kafka.common.utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.security.auth.login.AppConfigurationEntry;
import javax.security.auth.login.Configuration;

/**
 * 功能详细描述
 *
 * @version [V100R003C00, 2017/10/24 14:25 ]
 * @Author: w00421586 E-mail:wangming49@huawei.com
 */
public class ConfUtils {
    
    /**
     * line operator string
     */
    private static final String LINE_SEPARATOR = System.getProperty("line.separator");
    
    private static final String KAFKA_CLIENT_JAAS = "kafka_client_jaas.conf";
    
    private static final String JAVA_SECURITY_LOGIN_CONF = "java.security.auth.login.config";
    
    /**
     * 加密算法：HMAC_SHA_256
     */
    private static final String HMAC_SHA_256 = "hmacSHA256";
    
    /**
     * SHA-256加密后的密文长度：32
     */
    private static final int SHA256_SIZE = 256 / Byte.SIZE;
    
    /**
     * 十六进制无符号数形式的字符串的长度
     */
    private static final int HEX_STR_SIZE = 2;
    
    /**
     * 字节掩码
     */
    private static final int BYTEMASK = 0xff;
    
    /**
     * 设置jaas.conf文件
     * setJaasFile("kafka", mac + ':' + salt)
     * kafka为用户名，mac是调用hmacEncode得到的加密后米未，salt是盐值
     *
     * @param username the username
     * @param password the password
     * @throws IOException the io exception
     */
    public static void setJaasFile(final String username, final String password) {
        // String jaasPath = new File(System.getProperty("java.io.tmpdir")).getPath() + File.separator +
        // KAFKA_CLIENT_JAAS;
        
        Configuration.setConfiguration(new Configuration() {
            private Configuration defaultConfiguration = Configuration.getConfiguration();
            
            /** {@inheritDoc} */
            @Override
            public void refresh() {
            }
            
            /** {@inheritDoc} */
            @Override
            public AppConfigurationEntry[] getAppConfigurationEntry(String appName) {
                Map<String, Object> options = new HashMap<String, Object>();
                options.put("username", username);
                options.put("password", password);
                AppConfigurationEntry entry = null;
                if (!"KafkaClient".equals(appName)) {
                    return defaultConfiguration.getAppConfigurationEntry(appName);
                } else if ("user_sansuo".equals(username)) {
                    entry = new AppConfigurationEntry("org.apache.kafka.common.security.plain.PlainLoginModule",
                        AppConfigurationEntry.LoginModuleControlFlag.REQUIRED, options);
                } else {
                    entry = new AppConfigurationEntry("org.apache.kafka.common.security.plain.ExtPlainLoginModule",
                        AppConfigurationEntry.LoginModuleControlFlag.REQUIRED, options);
                }
                
                return new AppConfigurationEntry[] {entry};
            }
        });
    }
    
    /**
     * 写入jaas文件
     *
     * @throws IOException 写文件异常
     */
    private static void writeJaasFile(String jaasPath, String principal, String keytabPath) throws IOException {
        FileWriter writer = new FileWriter(new File(jaasPath));
        try {
            writer.write(getJaasConfContext(principal, keytabPath));
            writer.flush();
        } catch (IOException e) {
            throw new IOException("Failed to create jaas.conf File");
        } finally {
            writer.close();
        }
    }
    
    private static void deleteJaasFile(String jaasPath) throws IOException {
        File jaasFile = new File(jaasPath);
        if (jaasFile.exists()) {
            if (!jaasFile.delete()) {
                throw new IOException("Failed to delete exists jaas file.");
            }
        }
    }
    
    private static String getJaasConfContext(String username, String password) {
        Module[] allModule = Module.values();
        StringBuilder builder = new StringBuilder();
        builder.append(getModuleContext(username, password, Module.KAFKA));
        return builder.toString();
    }
    
    private static String getModuleContext(String username, String password, Module module) {
        StringBuilder builder = new StringBuilder();
        builder.append(module.getName()).append(" {").append(LINE_SEPARATOR);
        builder.append("org.apache.kafka.common.security.plain.ExtPlainLoginModule required").append(LINE_SEPARATOR);
        builder.append("username=\"" + username + "\"").append(LINE_SEPARATOR);
        builder.append("password=\"" + password + "\";").append(LINE_SEPARATOR);
        builder.append("};").append(LINE_SEPARATOR);
        return builder.toString();
    }
    
    public static void main(String[] args) {
        ConfUtils.setJaasFile("kafka", "password");
    }
    
    /**
     * Hmac encode string.
     *
     * @param data the data
     * @param salt the salt
     * @return the string
     */
    public static String hmacEncode(byte[] data, byte[] salt) {
        try {
            Mac hmacSha256 = Mac.getInstance(HMAC_SHA_256);
            hmacSha256.reset();
            
            SecretKeySpec secret = new SecretKeySpec(salt, HMAC_SHA_256);
            hmacSha256.init(secret);
            byte[] b = hmacSha256.doFinal(data);
            StringBuilder output = new StringBuilder(SHA256_SIZE);
            
            // 定义一个临时变量
            String tmp = "";
            for (int i = 0; i < b.length; i++) {
                // 以十六进制无符号整数形式返回一个整数参数的字符串
                tmp = Integer.toHexString(b[i] & BYTEMASK);
                if (tmp.length() < HEX_STR_SIZE) {
                    output.append('0');
                }
                output.append(tmp);
            }
            
            return output.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * The enum Module.
     */
    public enum Module {
        /**
         * Storm module.
         */
        STORM("StormClient"),
        /**
         * Kafka module.
         */
        KAFKA("KafkaClient"),
        /**
         * Zookeeper module.
         */
        ZOOKEEPER("Client");
        
        private String name;
        
        private Module(String name) {
            this.name = name;
        }
        
        /**
         * Gets name.
         *
         * @return the name
         */
        public String getName() {
            return name;
        }
    }
}
