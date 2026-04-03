# Maven + Cargo Setup Design

**Date:** 2026-04-03  
**Topic:** Convert project to Maven with embedded Tomcat 10 via Cargo plugin

## Goal

Replace the manual JAR-based build with Maven so the project can be compiled and run with a single command (`mvn cargo:run`), without needing a separately installed Tomcat.

## Approach

Add `pom.xml` at the project root. Keep the existing `src/` and `webapp/` directory layout unchanged — Maven is configured to use these non-standard paths. Replace the physical JARs in `webapp/WEB-INF/lib/` with Maven-managed dependencies.

## Directory Layout (unchanged)

```
BTL_Web/
├── pom.xml              ← NEW
├── src/                 ← Java sources (unchanged)
├── webapp/
│   ├── WEB-INF/
│   │   ├── web.xml      ← unchanged
│   │   └── lib/         ← JARs REMOVED (Maven manages these)
│   ├── static/          ← unchanged
│   └── views/           ← unchanged
└── database/            ← unchanged
```

## pom.xml Configuration

### Build paths

```xml
<build>
  <sourceDirectory>src</sourceDirectory>
  <plugins>
    <plugin>
      <artifactId>maven-war-plugin</artifactId>
      <configuration>
        <warSourceDirectory>webapp</warSourceDirectory>
      </configuration>
    </plugin>
  </plugins>
</build>
```

### Dependencies

| Artifact | Version | Scope |
|---|---|---|
| `jakarta.servlet:jakarta.servlet-api` | 6.0.0 | `provided` |
| `jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api` | 3.0.0 | compile |
| `org.glassfish.web:jakarta.servlet.jsp.jstl` | 3.0.1 | compile |
| `com.mysql:mysql-connector-j` | 9.1.0 | compile |

Servlet API is `provided` because the embedded Tomcat container supplies it at runtime.

### Cargo Plugin

```xml
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
```

- `tomcat10x` — Tomcat 10.1, supports Jakarta Servlet 6.0
- `embedded` — Cargo downloads Tomcat automatically, no install needed
- Context path `/webapp` — keeps the existing URL: `http://localhost:8080/webapp/`

## JAR Cleanup

Delete all files from `webapp/WEB-INF/lib/`:
- `jakarta.servlet-api-6.0.0 (1).jar`
- `jakarta.servlet.jsp.jstl-3.0.1.jar`
- `jakarta.servlet.jsp.jstl-api-3.0.0.jar`
- `mysql-connector-j-9.6.0.jar`
- `servlet-api.jar`

Maven will populate `WEB-INF/lib/` with the correct JARs at build/run time.

## Run Instructions

```bash
# First-time setup: initialize DB
mysql -u root -p < database/database.sql

# Run the app
mvn cargo:run

# Access at
http://localhost:8080/webapp/
```

## What Does NOT Change

- All Java source files in `src/`
- All JSP files in `webapp/views/`
- `webapp/WEB-INF/web.xml`
- `webapp/static/`
- `src/util/DBConnection.java` credentials
- Database schema