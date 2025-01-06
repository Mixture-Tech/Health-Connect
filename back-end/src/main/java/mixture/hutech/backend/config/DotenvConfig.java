package mixture.hutech.backend.config;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class DotenvConfig implements EnvironmentPostProcessor {

    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
        // Nạp các biến từ file .env
        Dotenv dotenv = Dotenv.configure()
                .directory("./")   // Đặt thư mục chứa file .env
                .filename(".env")  // Tên file .env
                .ignoreIfMalformed() // Bỏ qua nếu file bị hỏng
                .ignoreIfMissing()   // Bỏ qua nếu file không tồn tại
                .load();

        // Tạo một Map để chứa các biến môi trường từ .env
        Map<String, Object> dotenvMap = new HashMap<>();

        // Đưa từng biến vào Map, key là tên biến và value là giá trị biến
        dotenv.entries().forEach(entry -> dotenvMap.put(entry.getKey(), entry.getValue()));

        // Thêm Map này vào PropertySource của Spring Environment
        environment.getPropertySources().addLast(new MapPropertySource("dotenvProperties", dotenvMap));
    }
}
