FROM amazoncorretto:8

# Tomcat9のインストール
RUN yum update -y && \
    yum install -y tar gzip && \
    curl -O https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.117/bin/apache-tomcat-9.0.117.tar.gz && \
    tar -xzf apache-tomcat-9.0.117.tar.gz && \
    mv apache-tomcat-9.0.117 /usr/local/tomcat && \
    rm apache-tomcat-9.0.117.tar.gz && \
    yum clean all

# sample.warをTomcatのwebappsディレクトリにコピー
COPY ./sample.war /usr/local/tomcat/webapps/

# Tomcatのポートを公開
EXPOSE 8080

# Tomcatを起動
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"] 