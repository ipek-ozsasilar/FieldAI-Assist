package com.example.fieldai_assist

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val documentChannel = "fieldai_assist/document_opener"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, documentChannel)
            .setMethodCallHandler { call, result ->
                if (call.method != "openUrl") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val url = call.argument<String>("url")

                if (url.isNullOrBlank()) {
                    result.error("EMPTY_URL", "Document URL is empty.", null)
                    return@setMethodCallHandler
                }

                try {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).apply {
                        addCategory(Intent.CATEGORY_BROWSABLE)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }

                    startActivity(intent)
                    result.success(true)
                } catch (error: ActivityNotFoundException) {
                    result.error("NO_APP", "No app can open this document.", null)
                } catch (error: Exception) {
                    result.error("OPEN_FAILED", error.message, null)
                }
            }
    }
}
