package com.menusidekick.gabebae

import android.app.Activity
import com.android.billingclient.api.*
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class IAPHandler(private val activity: Activity) : PurchasesUpdatedListener {

    private var billingClient: BillingClient? = null
    private var methodChannel: MethodChannel? = null

    fun initialize(channel: MethodChannel) {
        methodChannel = channel

        billingClient = BillingClient.newBuilder(activity)
            .setListener(this)
            .enablePendingPurchases()
            .build()

        billingClient?.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    // Billing client ready
                }
            }

            override fun onBillingServiceDisconnected() {
                // Retry connection
            }
        })
    }

    fun purchaseProduct(productId: String, result: MethodChannel.Result) {
        val productList = listOf(
            QueryProductDetailsParams.Product.newBuilder()
                .setProductId(productId)
                .setProductType(BillingClient.ProductType.SUBS)
                .build()
        )

        val params = QueryProductDetailsParams.newBuilder()
            .setProductList(productList)
            .build()

        billingClient?.queryProductDetailsAsync(params) { billingResult, productDetailsList ->
            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK && productDetailsList.isNotEmpty()) {
                val productDetails = productDetailsList[0]
                val offerToken = productDetails.subscriptionOfferDetails?.get(0)?.offerToken

                val productDetailsParamsList = listOf(
                    BillingFlowParams.ProductDetailsParams.newBuilder()
                        .setProductDetails(productDetails)
                        .setOfferToken(offerToken!!)
                        .build()
                )

                val flowParams = BillingFlowParams.newBuilder()
                    .setProductDetailsParamsList(productDetailsParamsList)
                    .build()

                billingClient?.launchBillingFlow(activity, flowParams)
            } else {
                result.error("BILLING_ERROR", "Failed to query product details", null)
            }
        }
    }

    override fun onPurchasesUpdated(billingResult: BillingResult, purchases: List<Purchase>?) {
        if (billingResult.responseCode == BillingClient.BillingResponseCode.OK && purchases != null) {
            for (purchase in purchases) {
                handlePurchase(purchase)
            }
        } else if (billingResult.responseCode == BillingClient.BillingResponseCode.USER_CANCELED) {
            methodChannel?.invokeMethod("purchaseCancelled", null)
        }
    }

    private fun handlePurchase(purchase: Purchase) {
        if (purchase.purchaseState == Purchase.PurchaseState.PURCHASED) {
            val result = mapOf(
                "success" to true,
                "productId" to purchase.products[0],
                "purchaseToken" to purchase.purchaseToken,
                "transactionId" to purchase.orderId
            )

            methodChannel?.invokeMethod("purchaseComplete", result)

            // Acknowledge purchase
            if (!purchase.isAcknowledged) {
                val params = AcknowledgePurchaseParams.newBuilder()
                    .setPurchaseToken(purchase.purchaseToken)
                    .build()

                billingClient?.acknowledgePurchase(params) { billingResult ->
                    // Handle acknowledgment
                }
            }
        }
    }

    fun restorePurchases(result: MethodChannel.Result) {
        val params = QueryPurchasesParams.newBuilder()
            .setProductType(BillingClient.ProductType.SUBS)
            .build()

        CoroutineScope(Dispatchers.IO).launch {
            billingClient?.queryPurchasesAsync(params) { billingResult, purchases ->
                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    result.success(purchases.map { purchase ->
                        mapOf(
                            "productId" to purchase.products[0],
                            "purchaseToken" to purchase.purchaseToken,
                            "transactionId" to purchase.orderId
                        )
                    })
                } else {
                    result.error("RESTORE_ERROR", "Failed to restore purchases", null)
                }
            }
        }
    }
}