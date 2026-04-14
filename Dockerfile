FROM amazoncorretto:8

# Tomcat9のインストール
RUN yum update -y && \
    yum install -y tar gzip curl && \
    TOMCAT_VERSION=9.0.117 && \
    curl -fSL "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" \
         -o "apache-tomcat-${TOMCAT_VERSION}.tar.gz" && \
    curl -fSL "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512" \
         -o "apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512" && \
    sha512sum -c "apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512" && \
    tar -xzf "apache-tomcat-${TOMCAT_VERSION}.tar.gz" && \
    mv "apache-tomcat-${TOMCAT_VERSION}" /usr/local/tomcat && \
    rm -f "apache-tomcat-${TOMCAT_VERSION}.tar.gz" "apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512" && \
    yum clean all && \
    rm -rf /var/cache/yum

# sample.warをTomcatのwebappsディレクトリにコピー
COPY ./sample.war /usr/local/tomcat/webapps/

# Tomcatのポートを公開
EXPOSE 8080

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD curl -f http://localhost:8080/sample/ || exit 1

# Tomcatを起動
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]