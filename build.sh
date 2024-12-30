#!/bin/bash

if [[ -z "${1}" ]]; then
    echo "No device specified."
    exit
fi

export TARGET_BOARD_PLATFORM="${1}"
export TARGET_PRODUCT="${2}"
export TARGET_BUILD_VARIANT=user
export ENABLE_DDK_BUILD=true
export ALLOW_UNSAFE_DDK_HEADERS=true

export ANDROID_BUILD_TOP=$(pwd)
export ANDROID_PRODUCT_OUT=${ANDROID_BUILD_TOP}/out/target/product/${TARGET_BOARD_PLATFORM}
export OUT_DIR=${ANDROID_BUILD_TOP}/out/msm-kernel-${TARGET_BOARD_PLATFORM}

export LTO=thin

export EXT_MODULES="
  ../vendor/qcom/opensource/mmrm-driver
  ../vendor/qcom/opensource/mm-drivers/hw_fence
  ../vendor/qcom/opensource/mm-drivers/msm_ext_display
  ../vendor/qcom/opensource/mm-drivers/sync_fence
  ../vendor/qcom/opensource/mm-sys-kernel/ubwcp
  ../vendor/qcom/opensource/audio-kernel
  ../vendor/qcom/opensource/securemsm-kernel
  ../vendor/qcom/opensource/spu-kernel
  ../vendor/qcom/opensource/synx-kernel
  ../vendor/qcom/opensource/camera-kernel
  ../vendor/qcom/opensource/dataipa/drivers/platform/msm
  ../vendor/qcom/opensource/datarmnet/core
  ../vendor/qcom/opensource/datarmnet-ext/aps
  ../vendor/qcom/opensource/datarmnet-ext/mem
  ../vendor/qcom/opensource/datarmnet-ext/offload
  ../vendor/qcom/opensource/datarmnet-ext/shs
  ../vendor/qcom/opensource/datarmnet-ext/perf
  ../vendor/qcom/opensource/datarmnet-ext/perf_tether
  ../vendor/qcom/opensource/datarmnet-ext/sch
  ../vendor/qcom/opensource/datarmnet-ext/wlan
  ../vendor/qcom/opensource/display-drivers/msm
  ../vendor/qcom/opensource/dsp-kernel
  ../vendor/qcom/opensource/eva-kernel
  ../vendor/qcom/opensource/fingerprint
  ../vendor/qcom/opensource/video-driver
  ../vendor/qcom/opensource/graphics-kernel
  ../vendor/qcom/opensource/touch-drivers
  ../vendor/qcom/opensource/wlan/platform
  ../vendor/qcom/opensource/wlan/qcacld-3.0/.kiwi_v2
  ../vendor/qcom/opensource/bt-kernel
  ../vendor/st/opensource/driver
  ../vendor/st/opensource/eSE-driver
  ../vendor/nxp/opensource/driver
  ../motorola/kernel/modules/drivers/ese/st54spi_gpio
  ../motorola/kernel/modules/drivers/mmi_annotate
  ../motorola/kernel/modules/drivers/moto_reboot_reason
  ../motorola/kernel/modules/drivers/moto_f_usbnet
  ../motorola/kernel/modules/drivers/mmi_relay
  ../motorola/kernel/modules/drivers/misc/mmi_sys_temp
  ../motorola/kernel/modules/drivers/moto_sched
  ../motorola/kernel/modules/drivers/moto_mmap_fault
  ../motorola/kernel/modules/drivers/moto_swap
  ../motorola/kernel/modules/drivers/misc/utag
  ../motorola/kernel/modules/drivers/power/bm_adsp_ulog
  ../motorola/kernel/modules/drivers/regulator/wl2868c
  ../motorola/kernel/modules/drivers/watchdogtest
  ../motorola/kernel/modules/drivers/moto_con_dfpar
  ../motorola/kernel/modules/drivers/sensors
  ../motorola/kernel/modules/drivers/mmi_info
  ../motorola/kernel/modules/drivers/power/mmi_charger
  ../motorola/kernel/modules/drivers/power/qti_glink_charger
  ../motorola/kernel/modules/drivers/power/mmi_lpd_mitigate
  ../motorola/kernel/modules/drivers/power/qpnp_adaptive_charge
  ../motorola/kernel/modules/drivers/misc/sx937x_multi
  ../motorola/kernel/modules/drivers/nfc/st21nfc
  ../motorola/kernel/modules/drivers/input/touchscreen/touchscreen_mmi
  ../motorola/kernel/modules/drivers/input/touchscreen/goodix_berlin_mmi
"

if [ "${TARGET_PRODUCT}" == "arcfox" ]; then
EXT_MODULES+="
  ../motorola/kernel/modules/drivers/power/cw2217b_fg_mmi
  ../motorola/kernel/modules/drivers/power/sc760x_charger_mmi
  ../motorola/kernel/modules/drivers/input/misc/fpc_fps_mmi
  ../motorola/kernel/modules/drivers/input/touchscreen/goodix_gt96x_mmi
"
fi

if [ "${TARGET_PRODUCT}" == "ctwo" ]; then
EXT_MODULES+="
  ../motorola/kernel/modules/drivers/input/misc/goodix_fod_mmi
  ../motorola/kernel/modules/drivers/uwb/qm35
  ../motorola/kernel/modules/drivers/input/misc/vl53L1_14_1_2
"
fi

echo "mmi_product_name =" \"${TARGET_PRODUCT}\" > ./kernel_platform/msm-kernel/moto_product.bzl

RECOMPILE_KERNEL=1 ./kernel_platform/build/android/prepare_vendor.sh ${TARGET_BOARD_PLATFORM} gki

