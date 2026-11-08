#!/usr/bin/env bash
# Per-app restrictions over adb; no root, config hardcoded here. Subcommands
# exist so breakage stays isolated and re-runnable singly; "check" never mutates.
#   ./android-restrict-apps.sh [network|background|permissions|gms|settings|check|all]
# Only uid >= 10000 apps are touched, so system components stay stock. That is
# why the "everyone else" sweeps rely entirely on the allow lists below: any
# package you depend on must be added to them.
#
# Everything applied persists across reboot. Undo one app:
#   adb shell cmd netpolicy remove restrict-background-blacklist <uid>
#   adb shell cmd appops set <pkg> RUN_ANY_IN_BACKGROUND allow

set -u

# ---- configuration -------------------------------------------------------

# adb invocation; add -s SERIAL here if more than one device is attached.
ADB=(adb)

# A work profile is a separate uid space; everything below scopes to this user.
USER_ID=${USER_ID:-0}

NETWORK_ALLOW=(
	InfinityLoop1309.NewPipeEnhanced
	com.android.location.fused
	com.android.providers.downloads
	com.android.providers.downloads.ui
	com.android.providers.media
	com.aurora.store
	com.brave.browser
	com.github.catfriend1.syncthingandroid
	com.github.catfriend1.syncthingfork
	com.google.android.gms
	com.google.android.gsf
	com.whatsapp
	net.thunderbird.android
	org.breezyweather
	org.fdroid.fdroid
	org.forkclient.messenger
	org.forkclient.messenger.beta
	org.telegram.messenger
	org.telegram.messenger.web
	org.thoughtcrime.securesms
	org.thunderdog.challegram
)

RUN_BACKGROUND=(
	InfinityLoop1309.NewPipeEnhanced
	com.android.emergency
	com.android.location.fused
	com.android.mtp
	com.android.musicfx
	com.android.providers.downloads
	com.android.providers.downloads.ui
	com.android.providers.media
	com.aurora.store
	com.best.deskclock
	com.brave.browser
	com.github.catfriend1.syncthingandroid
	com.github.catfriend1.syncthingfork
	com.google.android.apps.nexuslauncher
	com.google.android.gms
	com.google.android.gsf
	com.google.android.networkstack.tethering
	com.google.android.networkstack.tethering.overlay2021
	com.google.android.nfc
	com.google.android.nfc.overlay
	com.google.android.nfc.overlay.common
	com.google.android.pixelnfc
	com.google.android.telecomresources
	com.google.android.telecomresources.deprecated.overlay
	com.google.android.telecomresources.overlay
	com.google.android.telecomui
	com.google.pixel.camera.services
	com.maxmpz.audioplayer
	com.nvllz.stepsy
	com.termux
	com.whatsapp
	eu.faircode.netguard
	net.thunderbird.android
	org.breezyweather
	org.fdroid.fdroid
	org.fossify.calendar
	org.fossify.contacts
	org.fossify.filemanager
	org.fossify.gallery
	org.fossify.messages
	org.fossify.phone
	org.forkclient.messenger
	org.forkclient.messenger.beta
	org.telegram.messenger
	org.telegram.messenger.web
	org.thoughtcrime.securesms
	org.thunderdog.challegram
)

# background() also keeps any package whose name matches
# /calendar|clock|alarm|task/ on exact alarms; entries only escape that regex.
EXACT_ALARM_ALLOW=(
	# org.tasks
)

PERMISSIONS_REVOKE=(
	com.google.android.GoogleCamera
	com.google.android.apps.camera.services
	com.google.android.apps.nexuslauncher
	com.google.android.apps.wallpaper
	com.google.android.apps.wellbeing
	com.google.android.apps.work.oobconfig
	com.google.android.bluetooth
	com.google.android.captiveportallogin
	com.google.android.configupdater
	com.google.android.connectivitythermalpowermanager
	com.google.android.euicc
	com.google.android.euiccoverlay
	com.google.android.ext.services
	com.google.android.gms
	com.google.android.gsf
	com.google.android.inputmethod.latin
	com.google.android.iwlan
	com.google.android.networkstack
	com.google.android.nfc
	com.google.android.photopicker
	com.google.android.pixelsystemservice
	com.google.android.rkpdapp
	com.google.android.sdksandbox
	com.google.android.settings.intelligence
	com.google.android.soundpicker
	com.google.android.webview
	com.google.euiccpixel
	com.google.euiccpixel.overlay.gs201
	com.google.euiccpixel.permissions
	com.google.pixel.camera.services
)

# One "namespace key value" per entry: adb shell flattens argv with spaces, so
# each entry must land as three words with none inside the value.
SETTINGS=(
	"global adaptive_battery_management_enabled 1"
	"global app_standby_enabled 1"
	"global ble_scan_always_enabled 0"          # same for Bluetooth
	"global captive_portal_fallback_url https://connectivitycheck.grapheneos.network/generate_204"
	"global captive_portal_http_url http://connectivitycheck.grapheneos.network/generate_204"
	"global captive_portal_https_url https://connectivitycheck.grapheneos.network/generate_204"
	"global captive_portal_mode 0"
	"global captive_portal_other_fallback_url https://connectivitycheck.grapheneos.network/generate_204"
	"global mobile_data_always_active 0"
	"global network_recommendations_enabled 0"
	"global package_verifier_enable 0"
	"global upload_apk_enable 0"
	"global verifier_verify_adb_installs 0"
	"global wifi_networks_available_notification_on 0"
	"global wifi_scan_always_enabled 0"         # no background scans; on-demand ones still feed NLP
	"global wifi_wakeup_enabled 0"
	"global cached_apps_freezer enabled"
	"global smart_replies_enabled 0"
	"secure theft_detection_lock_setting 0"
	"global assisted_gps_enabled 1"
	"secure location_time_zone_detection_enabled 1"

	"secure doze_always_on 0"
	"global automatic_power_save_mode 0"
	"global low_power_trigger_level 50"

	# Battery Saver behavior constants (BatterySaverPolicy KEY_*), active
	# whenever saver runs, including the 50% schedule. Deltas vs stock full
	# saver: GNSS restricted only with the screen off (friendlier to the A-GPS
	# chain), datasaver doubles the netpolicy deny, brightness never dims.
	# enable_firewall clamps every uid outside the Doze whitelist, which
	# NETWORK_ALLOW does not cover; keep-alive apps need:
	#   adb shell dumpsys deviceidle whitelist +PKG
	"global battery_saver_constants enable_firewall=true,enable_datasaver=true,enable_night_mode=true,force_all_apps_standby=true,force_background_check=true,disable_aod=true,disable_launch_boost=true,disable_optional_sensors=true,disable_animation=false,disable_vibration=false,enable_quick_doze=true,defer_full_backup=true,defer_keyvalue_backup=true,enable_brightness_adjustment=false,adjust_brightness_factor=1.0,advertise_is_enabled=true,location_mode=1,soundtrigger_mode=1"
)

# ---- GMS-specific policy -------------------------------------------------
#
# FCM survives on POST_NOTIFICATIONS alone: INTERNET, WAKE_LOCK,
# RECEIVE_BOOT_COMPLETED and FOREGROUND_SERVICE are install-time, so nothing
# else FCM needs is revocable. DroidGuard runs as native code on signature
# perms, so the Integrity API needs no op below and attestation keeps
# passing. SUPL (A-GPS) lives in the GNSS HAL / modem, outside GMS.
#
# KEPT after the strips: the fused -> GMS network provider chain with
# FINE/COARSE/BACKGROUND location. The framework feeds the GNSS engine its
# position/time assistance through that chain; without it the engine stalls
# mid-lock: dozens of satellites in view, 0 used, no fix for minutes. Cost:
# Google's network positioning works again. Everything else Google could do
# with location stays stripped (reporting, sharing, semantic components,
# other location ops, MOCK_LOCATION).
#
# Ops absent on this Android version fail silently (2>/dev/null).
GMS_DENY_OPS=(
	# FINE/COARSE omitted on purpose: denying them here races aiding_keepup()
	# and leaves GNSS without injected position.
	MOCK_LOCATION

	BLUETOOTH_SCAN BLUETOOTH_CONNECT BLUETOOTH_ADVERTISE
	NEARBY_WIFI_DEVICES CHANGE_WIFI_STATE

	ACTIVITY_RECOGNITION BODY_SENSORS BODY_SENSORS_BACKGROUND
	HIGH_SAMPLING_RATE_SENSORS

	READ_CONTACTS WRITE_CONTACTS GET_ACCOUNTS
	READ_CALENDAR WRITE_CALENDAR

	READ_PHONE_STATE READ_PHONE_NUMBERS
	CALL_PHONE ANSWER_PHONE_CALLS
	READ_CALL_LOG WRITE_CALL_LOG

	READ_SMS WRITE_SMS SEND_SMS
	RECEIVE_SMS RECEIVE_MMS RECEIVE_WAP_PUSH

	CAMERA CAMERA_BACKGROUND RECORD_AUDIO

	READ_EXTERNAL_STORAGE WRITE_EXTERNAL_STORAGE
	READ_MEDIA_AUDIO READ_MEDIA_VIDEO READ_MEDIA_IMAGES
	READ_MEDIA_VISUAL_USER_SELECTED
	ACCESS_MEDIA_LOCATION MANAGE_EXTERNAL_STORAGE

	QUERY_ALL_PACKAGES GET_USAGE_STATS INTERACT_ACROSS_PROFILES
	ACCESS_NOTIFICATIONS READ_CLIPBOARD WRITE_CLIPBOARD PROJECT_MEDIA

	SYSTEM_ALERT_WINDOW USE_FULL_SCREEN_INTENT TURN_SCREEN_ON
	REQUEST_INSTALL_PACKAGES REQUEST_DELETE_PACKAGES

	REQUEST_COMPANION_PROFILE_APP_STREAMING
	REQUEST_COMPANION_PROFILE_AUTOMOTIVE_PROJECTION
	REQUEST_COMPANION_PROFILE_WATCH
	REQUEST_COMPANION_PROFILE_COMPUTER
	REQUEST_COMPANION_PROFILE_NEARBY_DEVICE_STREAMING
	REQUEST_COMPANION_SELF_MANAGED
)

# Names drift between GMS versions; "missing"/"refused" outcomes are expected.
# Never add components under the FCM / Play Integrity / infrastructure
# prefixes: .gcm. .droidguard. .playintegrity. .recaptcha. .safetynet.
# .auth. .checkin. .common. .chimera. .persistent. .phenotype. .gservices.
# .update. .location.
GMS_DISABLE=(
	# ads / analytics / measurement
	com.google.android.gms.ads.AdRequestBrokerService
	com.google.android.gms.ads.identifier.service.AdvertisingIdService
	com.google.android.gms.ads.social.GcmSchedulerWakeupService
	com.google.android.gms.analytics.AnalyticsService
	com.google.android.gms.analytics.AnalyticsJobService
	com.google.android.gms.analytics.CampaignTrackingService
	com.google.android.gms.measurement.PackageMeasurementReceiver
	com.google.android.gms.measurement.AppMeasurementReceiver
	com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver

	# Cast / Chromecast (the "Choose a device to connect" popup)
	com.google.android.gms.cast.media.CastMediaRouteProviderService
	com.google.android.gms.cast.media.CastMediaRouteControllerDialogActivity
	com.google.android.gms.cast.remote_display.service.RemoteDisplayProviderService
	com.google.android.gms.cast.mirroring.MirroringProviderService
	com.google.android.gms.matchstick.MatchstickService
	com.google.android.gms.matchstick.messaging.MessagingService
	com.google.android.gms.chromesync.ChromeSyncService

	# Nearby / Cross-device / Fast Pair / D2D setup
	com.google.android.gms.nearby.sharing.SharingService
	com.google.android.gms.nearby.sharing.ShareSheetActivity
	com.google.android.gms.nearby.sharing.ReceiveSurfaceActivity
	com.google.android.gms.nearby.messages.service.NearbyMessagesService
	com.google.android.gms.nearby.discovery.fastpair.service.FastPairService
	com.google.android.gms.nearby.discovery.service.DiscoveryService
	com.google.android.gms.nearby.presence.service.PresenceService
	com.google.android.gms.nearby.connection.service.NearbyConnectionsService
	com.google.android.gms.nearby.exposurenotification.service.ExposureNotificationService
	com.google.android.gms.smartdevice.d2d.services.SourceD2dTransportService
	com.google.android.gms.smartdevice.d2d.services.TargetD2dTransportService
	com.google.android.gms.smartdevice.setup.accounts.AccountsService

	# Location extras (fused provider tree under .location.* stays)
	com.google.android.gms.locationsharingreporter.service.reporter.LocationReporterService
	com.google.android.gms.locationsharingreporter.service.ImmediateLocationProducer
	com.google.android.gms.reporting.service.ReportingSyncService
	com.google.android.gms.semanticlocation.services.SemanticLocationService
	com.google.android.gms.constellation.ConstellationService

	# Fitness / on-device ML / vision
	com.google.android.gms.fitness.service.FitAsyncService
	com.google.android.gms.fitness.service.FitApiService
	com.google.android.gms.fitness.service.recording.RecordingService
	com.google.android.gms.learning.LearningService
	com.google.android.gms.learning.federated.training.service.FederatedTrainingService
	com.google.android.gms.ondevicepersonalization.OnDevicePersonalizationService
	com.google.android.gms.ondevicepersonalization.federatedcompute.services.FederatedComputeService
	com.google.android.gms.vision.face.service.FaceService
	com.google.android.gms.vision.barcode.service.BarcodeService
	com.google.android.gms.vision.text.service.TextService

	# Backup / D2D migration
	com.google.android.gms.backup.BackupTransportService
	com.google.android.gms.backup.migrate.service.D2dMigrateService
	com.google.android.gms.backup.component.D2dTransportReceiver
	com.google.android.gms.backup.component.FullBackupJobService
	com.google.android.gms.mdm.services.receivers.GcmReceiverService

	# Wallet / TapAndPay (banking apps using Play Integrity for their OWN app
	# still work; only Google Wallet stops)
	com.google.android.gms.tapandpay.service.TapAndPayService
	com.google.android.gms.wallet.service.WalletService
	com.google.android.gms.payse.service.PaySeService
	com.google.android.gms.subscriptions.service.SubscriptionsService

	# Trust Agent / Smart Lock
	com.google.android.gms.trustagent.GoogleTrustAgent
	com.google.android.gms.trustagent.trustlet.OnBodyDetectionTrustletService
	com.google.android.gms.trustagent.trustlet.NfcTrustletService
	com.google.android.gms.trustagent.trustlet.BluetoothTrustletService
	com.google.android.gms.trustagent.trustlet.PlaceTrustletService

	# Feedback / help / usage reporting / stats
	com.google.android.gms.feedback.FeedbackAsyncService
	com.google.android.gms.feedback.PsdAsyncService
	com.google.android.gms.googlehelp.service.GoogleHelpService
	com.google.android.gms.googlehelp.helpchat.HelpChatService
	com.google.android.gms.usagereporting.UsageReportingService
	com.google.android.gms.stats.service.StatsCollectorService
	com.google.android.gms.playlog.uploader.PlayLogUploaderService

	# Family / Kids
	com.google.android.gms.kids.chimera.KidsIntentOperationService
	com.google.android.gms.family.v2.FamilyIntentOperationService

	# Reminders / Places / People
	com.google.android.gms.reminders.service.RemindersIntentService
	com.google.android.gms.reminders.notification.NotificationTicklerService
	com.google.android.gms.places.service.PlacesService
	com.google.android.gms.people.service.people.PeopleService
	com.google.android.gms.people.sync.focus.PeopleSyncService

	# Wearable / Games / Instant Apps / Speech / Voice
	com.google.android.gms.wearable.service.WearableService
	com.google.android.gms.wearable.node.NodeService
	com.google.android.gms.games.service.GamesService
	com.google.android.gms.games.playlog.service.PlayLoggerService
	com.google.android.gms.games.notification.GamesNotificationService
	com.google.android.gms.instantapps.service.InstantAppsService
	com.google.android.gms.instantapps.routing.RoutingService
	com.google.android.gms.speech.service.SpeechService
	com.google.android.gms.voice.service.VoiceService
)

# --------------------------------------------------------------------------

adbsh()
{
	"${ADB[@]}"      shell "$@"
}

# "settings"|"all" only: the read-only checks must stay read-only.
settings_tweaks()
{
	echo "== Settings =="
	adbsh bmgr enable false
	adbsh svc nfc disable
	adbsh "settings put global location_ignore_settings_package_whitelist ''"
	# adb shell joins argv with spaces: each entry arrives as three words.
	adbsh sh -s -- "${SETTINGS[@]}" << 'EOF'
while [ $# -ge 3 ]; do
  settings put "$1" "$2" "$3" && echo "  $1 $2 = $3"
  shift 3
done
EOF
}

NETWORK_ALLOW_STR="${NETWORK_ALLOW[*]-}"
RUN_BACKGROUND_STR="${RUN_BACKGROUND[*]-}"
EXACT_ALARM_ALLOW_STR="${EXACT_ALARM_ALLOW[*]-}"
PERMISSIONS_REVOKE_STR="${PERMISSIONS_REVOKE[*]-}"

network()
{
	echo "== Background mobile data policy =="
	# Default-deny (Data Saver) instead of per-app blacklist entries: Settings
	# reverts per-app additions on every boot.
	adbsh cmd netpolicy set restrict-background true > /dev/null 2>&1
	# Marks saved Wi-Fi networks metered; newly joined ones arrive unmetered,
	# so re-run after joining.
	echo "-- marking saved Wi-Fi networks metered --"
	adbsh sh -s << 'WIFI'
cmd netpolicy list wifi-networks | while IFS= read -r line; do
  id=${line%;*}
  [ -n "$id" ] || continue
  cmd netpolicy set metered-network "$id" true >/dev/null 2>&1
  echo "  metered: $id"
done
WIFI
	adbsh sh -s -- "$USER_ID" "$NETWORK_ALLOW_STR" << 'EOF'
# $1 = user id; adb flattens the list into $2..$N.
U="$1"; shift
NALLOW="$*"
inlist() { n=$1; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }
pm list packages -U --user "$U" | while IFS=' ' read -r a b; do
  pkg=${a#package:}; uid=${b#uid:}
  case "$uid" in ''|*[!0-9]*) continue;; esac
  [ "$uid" -ge 10000 ] || continue
  if inlist "$pkg" $NALLOW; then
    echo allowing "$pkg"
    cmd netpolicy remove restrict-background-blacklist "$uid" >/dev/null 2>&1
    cmd netpolicy add    restrict-background-whitelist "$uid" >/dev/null 2>&1
  else
    echo blocking "$pkg"
    cmd netpolicy remove restrict-background-whitelist "$uid" >/dev/null 2>&1
    cmd netpolicy add    restrict-background-blacklist "$uid" >/dev/null 2>&1
  fi
done
EOF

	echo "-- background mobile data, read back from the phone --"
	adbsh sh -s -- "$USER_ID" << 'PROBE'
U="$1"
cmd netpolicy list restrict-background-blacklist | tr ' ' '\n' | grep -E '^[0-9]+$' | sort -u > /data/local/tmp/np_bl
cmd netpolicy list restrict-background-whitelist | tr ' ' '\n' | grep -E '^[0-9]+$' | sort -u > /data/local/tmp/np_wl
echo "DISABLED (background mobile denied):"
pm list packages -U --user "$U" | sed 's/^package://; s/ uid:/ /' | while read -r pkg uid; do
  grep -qxF "$uid" /data/local/tmp/np_bl && echo "  $pkg"
done | sort
echo "ENABLED (background mobile unrestricted):"
pm list packages -U --user "$U" | sed 's/^package://; s/ uid:/ /' | while read -r pkg uid; do
  grep -qxF "$uid" /data/local/tmp/np_wl && echo "  $pkg"
done | sort
rm -f /data/local/tmp/np_bl /data/local/tmp/np_wl
PROBE

}

background()
{
	echo "== Background execution policy =="
	adbsh sh -s -- "$USER_ID" "$RUN_BACKGROUND_STR" << 'EOF'
# $1 = user id; adb flattens the list into $2..$N.
U="$1"; shift
RALLOW="$*"
inlist() { n=$1; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }
pm list packages -U --user "$U" | while IFS=' ' read -r a b; do
  pkg=${a#package:}; uid=${b#uid:}
  case "$uid" in ''|*[!0-9]*) continue;; esac
  [ "$uid" -ge 10000 ] || continue
  if inlist "$pkg" $RALLOW; then
    cmd appops set --user "$U" "$pkg" RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1
  else
    cmd appops set --user "$U" "$pkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1
    am set-standby-bucket --user "$U" "$pkg" restricted >/dev/null 2>&1
    echo "  bg-run restricted: $pkg"
  fi
done
EOF

	echo "-- exact alarm policy (deny except calendar/clock/alarm) --"
	adbsh sh -s -- "$USER_ID" "$EXACT_ALARM_ALLOW_STR" << 'ALARM'
U="$1"; shift
EAALLOW="$*"
inlist() { n=$1; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }
pm list packages -U --user "$U" | while IFS=' ' read -r a b; do
  pkg=${a#package:}; uid=${b#uid:}
  case "$uid" in ''|*[!0-9]*) continue;; esac
  [ "$uid" -ge 10000 ] || continue
  if printf '%s\n' "$pkg" | grep -qiE 'calendar|clock|alarm|task' || inlist "$pkg" $EAALLOW; then
    cmd appops set --user "$U" "$pkg" SCHEDULE_EXACT_ALARM default >/dev/null 2>&1
  else
    cmd appops set --user "$U" "$pkg" SCHEDULE_EXACT_ALARM ignore  >/dev/null 2>&1
    echo "  inexact-only: $pkg"
  fi
done
ALARM

	echo "-- background running, read back from the phone --"
	adbsh sh -s -- "$USER_ID" << 'PROBE'
U="$1"
: > /data/local/tmp/bg_en; : > /data/local/tmp/bg_di
pm list packages -U --user "$U" | sed 's/^package://; s/ uid:/ /' | while read -r pkg uid; do
  case "$uid" in ''|*[!0-9]*) continue;; esac
  [ "$uid" -ge 10000 ] || continue
  m=$(cmd appops get --user "$U" "$pkg" RUN_ANY_IN_BACKGROUND 2>/dev/null | sed -n 's/.*RUN_ANY_IN_BACKGROUND: \([a-z]*\).*/\1/p')
  case "$m" in
    ignore|deny) echo "$pkg" >> /data/local/tmp/bg_di;;
    allow|default|foreground) echo "$pkg" >> /data/local/tmp/bg_en;;
  esac
done
echo "ENABLED (allowed to run in background):"; sort -u /data/local/tmp/bg_en | sed 's/^/  /'
echo "DISABLED (background running restricted):"; sort -u /data/local/tmp/bg_di | sed 's/^/  /'
rm -f /data/local/tmp/bg_en /data/local/tmp/bg_di
PROBE
}

permissions()
{
	echo "== Permission revocation =="
	[ "${#PERMISSIONS_REVOKE[@]}" -gt 0 ] || return 0
	# pm revoke accepts only runtime perms, so install-time entries inside
	# the granted=true sweep fail harmlessly and need no filter.
	adbsh sh -s -- "$USER_ID" "$PERMISSIONS_REVOKE_STR" << 'EOF'
U="$1"; shift
PSTRIP="$*"
inlist() { n=$1; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }
pm list packages --user "$U" | sed 's/^package://' | while read -r pkg; do
  for perm in ACCESS_FINE_LOCATION ACCESS_COARSE_LOCATION ACCESS_BACKGROUND_LOCATION; do
    pm revoke --user "$U" "$pkg" "android.permission.$perm" 2>/dev/null
  done
  if inlist "$pkg" $PSTRIP; then
    echo "  $pkg"
    dumpsys package "$pkg" \
      | sed -n 's/^[[:space:]]*\([a-zA-Z0-9_.]*\): granted=true.*/\1/p' \
      | sort -u \
      | while read -r perm; do
          pm revoke --user "$U" "$pkg" "$perm" 2>/dev/null && echo "    revoked $perm"
        done
  fi
done
EOF
	aiding_keepup
}

# The fused -> GMS network provider chain feeds the GNSS engine its injected
# position and time; without the grant-back the engine converges from
# broadcast aid alone and stalls: strong sats in view, 0 used, no fix for
# minutes. The loops live in one heredoc because list args do not survive
# adb shell argv flattening.
aiding_keepup()
{
	echo "== A-GPS: aiding chain location keep-up =="
	adbsh sh -s -- "$USER_ID" << 'EOF'
U="$1"
for pkg in com.android.location.fused com.google.android.gms; do
  for perm in ACCESS_FINE_LOCATION ACCESS_COARSE_LOCATION ACCESS_BACKGROUND_LOCATION; do
    pm grant --user "$U" "$pkg" "android.permission.$perm" 2>/dev/null \
      && echo "  granted $perm: $pkg"
  done
done
for op in FINE_LOCATION COARSE_LOCATION; do
  cmd appops set --user "$U" com.google.android.gms "$op" default 2>/dev/null \
    && echo "  default: $op"
done
EOF
}

gms_strip()
{
	echo "== GMS: appops (keep POST_NOTIFICATION + location aiding) =="
	_strip_google_framework com.google.android.gms 1
	echo "== GSF: appops (deny all) =="
	_strip_google_framework com.google.android.gsf 0
	aiding_keepup
}

# $1 = package; $2 = 1 keeps POST_NOTIFICATIONS (FCM). The revoke pass is not
# optional: appops ignore silently flips back to allow while the runtime
# grant remains (pm revoke rejects install-time entries harmlessly).
_strip_google_framework()
{
	adbsh sh -s -- "$USER_ID" "$1" "$2" << 'REVOKE'
U="$1"; P="$2"; K="$3"
dumpsys package "$P" \
  | sed -n 's/^[[:space:]]*\(android\.[a-zA-Z0-9_.]*\): granted=true.*/\1/p' \
  | sort -u \
  | while read -r perm; do
      [ "$K" = "1" ] && [ "$perm" = "android.permission.POST_NOTIFICATIONS" ] && continue
      pm revoke --user "$U" "$P" "$perm" 2>/dev/null \
        && echo "  revoke: $perm"
    done
REVOKE
	for op in "${GMS_DENY_OPS[@]}"; do
		adbsh cmd appops set --user "$USER_ID" "$1" "$op" ignore 2>/dev/null \
			&& echo "  ignore: $op"
	done
	if [ "$2" = "1" ]; then
		# NMS checks the runtime perm too, and the sweep above stripped it.
		adbsh pm grant --user "$USER_ID" "$1" android.permission.POST_NOTIFICATIONS 2>/dev/null
		adbsh cmd appops set --user "$USER_ID" "$1" POST_NOTIFICATION allow >/dev/null 2>&1
		echo "  allow:  POST_NOTIFICATION"
	fi
}

gms_components()
{
	# Unwired on stock Pixels: PMS rejects shell-side component changes on the
	# protected GMS package with SecurityException. Only usable on ROMs with
	# a broader shell UID; invoke by hand there.
	echo "== GMS: disable submodule components =="
	for c in "${GMS_DISABLE[@]}"; do
		out=$(adbsh pm disable-user --user "$USER_ID" "com.google.android.gms/$c" 2>&1)
		case "$out" in
			*"new state: disabled-user"*)      echo "  off:      $c" ;;
			*"Cannot change component state"*) echo "  refused:  $c" ;;
			*"does not exist"*|*"Unknown component"*|*"no such component"*)
			                                    echo "  missing:  $c" ;;
			*)                                  echo "  unknown:  $c :: $out" ;;
		esac
	done
}

# Post-strip probe; the services dump exists because Chimera modules can run
# without ever appearing in the manifest-disable results.
gms_probe()
{
	echo "== GMS/GSF: verification probe =="
	for pkg in com.google.android.gms com.google.android.gsf; do
		echo "==== $pkg ===="
		adbsh sh -s -- "$USER_ID" "$pkg" << 'PROBE'
U="$1"; P="$2"

echo "-- runtime perms still granted --"
# The perms section prints once per profile (user 0 + private space); sort -u collapses.
dumpsys package "$P" 2>/dev/null \
  | sed -n '/runtime permissions:/,/install permissions:/{//!p}' \
  | grep 'granted=true' \
  | sed 's/^[[:space:]]*//; s/: granted=true.*//' \
  | sort -u \
  | sed 's/^/  /'

echo "-- appops set to something other than default --"
cmd appops get --user "$U" "$P" 2>/dev/null \
  | grep -Ev 'mode=default|: default$' \
  | sed 's/^/  /'

echo "-- components with enabled=false --"
pm dump "$P" 2>/dev/null \
  | grep -B3 'enabled=false' \
  | grep -oE "$P/[A-Za-z0-9_.\$]+" \
  | sort -u | sed 's/^/  /'

echo "-- services currently running --"
dumpsys activity services "$P" 2>/dev/null \
  | grep -oE "$P/[A-Za-z0-9_.\$]+" \
  | sort -u | sed 's/^/  /'
PROBE
	done
}

# Read-only divergence audit against this file's config; an empty section
# means good. Worth running after boot (priv-perm re-grants) and after Wi-Fi.
check_network()
{
	echo "== check: network =="
	adbsh sh -s -- "$USER_ID" "$NETWORK_ALLOW_STR" << 'EOF'
U="$1"; shift
NALLOW="$*"
inlist() { n=$1; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }
rb=$(cmd netpolicy get restrict-background 2>/dev/null | tr -d '[:space:]')
[ "$rb" = "true" ] || echo "  restrict-background: ${rb:-unset} (expected true)"
cmd netpolicy list restrict-background-blacklist | tr ' ' '\n' | grep -E '^[0-9]+$' | sort -u > /data/local/tmp/np_bl
cmd netpolicy list restrict-background-whitelist | tr ' ' '\n' | grep -E '^[0-9]+$' | sort -u > /data/local/tmp/np_wl
pm list packages -U --user "$U" | while IFS=' ' read -r a b; do
  pkg=${a#package:}; uid=${b#uid:}
  case "$uid" in ''|*[!0-9]*) continue;; esac
  [ "$uid" -ge 10000 ] || continue
  in_bl=0; in_wl=0
  grep -qxF "$uid" /data/local/tmp/np_bl && in_bl=1
  grep -qxF "$uid" /data/local/tmp/np_wl && in_wl=1
  if inlist "$pkg" $NALLOW; then
    [ "$in_wl" = "1" ] || echo "  should ALLOW, not whitelisted: $pkg"
    [ "$in_bl" = "0" ] || echo "  should ALLOW, still blacklisted: $pkg"
  else
    [ "$in_bl" = "1" ] || echo "  should DENY, not blacklisted: $pkg"
    [ "$in_wl" = "0" ] || echo "  should DENY, still whitelisted: $pkg"
  fi
done
cmd netpolicy list wifi-networks | sort -u | while IFS= read -r line; do
  [ -n "$line" ] || continue
  id=${line%;*}; m=${line##*;}
  [ "$m" = "true" ] || echo "  wifi not metered: $id"
done
rm -f /data/local/tmp/np_bl /data/local/tmp/np_wl
EOF
}

check_background()
{
	echo "== check: background =="
	# One list per shell call: adb flattening destroys anything past the
	# first positional of a second list. shift/$* below stays safe.
	adbsh sh -s -- "$USER_ID" "$RUN_BACKGROUND_STR" << 'EOF'
U="$1"; shift
RALLOW="$*"
inlist() { n=$1; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }
pm list packages -U --user "$U" | while IFS=' ' read -r a b; do
  pkg=${a#package:}; uid=${b#uid:}
  case "$uid" in ''|*[!0-9]*) continue;; esac
  [ "$uid" -ge 10000 ] || continue
  bg=$(cmd appops get --user "$U" "$pkg" RUN_ANY_IN_BACKGROUND 2>/dev/null | sed -n 's/.*RUN_ANY_IN_BACKGROUND: \([a-z]*\).*/\1/p' | head -n 1)
  if inlist "$pkg" $RALLOW; then
    case "$bg" in
      allow|default|foreground|"") ;;
      *) echo "  bg should be allow, is $bg: $pkg" ;;
    esac
  else
    case "$bg" in
      ignore|deny) ;;
      *) echo "  bg should be ignore, is ${bg:-unset}: $pkg" ;;
    esac
  fi
done
EOF
	adbsh sh -s -- "$USER_ID" "$EXACT_ALARM_ALLOW_STR" << 'EOF'
U="$1"; shift
EAALLOW="$*"
inlist() { n=$1; shift; for x in "$@"; do [ "$x" = "$n" ] && return 0; done; return 1; }
pm list packages -U --user "$U" | while IFS=' ' read -r a b; do
  pkg=${a#package:}; uid=${b#uid:}
  case "$uid" in ''|*[!0-9]*) continue;; esac
  [ "$uid" -ge 10000 ] || continue
  ea=$(cmd appops get --user "$U" "$pkg" SCHEDULE_EXACT_ALARM 2>/dev/null | sed -n 's/.*SCHEDULE_EXACT_ALARM: \([a-z]*\).*/\1/p' | head -n 1)
  if printf '%s\n' "$pkg" | grep -qiE 'calendar|clock|alarm|task' || inlist "$pkg" $EAALLOW; then
    case "$ea" in
      allow|default|"") ;;
      *) echo "  exact-alarm should be default, is $ea: $pkg" ;;
    esac
  else
    case "$ea" in
      ignore|deny) ;;
      *) echo "  exact-alarm should be ignore, is ${ea:-unset}: $pkg" ;;
    esac
  fi
done
EOF
}

check_permissions()
{
	echo "== check: permissions =="
	adbsh sh -s -- "$USER_ID" "$PERMISSIONS_REVOKE_STR" << 'EOF'
U="$1"; shift
PSTRIP="$*"
# query-op sweeps permissive ops once instead of per package; the two listed
# aiding members are the expected permissive packages.
for op in FINE_LOCATION COARSE_LOCATION; do
  for mode in allow foreground; do
    cmd appops query-op --user "$U" "$op" "$mode" 2>/dev/null | sort -u | while read -r pkg; do
      case " com.android.location.fused com.google.android.gms " in *" $pkg "*) continue;; esac
      [ -n "$pkg" ] && echo "  loc $op=$mode: $pkg"
    done
  done
done
# The aiding chain must hold its grants.
for pkg in com.android.location.fused com.google.android.gms; do
  for perm in ACCESS_FINE_LOCATION ACCESS_COARSE_LOCATION ACCESS_BACKGROUND_LOCATION; do
    d=$(dumpsys package "$pkg" 2>/dev/null | grep -F "android.permission.$perm: granted=true" | head -n 1)
    [ -n "$d" ] || echo "  aiding chain missing $perm: $pkg"
  done
done
for pkg in $PSTRIP; do
  granted=$(dumpsys package "$pkg" 2>/dev/null \
    | sed -n '/runtime permissions:/,/install permissions:/{//!p}' \
    | grep 'granted=true' \
    | sed 's/^[[:space:]]*//; s/: granted=true.*//' \
    | sort -u)
  if [ -n "$granted" ]; then
    echo "  runtime perms still granted on $pkg:"
    printf '%s\n' "$granted" | sed 's/^/    /'
  fi
done
EOF
}

check_gms()
{
	echo "== check: gms =="
	for pkg in com.google.android.gms com.google.android.gsf; do
		keep=0
		[ "$pkg" = "com.google.android.gms" ] && keep=1
		echo "-- $pkg --"
		# One op per positional (via [@] expansion) because flattened argv
		# merges a quoted list into its first element; shift 3 walks the rest.
		adbsh sh -s -- "$USER_ID" "$pkg" "$keep" "${GMS_DENY_OPS[@]}" << 'EOF'
U="$1"; P="$2"; K="$3"; shift 3
granted=$(dumpsys package "$P" 2>/dev/null \
  | sed -n '/runtime permissions:/,/install permissions:/{//!p}' \
  | grep 'granted=true' \
  | sed 's/^[[:space:]]*//; s/: granted=true.*//' \
  | sort -u)
if [ "$K" = "1" ]; then
  granted=$(printf '%s\n' "$granted" | grep -vE '^android\.permission\.(POST_NOTIFICATIONS|ACCESS_(FINE|COARSE|BACKGROUND)_LOCATION)$')
fi
if [ -n "$granted" ]; then
  echo "  runtime perms still granted (expected: notification + location aiding):"
  printf '%s\n' "$granted" | sed 's/^/    /'
fi
for op in "$@"; do
  m=$(cmd appops get --user "$U" "$P" "$op" 2>/dev/null | sed -n "s/.*$op: \([a-z]*\).*/\1/p" | head -n 1)
  case "$m" in
    ignore|deny|"") ;;
    *) echo "  op $op not ignored, is $m" ;;
  esac
done
if [ "$K" = "1" ]; then
  m=$(cmd appops get --user "$U" "$P" POST_NOTIFICATION 2>/dev/null | sed -n 's/.*POST_NOTIFICATION: \([a-z]*\).*/\1/p' | head -n 1)
  case "$m" in
    allow|"") ;;
    *) echo "  POST_NOTIFICATION not allow, is $m" ;;
  esac
fi
EOF
	done
}

check_settings()
{
	echo "== check: settings =="
	adbsh sh -s -- "${SETTINGS[@]}" << 'EOF'
while [ $# -ge 3 ]; do
  v=$(settings get "$1" "$2" 2>/dev/null)
  [ "$v" = "$3" ] || echo "  $1 $2 is ${v:-unset}, expected $3"
  shift 3
done
EOF
}

check()
{
	check_settings
	check_network
	check_background
	check_permissions
	check_gms
}

if ! "${ADB[@]}" get-state > /dev/null 2>&1; then
	echo "No device. Connect one and enable USB debugging." >&2
	exit 1
fi

case "${1:-all}" in
	network | internet) network ;;
	background | bg) background ;;
	permissions | perms) permissions ;;
	gms) gms_strip; gms_probe ;;
	settings) settings_tweaks ;;
	check) check ;;
	all)
		settings_tweaks
		network
		background
		permissions
		gms_strip
		gms_probe
		;;
	*)
		echo "usage: $0 [network|background|permissions|gms|settings|check|all]" >&2
		exit                                                                 1
		;;
esac

echo "Done."
