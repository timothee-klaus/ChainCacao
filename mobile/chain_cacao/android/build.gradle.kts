allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val isarNamespace = "dev.isar.isar_flutter_libs"
    
    plugins.withId("com.android.library") {
        val extension = project.extensions.findByType<com.android.build.gradle.LibraryExtension>()
        if (extension != null && extension.namespace == null) {
            extension.namespace = isarNamespace
        }
    }
    plugins.withId("com.android.application") {
        val extension = project.extensions.findByType<com.android.build.gradle.AppExtension>()
        if (extension != null && extension.namespace == null) {
            extension.namespace = isarNamespace
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
