 #!/bin/bash

# Get battery and AC adapter status from acpi
info=$(acpi -b)
ac_info=$(acpi -a)

icon=""
charge=$(echo "$info" | grep -oP '\d+(?=%)' | head -1)

# Extract time remaining (if present)
time_left=$(echo "$info" | grep -oP '\d{2}:\d{2}:\d{2}' | head -1)

# Check whether charger is connected
if echo "$ac_info" | grep -q "on-line"; then
    plugged_in=true
else
    plugged_in=false
fi

# Determine icon
if $plugged_in; then
    # Always show lightning bolt whenever charger is connected
    icon=""
else
    if [ "$charge" -gt 87 ]; then
        icon=""
    elif [ "$charge" -gt 63 ]; then
        icon=""
    elif [ "$charge" -gt 40 ]; then
        icon=""
    elif [ "$charge" -gt 15 ]; then
        icon=""
    else
        icon=""
    fi
fi

# Format tooltip message
tooltip="Battery: $charge%"

if [[ -n "$time_left" ]]; then
    if $plugged_in; then
        tooltip+="\nTime to full: $time_left"
    else
        tooltip+="\nTime remaining: $time_left"
    fi
fi

# Output JSON
echo "{\"text\": \"$icon $charge%\", \"tooltip\": \"${tooltip//\"/\\\"}\"}"
