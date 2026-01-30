package com.menusidekick.gabebae

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.menusidekick.gabebae/iap"
    private lateinit var iapHandler: IAPHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        iapHandler = IAPHandler(this)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        iapHandler.initialize(channel)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "purchaseProduct" -> {
                    val productId = call.argument<String>("productId")
                    if (productId != null) {
                        iapHandler.purchaseProduct(productId, result)
                    } else {
                        result.error("INVALID_ARGUMENT", "Product ID is required", null)
                    }
                }
                "restorePurchases" -> {
                    iapHandler.restorePurchases(result)
                }
                else -> result.notImplemented()
            }
        }
    }
}