package dev.clickbar.social_contact_tracker

import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.channels.FileChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val DATABASE_CHANNEL = "social_contact_tracker.clickbar.dev/database"
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        registerChannels(flutterEngine)
    }

    private fun registerChannels(flutterEngine: FlutterEngine) {

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DATABASE_CHANNEL
        ).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "export") {
                export(call, result)
            }
        }
    }

    private fun export(call: MethodCall, result: MethodChannel.Result) {

        val currentDBPath = call.argument<String>("dbPath")
        val exportFileName = call.argument<String>("fileName")

        try {
            val sd = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            if (sd.canWrite()) {
                val backupDBPath = File(sd, "/DSQSBackup/")
                backupDBPath.mkdirs()
                val currentDB = File(currentDBPath)
                val backupDB = File(backupDBPath, exportFileName)
                val src: FileChannel = FileInputStream(currentDB).getChannel()
                val dst: FileChannel = FileOutputStream(backupDB).getChannel()
                dst.transferFrom(src, 0, src.size())
                src.close()
                dst.close()
                println("backup complete")
                result.success(null)
            }
        } catch (e: java.lang.Exception) {
            println("backup failed")
            e.printStackTrace()
            result.error("FAIL", e.message, null)
        }

    }



}
