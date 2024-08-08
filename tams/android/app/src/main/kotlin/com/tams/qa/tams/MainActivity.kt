package com.tams.qa.tams

import android.content.Intent
import android.net.Uri
import android.content.pm.PackageManager
import android.content.pm.ApplicationInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.tams.browsers"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchUrlInBrowser") {
                val packageName = call.argument<String>("packageName")
                val url = call.argument<String>("url")
                if (packageName != null && url != null) {
                    launchUrlInBrowser(packageName, url)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENTS", "Package name or URL is missing", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun launchUrlInBrowser(packageName: String, url: String) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        intent.setPackage(packageName) // Set the package to launch the specific browser
        startActivity(intent)
    }
}
