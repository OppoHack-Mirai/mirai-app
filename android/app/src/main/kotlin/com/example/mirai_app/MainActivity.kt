package com.example.mirai_app

import android.content.res.AssetManager
import android.os.AsyncTask
import android.os.Build
import android.os.Bundle
import android.system.Os
import android.util.Log
import com.chaquo.python.PyException
import com.chaquo.python.PyObject
import com.chaquo.python.Python
import com.oplus.aiunit.core.AIUnit
import com.oplus.aiunit.core.callback.ConnectionCallback
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import xyz.andrewtran.MiraiServices
import java.io.File
import java.util.HashMap
import kotlin.io.path.createTempDirectory

class MainActivity: FlutterActivity() {
    companion object {
        @JvmStatic lateinit var filesDir: String
        @JvmStatic @Volatile var running: Boolean = false
        @JvmStatic lateinit var assets_real: AssetManager

        @JvmStatic
        fun createSymLink(symLinkFilePath: String, originalFilePath: String): Boolean {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    Os.symlink(originalFilePath, symLinkFilePath)
                    return true
                }
                val libcore = Class.forName("libcore.io.Libcore")
                val fOs = libcore.getDeclaredField("os")
                fOs.isAccessible = true
                val os = fOs.get(null)
                val method = os.javaClass.getMethod("symlink", String::class.java, String::class.java)
                method.invoke(os, originalFilePath, symLinkFilePath)
                return true
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return false
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState);
        Log.d("Test", "AIUnit Support: " + AIUnit.isAIUnitSupported(context));
        Log.d("Test", "Files Dir: $filesDir")
        MainActivity.filesDir = filesDir.absolutePath
        MainActivity.assets_real = assets
        MiraiServices.nodeFilesDirectory = File(filesDir, "node_files")

        // AI Unit
        if (AIUnit.isAIUnitSupported(context)) {
            Log.d("AndrewT1", "AIUnit Supported");
            AIUnit.init(context, object : ConnectionCallback {
                override fun onServiceConnect() {
                    Log.d("AndrewT1", "onServiceConnect")
                }

                override fun onServiceConnectFailed(p0: Int) {
                    Log.d("AndrewT1", "onServiceConnectFailed")
                }

                override fun onServiceDisconnect() {
                    Log.d("AndrewT1", "onServiceDisconnect")
                }
            }, true)
//
//            val detector = ImageClassify(context)
//            val errCode = detector.start()
//            Log.d("AndrewT1", "DETECTOR ERROR CODE: $errCode")

        } else {
            Log.d("AndrewT1", "AIUnit Not Supported");
        }
    }

    class ServicesTask: AsyncTask<String, Integer, String>() {
        override fun doInBackground(vararg p0: String?): String {
            Log.d("ANDREW-T3", "6");
            MiraiServices.startServer();
            return ""
        }
    }

    class NodeTask : AsyncTask<String, Integer, String>() {
        override fun doInBackground(vararg p0: String?): String {
            val _python: Python = Python.getInstance()
            val _sys: PyObject = _python.getModule("sys")
            val _os: PyObject = _python.getModule("os")
            val tempDir = createTempDirectory().toFile()
//            _os.callAttr("chdir", tempDir.absolutePath)
            _os.callAttr("chdir", filesDir)
            val _argv: PyObject? = _sys.get("argv")
            Log.d("ANDREW-T2", "Files dir: $filesDir")
            _argv?.asList()?.add(PyObject.fromJava("client"))
            _argv?.asList()?.add(PyObject.fromJava("9990"))
            _argv?.asList()?.add(PyObject.fromJava("android123"))
            _argv?.asList()?.add(PyObject.fromJava("http://164.90.159.145/"))
//            _argv?.asList()?.add(PyObject.fromJava(ngrokFile.absolutePath))
            val _console: PyObject = _python.getModule("main")
            Log.d("Python", "Starting node");
            running = true
            _console.callAttrThrows("main")
            running = false
            return ""
        }
    }

    fun _runPythonTextCode(): Map<String, Any?> {
        val _returnOutput: MutableMap<String, Any?> = HashMap()

        return try {
            val task = NodeTask();

            Log.d("ANDREW-T3", "1");
            task.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);
            Log.d("ANDREW-T3", "2");
            val task2 = ServicesTask();

            Log.d("ANDREW-T3", "3");
            task2.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR)

            Log.d("ANDREW-T3", "4");
            _returnOutput["success"] = "true"

            Log.d("ANDREW-T3", "5");
            _returnOutput
        } catch (e: PyException) {
            _returnOutput["success"] = "false"
            _returnOutput["error"] = e.message.toString()
            _returnOutput
        }
    }

    fun _stopNode() {
        val file = File(filesDir, "kill")
        file.createNewFile()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "chaquopy").setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "runPythonScript") {
                try {
                    val _result: Map<String, Any?> = _runPythonTextCode()
                    result.success(_result)
                } catch (e: Exception) {
                    val _result: MutableMap<String, Any?> = HashMap()
                    _result["error"] = e.message.toString()
                    result.success(_result)
                }
            } else if (call.method == "isRunning") {
                result.success(running)
            } else if (call.method == "stopNode") {
                _stopNode()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
