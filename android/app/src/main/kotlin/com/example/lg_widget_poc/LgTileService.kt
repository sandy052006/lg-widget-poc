package com.example.lg_widget_poc

import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class LgTileService : TileService() {
    override fun onTileAdded() {
        super.onTileAdded()
        qsTile.state = Tile.STATE_INACTIVE
        qsTile.updateTile()
    }

    override fun onClick() {
        super.onClick()
        val currentlyActive = qsTile.state == Tile.STATE_ACTIVE
        qsTile.state = if (currentlyActive) Tile.STATE_INACTIVE else Tile.STATE_ACTIVE
        qsTile.updateTile()

        // THE FIX: Trigger the PendingIntent using .send()
        val pendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
            applicationContext, 
            Uri.parse("lgWidget://tile_toggle")
        )
        pendingIntent.send()
    }
}