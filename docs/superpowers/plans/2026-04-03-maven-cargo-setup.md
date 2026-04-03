# Maven + Cargo Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `pom.xml` with Cargo plugin so the app runs via `mvn cargo:run` without a separate Tomcat install.

**Architecture:** Keep existing `src/` and `webapp/` layout. Configure Maven war plugin to point at these non-standard directories. Cargo embeds Tomcat 10.1 (Jakarta Servlet 6.0 compatible) and deploys the WAR at context path `/webapp`.

**Tech Stack:** Maven 3.x, cargo-maven3-plugin 1.10.12, Tomcat 10.1 (embedded), Jakarta Servlet 6.0, JSTL 3.0, MySQL Connector/J 9.1.0

---

### Task 1: Create pom.xml

**Files:**
- Create: `pom.xml`

- [ ] **Step 1: Create pom.xml at project root**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.eyehospital</groupId>
    <artifactId>btl-web</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <!-- Servlet API - provided by Tomcat at runtime -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
        </dependency>

        <!-- JSTL API -->
        <dependency>
            <groupId>jakarta.servlet.jsp.jstl</groupId>
            <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
            <version>3.0.0</version>
        </dependency>

        <!-- JSTL Implementation -->
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>jakarta.servlet.jsp.jstl</artifactId>
            <version>3.0.1</version>
        </dependency>

        <!-- MySQL Connector -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>9.1.0</version>
        </dependency>
    </dependencies>

    <build>
        <!-- Point Maven at the existing src/ directory -->
        <sourceDirectory>src</sourceDirectory>

        <plugins>
            <!-- WAR plugin: point at existing webapp/ directory -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.4.0</version>
                <configuration>
                    <warSourceDirectory>webapp</warSourceDirectory>
                    <failOnMissingWebXml>false</failOnMissingWebXml>
                </configuration>
            </plugin>

            <!-- Cargo: embed Tomcat 10.1, run with mvn cargo:run -->
            <plugin>
                <groupId>org.codehaus.cargo</groupId>
                <artifactId>cargo-maven3-plugin</artifactId>
                <version>1.10.12</version>
                <configuration>
                    <container>
                        <containerId>tomcat10x</containerId>
                        <type>embedded</type>
                    </container>
                    <configuration>
                        <properties>
                            <cargo.servlet.port>8080</cargo.servlet.port>
                        </properties>
                    </configuration>
                    <deployables>
                        <deployable>
                            <properties>
                                <context>/webapp</context>
                            </properties>
                        </deployable>
                    </deployables>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

- [ ] **Step 2: Commit pom.xml**

```bash
git add pom.xml
git commit -m "feat: add pom.xml with Maven + Cargo embedded Tomcat 10 setup"
```

---

### Task 2: Remove old JARs from webapp/WEB-INF/lib/

Maven will manage all dependencies and place them in `WEB-INF/lib/` at build time. The existing physical JARs must be removed to avoid duplicates or version conflicts.

**Files:**
- Delete: `webapp/WEB-INF/lib/jakarta.servlet-api-6.0.0 (1).jar`
- Delete: `webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-3.0.1.jar`
- Delete: `webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-api-3.0.0.jar`
- Delete: `webapp/WEB-INF/lib/mysql-connector-j-9.6.0.jar`
- Delete: `webapp/WEB-INF/lib/servlet-api.jar`

- [ ] **Step 1: Delete all JARs**

```bash
rm "webapp/WEB-INF/lib/jakarta.servlet-api-6.0.0 (1).jar"
rm webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-3.0.1.jar
rm webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-api-3.0.0.jar
rm webapp/WEB-INF/lib/mysql-connector-j-9.6.0.jar
rm webapp/WEB-INF/lib/servlet-api.jar
```

- [ ] **Step 2: Verify lib/ is empty**

```bash
ls webapp/WEB-INF/lib/
```

Expected: empty output (no files listed).

- [ ] **Step 3: Commit JAR removal**

```bash
git add webapp/WEB-INF/lib/
git commit -m "chore: remove manually-managed JARs, now handled by Maven"
```

---

### Task 3: Verify build and run

- [ ] **Step 1: Compile the project**

```bash
mvn compile
```

Expected: `BUILD SUCCESS`. If you see import errors for `jakarta.*` classes, check that pom.xml was saved correctly.

- [ ] **Step 2: Run with embedded Tomcat**

```bash
mvn cargo:run
```

Expected output includes:
```
[INFO] Press Ctrl-C to stop the container...
```
Cargo will download Tomcat 10.1 on first run (one-time, ~10MB).

- [ ] **Step 3: Verify app is accessible**

Open browser: `http://localhost:8080/webapp/`

Expected: redirected to `http://localhost:8080/webapp/auth/login` (AuthFilter redirects unauthenticated users).

- [ ] **Step 4: Stop the server**

Press `Ctrl+C` in the terminal running `mvn cargo:run`.