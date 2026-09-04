#!/bin/bash

icon="󰘚"

# === GPU INFO ===
gpu_info=$(nvidia-smi \
    --query-gpu=utilization.gpu,memory.used,memory.total \
    --format=csv,noheader,nounits 2>/dev/null | head -n 1)

if [[ -n "$gpu_info" ]]; then
    IFS=',' read -r gpu_usage vram_used_mb vram_total_mb <<< "$gpu_info"

    # Strip whitespace
    gpu_usage=$(echo "$gpu_usage" | xargs)
    vram_used_mb=$(echo "$vram_used_mb" | xargs)
    vram_total_mb=$(echo "$vram_total_mb" | xargs)

    if [[ "$vram_total_mb" -gt 0 ]]; then
        vram_percent=$((100 * vram_used_mb / vram_total_mb))
    else
        vram_percent=0
    fi

    vram_display="${vram_used_mb}MiB / ${vram_total_mb}MiB (${vram_percent}%)"
else
    gpu_usage="N/A"
    vram_display="N/A"
fi

# === TOP GPU PROCESSES ===
process_list=$(
    nvidia-smi \
        --query-compute-apps=pid,process_name,used_gpu_memory \
        --format=csv,noheader,nounits 2>/dev/null |
    sort -t',' -k3 -nr |
    head -5 |
    awk -F',' '{
        gsub(/^[ \t]+|[ \t]+$/, "", $1)
        gsub(/^[ \t]+|[ \t]+$/, "", $2)
        gsub(/^[ \t]+|[ \t]+$/, "", $3)
        printf "PID: %s | %s | %s MiB\\n", $1, $2, $3
    }'
)

if [[ -z "$process_list" ]]; then
    process_list="No GPU-intensive processes found"
fi

# === TOOLTIP ===
tooltip="NVIDIA GPU Usage: ${gpu_usage}%\\nVRAM: ${vram_display}\\n\\nTop Processes:\\n${process_list}"

# Escape quotes for Waybar JSON
escaped_tooltip="${tooltip//\"/\\\"}"

# === JSON OUTPUT ===
echo "{\"text\": \"$icon ${gpu_usage}%\", \"tooltip\": \"$escaped_tooltip\"}"
